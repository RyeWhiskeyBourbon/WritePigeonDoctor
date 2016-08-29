//
//  RWChatManager.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/7/26.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWChatManager.h"
#import "XZUMComPullRequest.h"
#import "RegisterViewController.h"
#import <AFNetworking.h>

NSString *QueueName = @"DownLoadQueue";
NSString *HeaderOperation = @"HeaderOperation";

const NSString *messageTextBody = @"messageTextBody";
const NSString *messageImageName = @"messageImageName";
const NSString *messageImageBody = @"messageImageBody";
const NSString *messageVoiceName = @"messageVoiceName";
const NSString *messageVoiceBody = @"messageVoiceBody";
const NSString *messageVoiceDuration = @"messageVoiceDuration";
const NSString *messageLocationLatitude = @"messageLocationLatitude";
const NSString *messageLocationLongitude = @"messageLocationLongitude";
const NSString *messageLocationAddress = @"messageLocationAddress";
const NSString *messageVideoName = @"messageVideoName";
const NSString *messageVideoBody = @"messageVideoBody";
const NSString *conversationTo = @"onversationTo";
const NSString *UMID = @"UMID";
const NSString *RWNewMessageNotification = @"RWNewMessageNotification";
const NSString *RWDroppedNotification = @"RWDroppedNotification";
const NSString *RWRemovedFromServerNotification = @"RWRemovedFromServerNotification";
const NSString *RWLoginFinishNotification = @"RWLoginFinishNotification";
const NSString *RWAutoLoginNotification = @"RWAutoLoginNotification";
const NSString *RWNetworkReachabilityNotification = @"RWNetworkReachabilityNotification";
const NSString *RWConnectionStateNotification = @"RWConnectionStateNotification";
const NSString *RWHeaderMessageToObserve = @"RWHeaderMessageToObserve;";
const NSString *RWLoginFromOtherDeviceNotification =
                                                @"RWLoginFromOtherDeviceNotification";
const NSString *RWHeaderDownLoadFinishNotification =
                                                @"RWHeaderDownLoadFinishNotification";

@implementation RWChatManager

BOOL _found_response(id delegate,NSString *selector)
{
    if (delegate && [delegate respondsToSelector:NSSelectorFromString(selector)])
    {
        return YES;
    }
    
    return NO;
}

void _send_notification(const NSString *name,id message)
{
    [RWChatManager sendNotificationWithName:name message:message];
}

void _notification(const NSString *name,void(^block)(NSNotification * _Nonnull note))
{
    [RWChatManager observeNotification:name usingblock:block];
}

+ (instancetype)defaultManager
{
    static RWChatManager *_default = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _default = [super allocWithZone:NULL];
        [_default setDefaultSettings];
    });
    
    return _default;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [RWChatManager defaultManager];
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return [RWSettingsManager systemSettings];
}

+ (id)mutableCopyWithZone:(struct _NSZone *)zone
{
    return [RWSettingsManager systemSettings];
}

- (void)setDefaultSettings
{
    [self addNetworkStatusObserver];
    
    _client = [EMClient sharedClient];
    _chatManager = _client.chatManager;
    _connectionState = EMConnectionDisconnected;
    _statusForLink = RWLinkStateOfUnLink;
    
    [_client addDelegate:self delegateQueue:nil];
    [_chatManager addDelegate:self delegateQueue:nil];
    
    _allSessions = [[_chatManager loadAllConversationsFromDB] mutableCopy];
    _baseManager = [RWDataBaseManager defaultManager];
    
    if ([SETTINGS_VALUE(__AUTO_LOGIN__) boolValue])
    {
        RWUser *user = [_baseManager getDefualtUser];
        
        if (user)
        {
            _statusForLink = RWLinkStateOfAutoLogin;
            send_notification(RWAutoLoginNotification,nil);
            
            RWRequsetManager *request = [[RWRequsetManager alloc] init];
            request.delegate = self;
            
            [request userinfoWithUsername:user.username AndPassword:user.password];
        }
    }
    
    _downLoadQueue = [[NSOperationQueue alloc] init];
    _downLoadQueue.name = QueueName;
    _downLoadQueue.maxConcurrentOperationCount = 15;
    
    notification_observe(RWHeaderMessageToObserve,^(NSNotification * _Nonnull note) {
        
        NSArray *operations = _downLoadQueue.operations;
        
        for (NSOperation *operation in operations)
        {
            if ([operation.name isEqualToString:HeaderOperation])
            {
                return ;
            }
        }
        
        send_notification(RWHeaderDownLoadFinishNotification,nil);
    });
}


