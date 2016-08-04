//
//  RWChatManager.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/7/26.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWChatManager.h"

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

@implementation RWChatManager

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

- (void)setDefaultSettings
{
    _client = [EMClient sharedClient];
    _chatManager = _client.chatManager;
    
    [_chatManager addDelegate:self delegateQueue:nil];
    
    _allSessions = [[_chatManager loadAllConversationsFromDB] mutableCopy];
}

- (void)createConversationWithID:(NSString *)ID
{
    _faceSession =[_chatManager getConversation:ID
                                           type:EMConversationTypeChat
                               createIfNotExist:YES];
    
    _allSessions = [[_chatManager loadAllConversationsFromDB] mutableCopy];
}

- (void)didReceiveMessages:(NSArray *)aMessages
{
    for (EMMessage *msg in aMessages)
    {
        __block EMMessageBody *msgBody = msg.body;
        
        if (msgBody.type != EMMessageBodyTypeText &&
            msgBody.type != EMMessageBodyTypeVoice)
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
                        [_delegate receiveMessage:message messageType:msgBody.type];
                     }
                 }
             }];
        }
        else
        {
            [_delegate receiveMessage:msg messageType:msgBody.type];
        }
    }
}

- (void)didReceiveHasReadAcks:(NSArray *)aMessages
{
    //已读
}

- (void)didReceiveHasDeliveredAcks:(NSArray *)aMessages
{
    //已送达
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
    [formatter setDateFormat:@"yyyy$MM$dd#HH$mm$ss$SSS$$"];
    NSString *timeString= [formatter stringFromDate:[NSDate date]];
    
    return [NSString stringWithFormat:@"voice@%@&%@.caf",defaultManager.faceSession.conversationId,timeString];
}

+ (NSString *)imageNameSuffix:(NSString *)suffix
{
    RWChatManager *defaultManager = [RWChatManager defaultManager];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy$MM$dd#HH$mm$ss$SSS$$"];
    NSString *timeString= [formatter stringFromDate:[NSDate date]];
    
    return [NSString stringWithFormat:@"image@%@&%@.%@",defaultManager.faceSession.conversationId,timeString,suffix];
}

@end

@implementation RWChatMessageMaker

+ (EMMessage *)messageWithType:(EMMessageBodyType)type body:(NSDictionary *)body extension:(NSDictionary *)extension
{
    
    
    NSString *from = [[EMClient sharedClient] currentUsername];

    EMMessage *message = [[EMMessage alloc] initWithConversationID:@"iOSTest001"
                                                              from:from
                                                                to:@"iOSTest001"
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
            EMVoiceMessageBody *voiceBody = [[EMVoiceMessageBody alloc] initWithLocalPath:body[messageVoiceBody] displayName:body[messageVoiceName]];
            
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
