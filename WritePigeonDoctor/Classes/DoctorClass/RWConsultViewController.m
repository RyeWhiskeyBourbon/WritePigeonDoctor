//
//  RWConsultViewController.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/8/1.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWConsultViewController.h"
#import "RWRequsetManager+UserLogin.h"

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
            NSLog(@"%@",error.errorDescription);
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
    
    RWRequsetManager *ma = [[RWRequsetManager alloc] init];
    
    [ma userinfoWithUsername:@"iOSTest002" AndPassword:@"iOSTest002"];
    
    [_chatManager createConversationWithID:@"iOSTest002"];

    [_chatManager createConversationWithID:@"iOSTest001"];
    
    [_chatManager.client.callManager makeVideoCall:self.item.EMID error:nil];
}

- (void)receiveMessage:(EMMessage *)message messageType:(EMMessageBodyType)messageType
{
    switch (messageType)
    {
        case EMMessageBodyTypeText:
        {
            [self.weChat addMessage:
             
             [RWWeChatMessage message:message
                               header:[UIImage imageNamed:@"MY"]
                                 type:RWMessageTypeText
                            myMessage:NO
                          messageDate:[NSDate date]
                             showTime:NO
                     originalResource:nil]
             ];
        }
            break;
        case EMMessageBodyTypeImage:
        {
            [self.weChat addMessage:
             
             [RWWeChatMessage message:message
                               header:[UIImage imageNamed:@"MY"]
                                 type:RWMessageTypeImage
                            myMessage:NO
                          messageDate:[NSDate date]
                             showTime:NO
                     originalResource:nil]
             ];
        }
            break;
        case EMMessageBodyTypeLocation:break;
        case EMMessageBodyTypeVoice:
        {
            [self.weChat addMessage:
             
             [RWWeChatMessage message:message
                               header:[UIImage imageNamed:@"MY"]
                                 type:RWMessageTypeVoice
                            myMessage:NO
                          messageDate:[NSDate date]
                             showTime:NO
                     originalResource:nil]
             ];
        }
            break;
        case EMMessageBodyTypeVideo:
        {
            [self.weChat addMessage:
             
             [RWWeChatMessage message:message
                               header:[UIImage imageNamed:@"MY"]
                                 type:RWMessageTypeVideo
                            myMessage:NO
                          messageDate:[NSDate date]
                             showTime:NO
                     originalResource:nil]
             ];
        }
            break;
        case EMMessageBodyTypeFile:break;
            
        default:
            break;
    }
}

@end