- (void)userLoginSuccess:(BOOL)success responseMessage:(NSString *)responseMessage
{
    if (!success)
    {
        send_notification(RWLoginFinishNotification,@(NO));
        _statusForLink = RWLinkStateOfUnLink;
        
        UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        
        if (!_reachabilityStatus)
        {
            [RWSettingsManager promptToViewController:tabbar
                                                Title:@"当前无网络，请检查网络"
                                             response:nil];
            
            return;
        }
        
        NSString *title = responseMessage?
                          [NSString stringWithFormat:@"自动登录失败\nreason：%@",responseMessage]:@"自动登录失败";
        
        [RWSettingsManager promptToViewController:tabbar
                                            Title:title
                                         response:^{
                                             
                                             [tabbar toLoginViewController];
                                         }];
        return;
    }
    
     _statusForLink = RWLinkStateOfLoginFinish;
    send_notification(RWLoginFinishNotification,@(YES));
    
    if ([RWDataBaseManager perfectPersonalInformation])
    {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UITabBarController *tab = (UITabBarController *)window.rootViewController;
        
        [tab toPerfectPersonalInformation];
    }
}

- (void)addNetworkStatusObserver
{
    AFNetworkReachabilityManager *statusManager = [AFNetworkReachabilityManager sharedManager];
    
    [statusManager startMonitoring];
    
    [statusManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         _reachabilityStatus = status;
         _statusForLink = status?_statusForLink:RWLinkStateOfDropped;
         
         send_notification(RWNetworkReachabilityNotification,@(status));
     }];
}

- (void)createConversationWithID:(NSString *)ID extension:(NSDictionary *)extension
{
    _faceSession =[_chatManager getConversation:ID
                                           type:EMConversationTypeChat
                               createIfNotExist:YES];
    
    _faceSession.ext = extension;
    
    _allSessions = [[_chatManager loadAllConversationsFromDB] mutableCopy];
}

- (void)removeFaceConversation
{
    _faceSession = nil;
}

