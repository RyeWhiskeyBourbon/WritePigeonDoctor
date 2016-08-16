//
//  RWConsultViewController.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/8/1.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWConsultViewController.h"
#import "RWRequsetManager+UserLogin.h"
#import "RWDataBaseManager+ChatCache.h"

@interface RWConsultViewController ()

<
    RWChatManagerDelegate
>

@property (nonatomic,strong)RWChatManager *chatManager;

@end

@implementation RWConsultViewController

- (void)sendMessage:(EMMessage *)message type:(RWMessageType)type LocalResource:(id)resource
{
    [_chatManager.chatManager asyncSendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
       
        if (error)
        {
            MESSAGE(@"%@",error.errorDescription);
        }
    }];
    
    [super sendMessage:message type:type LocalResource:resource];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _chatManager = [RWChatManager defaultManager];
    _chatManager.delegate = self;
    
    [_chatManager createConversationWithID:self.item.EMID
                                 extension:@{conversationTo:self.item.EMID,
                                             UMID:self.item.umid}];
    
    self.weChat.messages =
                    [[self.baseManager getMessageWith:self.item.EMID] mutableCopy];
    
    if (!self.weChat.messages.count)
    {
        self.weChat.messages = [self getAttendantMessages];
    }
    
    for (int i = 0; i < self.weChat.messages.count; i++)
    {
        RWWeChatMessage *msg = self.weChat.messages[self.weChat.messages.count-i-1];
        
        if (msg.message.isRead)
        {
            break;
        }
        
        msg.message.isRead = YES;
        
        [self.baseManager updateCacheMessage:msg];
    }
}

- (NSMutableArray *)getAttendantMessages
{
    EMMessage *message = [[EMMessage alloc] initWithConversationID:nil
                                                              from:nil
                                                                to:nil
                                                              body:nil
                                                               ext:nil];
    message.chatType = EMChatTypeChat;
    
    message.body = [[EMTextMessageBody alloc]
                    initWithText:@"欢迎使用白鸽医护，白鸽医生您的私人医护助理!"];
    
    RWWeChatMessage *newMsg = [RWWeChatMessage message:message
                                                header:
                               [UIImage imageNamed:@"45195.jpg"]
                                                  type:RWMessageTypeText
                                             myMessage:NO
                                           messageDate:[NSDate date]
                                              showTime:NO
                                      originalResource:nil];
    
    EMMessage *warningMessage = [[EMMessage alloc] initWithConversationID:nil
                                                                     from:nil
                                                                       to:nil
                                                                     body:nil
                                                                      ext:nil];
    warningMessage.chatType = EMChatTypeChat;
    
    warningMessage.body = [[EMTextMessageBody alloc]
                           initWithText:@"白鸽医护管理员提醒您：为了您的个人财产权益，如果涉及支付，请谨慎处理，如果发生非本平台收费项目的经济纠纷，本平台概不负责。"];
    
    RWWeChatMessage *warningMsg = [RWWeChatMessage message:warningMessage
                                                    header:
                                   [UIImage imageNamed:@"45195.jpg"]
                                                      type:RWMessageTypeText
                                                 myMessage:NO
                                               messageDate:[NSDate date]
                                                  showTime:NO
                                          originalResource:nil];
    
    EMMessage *reminderMessage = [[EMMessage alloc] initWithConversationID:nil
                                                                     from:nil
                                                                       to:nil
                                                                     body:nil
                                                                      ext:nil];
    reminderMessage.chatType = EMChatTypeChat;
    
    reminderMessage.body = [[EMTextMessageBody alloc]
                           initWithText:@"温馨提示：白鸽社区，名医权威分析，为您提供更多的健康资讯和养生方法。"];
    
    RWWeChatMessage *reminderMsg = [RWWeChatMessage message:reminderMessage
                                                    header:
                                   [UIImage imageNamed:@"45195.jpg"]
                                                      type:RWMessageTypeText
                                                 myMessage:NO
                                               messageDate:[NSDate date]
                                                  showTime:NO
                                          originalResource:nil];
    
    return [@[newMsg,warningMsg,reminderMsg] mutableCopy];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!_chatManager.faceSession)
    {
        [_chatManager createConversationWithID:self.item.EMID
                                     extension:@{conversationTo:self.item.EMID}];
    }
}

- (void)receiveMessage:(RWWeChatMessage *)message
{
    message.message.isRead = YES;
    
    
    [self.weChat addMessage:message];
}

- (void)dealloc
{
    if (_chatManager.faceSession)
    {
        [_chatManager removeFaceConversation];
    }
}

@end
