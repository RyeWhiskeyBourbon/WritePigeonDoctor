//
//  RWConsultViewController.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/8/1.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWConsultViewController.h"

@interface RWConsultViewController ()

<
    RWChatManagerDelegate
>

@property (nonatomic,strong)RWChatManager *chatManager;

@end

@implementation RWConsultViewController

- (void)sendMessage:(EMMessage *)message type:(RWMessageType)type
{
    [super sendMessage:message type:type];
    
    //发送文字消息
}

- (void)touchUpDone:(NSString *)savePath
{
    [super touchUpDone:savePath];
    
    //视频消息
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _chatManager = [RWChatManager defaultManager];
    _chatManager.delegate = self;
}

- (void)receiveMessage:(EMMessage *)message messageType:(EMMessageBodyType)messageType
{
    switch (messageType)
    {
        case EMMessageBodyTypeText:
        {
            [RWWeChatMessage message:message
                              header:[UIImage imageNamed:@"MY"]
                                type:RWMessageTypeText
                           myMessage:NO
                         messageDate:[NSDate date]
                            showTime:NO];
        }
            break;
        case EMMessageBodyTypeImage:
        {
            [RWWeChatMessage message:message
                              header:[UIImage imageNamed:@"MY"]
                                type:RWMessageTypeImage
                           myMessage:NO
                         messageDate:[NSDate date]
                            showTime:NO];
        }
            break;
        case EMMessageBodyTypeLocation:break;
        case EMMessageBodyTypeVoice:
        {
            [RWWeChatMessage message:message
                              header:[UIImage imageNamed:@"MY"]
                                type:RWMessageTypeVoice
                           myMessage:NO
                         messageDate:[NSDate date]
                            showTime:NO];
        }
            break;
        case EMMessageBodyTypeVideo:
        {
            [RWWeChatMessage message:message
                              header:[UIImage imageNamed:@"MY"]
                                type:RWMessageTypeVideo
                           myMessage:NO
                         messageDate:[NSDate date]
                            showTime:NO];
        }
            break;
        case EMMessageBodyTypeFile:break;
            
        default:
            break;
    }
}

@end