- (void)didReceiveMessages:(NSArray *)aMessages
{
    for (EMMessage *msg in aMessages)
    {
        send_notification(RWNewMessageNotification,nil);
        
        [XZUMComPullRequest fecthUserProfileWithUid:_faceSession.ext[UMID]
                                             source:nil
                                         source_uid:_faceSession.ext[conversationTo]
                                         completion:^(NSString *imageStr)
         {
             
             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                
                 NSURL *imageURL = [NSURL URLWithString:imageStr];
                 NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                 UIImage *image = [UIImage imageWithData:imageData];
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     EMMessageBody *msgBody = msg.body;
                     
                     if (msgBody.type != EMMessageBodyTypeText)
                     {
                         [_chatManager asyncDownloadMessageAttachments:msg
                                                              progress:nil
                                                            completion:^(EMMessage *message, EMError *error)
                          {
                              if (!error)
                              {
                                  EMFileMessageBody *body = (EMFileMessageBody *)message.body;
                                  
                                  if ([NSData dataWithContentsOfFile:body.localPath])
                                  {
                                      RWWeChatMessage *newMsg;
                                      
                                      switch (msgBody.type)
                                      {
                                          case EMMessageBodyTypeImage:
                                          {
                                              newMsg =
                                              [RWWeChatMessage message:message
                                                                header:image
                                                                  type:RWMessageTypeImage
                                                             myMessage:NO
                                                           messageDate:[NSDate date]
                                                              showTime:NO
                                                      originalResource:nil];
                                              
                                              break;
                                          }
                                          case EMMessageBodyTypeLocation:break;
                                          case EMMessageBodyTypeVoice:
                                          {
                                              newMsg =
                                              [RWWeChatMessage message:message
                                                                header:image
                                                                  type:RWMessageTypeVoice
                                                             myMessage:NO
                                                           messageDate:[NSDate date]
                                                              showTime:NO
                                                      originalResource:nil];
                                              
                                              break;
                                          }
                                          case EMMessageBodyTypeVideo:
                                          {
                                              newMsg =
                                              [RWWeChatMessage message:message
                                                                header:image
                                                                  type:RWMessageTypeVideo
                                                             myMessage:NO
                                                           messageDate:[NSDate date]
                                                              showTime:NO
                                                      originalResource:nil];
                                              
                                              break;
                                          }
                                          case EMMessageBodyTypeFile:break;
                                              
                                          default:
                                              break;
                                      }
                                      
                                      if (msg)
                                      {
                                          if ([msg.conversationId isEqualToString:_faceSession.conversationId])
                                          {
                                              [_delegate receiveMessage:newMsg];
                                          }
                                          
                                          [_baseManager cacheMessage:newMsg];
                                      }
                                  }
                              }
                          }];
                     }
                     else
                     {
                         RWWeChatMessage *newMsg = [RWWeChatMessage message:msg
                                                                     header:image
                                                                       type:RWMessageTypeText
                                                                  myMessage:NO
                                                                messageDate:[NSDate date]
                                                                   showTime:NO
                                                           originalResource:nil];
                         
                         if ([msg.conversationId isEqualToString:_faceSession.conversationId])
                         {
                             [_delegate receiveMessage:newMsg];
                         }
                         
                         [_baseManager cacheMessage:newMsg];
                     }
                 });
             });
        }];
    }
}

- (void)didConnectionStateChanged:(EMConnectionState)aConnectionState
{
    _connectionState = aConnectionState;
    send_notification(RWConnectionStateNotification,@(_connectionState));
    
    _statusForLink = _connectionState?_statusForLink:RWLinkStateOfLoginFinish;
    
    if (!_connectionState) send_notification(RWDroppedNotification,nil);
}

- (void)didLoginFromOtherDevice
{
    _statusForLink = RWLinkStateOfLoginFromOtherDevice;
    _connectionState = EMConnectionDisconnected;
    send_notification(RWLoginFromOtherDeviceNotification,nil);
    send_notification(RWDroppedNotification,nil);
    
    [RWRequsetManager userLogout:nil];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"您的账号已在其他设备上登录登录，如果非本人操作请及时修改密码。" preferredStyle:UIAlertControllerStyleAlert];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UITabBarController *tabBar = (UITabBarController *)window.rootViewController;
    
    UIAlertAction *resetPasswordAction = [UIAlertAction actionWithTitle:@"重置密码" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        RegisterViewController * registerVC=[[RegisterViewController alloc]init];
        registerVC.typePassWord=TypeForgetPassWord;
        [tabBar presentViewController:registerVC animated:YES completion:nil];
    }];
    
    UIAlertAction *reLoginAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
    {
        [tabBar toLoginViewController];
    }];
    
    [alert addAction:resetPasswordAction];
    [alert addAction:reLoginAction];
    
    [tabBar presentViewController:alert animated:YES completion:nil];
}

- (void)didRemovedFromServer
{
    [RWRequsetManager userLogout:nil];
    
    _statusForLink = RWLinkStateOfRemovedFromServer;
    _connectionState = EMConnectionDisconnected;
    send_notification(RWRemovedFromServerNotification,nil);
    send_notification(RWDroppedNotification,nil);
}

#pragma other funtion

+ (NSString *)videoName
{
    RWChatManager *defaultManager = [RWChatManager defaultManager];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy$MM$dd#HH$mm$ss$SSS$$"];
    NSString *timeString= [formatter stringFromDate:[NSDate date]];
    
    return [NSString stringWithFormat:@"video@%@&%@.mp4",defaultManager.faceSession.conversationId,timeString];
}

+ (NSString *)voiceName
{
    RWChatManager *defaultManager = [RWChatManager defaultManager];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSString *timeString= [formatter stringFromDate:[NSDate date]];
    
    return [NSString stringWithFormat:@"voice%@%@.caf",defaultManager.faceSession.conversationId,timeString];
}

+ (NSString *)imageNameSuffix:(NSString *)suffix
{
    RWChatManager *defaultManager = [RWChatManager defaultManager];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy$MM$dd#HH$mm$ss$SSS$$"];
    NSString *timeString= [formatter stringFromDate:[NSDate date]];
    
    return [NSString stringWithFormat:@"image@%@&%@.%@",defaultManager.faceSession.conversationId,timeString,suffix];
}

+ (void)sendNotificationWithName:(const NSString *)name message:(id)message
{
    NSString *messageName = [NSString stringWithFormat:@"%@",name];
    NSDictionary *userInfo = message?@{name:message}:nil;
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:messageName
                                                        object:nil
                                                      userInfo:userInfo];
}

+ (void)observeNotification:(const NSString *)name usingblock:(void(^)(NSNotification * _Nonnull note))block
{
    NSString *messageName = [NSString stringWithFormat:@"%@",name];
    [[NSNotificationCenter defaultCenter] addObserverForName:messageName
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note)
    {
        if (block)
        {
            block(note);
        }
    }];
}

@end

@implementation RWChatMessageMaker

+ (EMMessage *)messageWithType:(EMMessageBodyType)type body:(NSDictionary *)body extension:(NSDictionary *)extension
{
    NSString *from = [[EMClient sharedClient] currentUsername];
    RWChatManager *defaultManager = [RWChatManager defaultManager];
    NSString *conversationID = defaultManager.faceSession.conversationId;
    
    NSString *to = defaultManager.faceSession.ext[conversationTo];

    EMMessage *message = [[EMMessage alloc] initWithConversationID:conversationID
                                                              from:from
                                                                to:to
                                                              body:nil
                                                               ext:extension];
    message.chatType = EMChatTypeChat;
    
    switch (type)
    {
        case EMMessageBodyTypeText:
        {
            message.body = [[EMTextMessageBody alloc]
                                                initWithText:body[messageTextBody]];
            
            break;
        }
        case EMMessageBodyTypeImage:
        {
            message.body = [[EMImageMessageBody alloc] initWithData:body[messageImageBody] displayName:body[messageImageName]];
            
            break;
        }
        case EMMessageBodyTypeVoice:
        {
            EMVoiceMessageBody *voiceBody = [[EMVoiceMessageBody alloc] initWithData:body[messageVoiceBody] displayName:body[messageVoiceName]];
            
            voiceBody.duration = [body[messageVoiceDuration] intValue];
            
            message.body = voiceBody ;
            
            break;
        }
        case EMMessageBodyTypeLocation:
        {
            message.body = [[EMLocationMessageBody alloc]
                            initWithLatitude:[body[messageLocationLatitude] doubleValue]
                                   longitude:[body[messageLocationLongitude] doubleValue]
                                     address:body[messageLocationAddress]];
            
            break;
        }
        case EMMessageBodyTypeVideo:
        {
            message.body = [[EMVideoMessageBody alloc] initWithLocalPath:body[messageVideoBody] displayName:body[messageVideoName]];
            
            break;
        }
            
        default:return nil;
            
    }
    
    return message;
}


@end
