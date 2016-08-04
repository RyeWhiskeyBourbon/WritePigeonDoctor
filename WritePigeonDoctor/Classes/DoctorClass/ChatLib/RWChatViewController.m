//
//  RWChatViewController.m
//  RWWeChatController
//
//  Created by zhongyu on 16/7/22.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWChatViewController.h"

@implementation RWChatViewController

#pragma mark - chatView - delegate

- (void)wechatCell:(RWWeChatCell *)wechat event:(RWMessageEvent)event
{
    switch (event)
    {
        case RWMessageEventTapImage:
        {
            [_bar.makeTextMessage.textView resignFirstResponder];
            
            if (_bar.faceResponceAccessory == RWChatBarButtonOfExpressionKeyboard)
            {
                self.view.center = _viewCenter;
                
                [UIView animateWithDuration:1.f animations:^{
                    
                    _bar.inputView.frame = __KEYBOARD_FRAME__;
                    
                    [_bar.inputView removeFromSuperview];
                }];
            }
            else if (_bar.faceResponceAccessory == RWChatBarButtonOfOtherFunction)
            {
                self.view.center = _viewCenter;
                
                [UIView animateWithDuration:1.f animations:^{
                    
                    _bar.purposeMenu.frame = __KEYBOARD_FRAME__;
                    
                    [_bar.purposeMenu removeFromSuperview];
                }];
            }
            
            EMImageMessageBody *body = (EMImageMessageBody *)wechat.message.message.body;
            
            [RWPhotoAlbum photoAlbumWithImage:[UIImage imageWithContentsOfFile:body.localPath]];
            
            break;
        }
        case RWMessageEventTapVoice:
        {
            EMVoiceMessageBody *body = (EMVoiceMessageBody *)wechat.message.message.body;
            
            NSData *voiceData = wechat.message.originalResource?
                                wechat.message.originalResource:
                                [NSData dataWithContentsOfFile:body.localPath];
            
            if (_audioPlayer)
            {
                [_audioPlayer stop];
                
                if (_audioPlayer.data == voiceData)
                {
                    _audioPlayer = nil;
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [wechat.voiceButton.playAnimation stopAnimating];
                    });
                    
                    return;
                }
                
                if (_playing)
                {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        if (_playing.voiceButton.playAnimation.isAnimating)
                        {
                            [_playing.voiceButton.playAnimation stopAnimating];
                        }
                        
                        _playing = nil;
                        
                        CFRunLoopRef runLoopRef = CFRunLoopGetCurrent();
                        CFRunLoopStop(runLoopRef);
                    });
                    
                    CFRunLoopRun();
                }
                
                _audioPlayer = nil;
            }
            
            _audioPlayer = [[AVAudioPlayer alloc] initWithData:voiceData error:nil];
            _audioPlayer.delegate = self;
            
            _playing = wechat;
            [_audioPlayer play];
            
            break;
        }
            
        default:
            break;
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    _audioPlayer = nil;
}

- (void)touchSpaceAtwechatView:(RWWeChatView *)wechatView
{
    [_bar.makeTextMessage.textView resignFirstResponder];
    
    if (_bar.faceResponceAccessory == RWChatBarButtonOfExpressionKeyboard)
    {
        self.view.center = _viewCenter;
        
        [UIView animateWithDuration:1.f animations:^{
            
            _bar.inputView.frame = __KEYBOARD_FRAME__;
            
            [_bar.inputView removeFromSuperview];
        }];
    }
    else if (_bar.faceResponceAccessory == RWChatBarButtonOfOtherFunction)
    {
        self.view.center = _viewCenter;
        
        [UIView animateWithDuration:1.f animations:^{
            
            _bar.purposeMenu.frame = __KEYBOARD_FRAME__;
            
            [_bar.purposeMenu removeFromSuperview];
        }];
    }
}

#pragma mark - bar - delegate - FitSize

- (void)keyboardWillChangeSize:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    CGFloat distance = beginFrame.origin.y - endFrame.origin.y;
    CGPoint pt = self.view.center;
    pt.y -= distance;
    
    void(^animations)() = ^{ self.view.center = pt; };
    
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:(curve << 16|UIViewAnimationOptionBeginFromCurrentState)
                     animations:animations completion:nil];
}

- (void)openAccessoryInputViewAtChatBar:(RWWeChatBar *)chatBar
{
    if (chatBar.purposeMenu.superview)
    {
        self.view.center = _viewCenter;
        chatBar.purposeMenu.frame = __KEYBOARD_FRAME__;
        
        [chatBar.purposeMenu removeFromSuperview];
    }
    
    [self.view.window addSubview:chatBar.inputView];
    
    if (self.view.center.y != _viewCenter.y)
    {
        self.view.center = _viewCenter;
        chatBar.inputView.frame = __KEYBOARD_FRAME__;
        
        [chatBar.inputView removeFromSuperview];
        
        return;
    }
    
    CGPoint pt = self.view.center , inputViewPt = chatBar.inputView.center;
    
    pt.y -= chatBar.inputView.frame.size.height;
    inputViewPt.y -= chatBar.inputView.frame.size.height;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        chatBar.inputView.center = inputViewPt;
        self.view.center = pt;
    }];
}

- (void)openMultiPurposeMenuAtChatBar:(RWWeChatBar *)chatBar
{
    if (chatBar.inputView.superview)
    {
        self.view.center = _viewCenter;
        chatBar.inputView.frame = __KEYBOARD_FRAME__;
        
        [chatBar.inputView removeFromSuperview];
    }
    
    [self.view.window addSubview:chatBar.purposeMenu];
    
    if (self.view.center.y != _viewCenter.y)
    {
        self.view.center = _viewCenter;
        chatBar.purposeMenu.frame = __KEYBOARD_FRAME__;
        
        [chatBar.purposeMenu removeFromSuperview];
        
        return;
    }
    
    CGPoint pt = self.view.center , purposeMenuPt = chatBar.purposeMenu.center;
    
    pt.y -= chatBar.purposeMenu.frame.size.height;
    purposeMenuPt.y -= chatBar.purposeMenu.frame.size.height;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        chatBar.purposeMenu.center = purposeMenuPt;
        self.view.center = pt;
    }];
}

#pragma mark - bar - textView

- (void)beginEditingTextAtChatBar:(RWWeChatBar *)chatBar
{
    if (chatBar.faceResponceAccessory == RWChatBarButtonOfExpressionKeyboard)
    {
        self.view.center = _viewCenter;
        chatBar.inputView.frame = __KEYBOARD_FRAME__;
        
        [chatBar.inputView removeFromSuperview];
    }
    else if (chatBar.faceResponceAccessory == RWChatBarButtonOfOtherFunction)
    {
        self.view.center = _viewCenter;
        chatBar.purposeMenu.frame = __KEYBOARD_FRAME__;
        
        [chatBar.purposeMenu removeFromSuperview];
    }
}

#pragma mark - bar - PurposeMenu

- (void)chatBar:(RWWeChatBar *)chatBar selectedFunction:(RWPurposeMenu)function
{
    NSLog(@"%d",(int)function);
    
    switch (function)
    {
        case RWPurposeMenuOfPhoto:
        {
            RWMakeImageController *makeImage = [RWMakeImageController makeImageWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary didSelectedImage:^(NSData *imageData, NSString *imageName)
            {
                
                [self sendMessage:
                 
                 [RWChatMessageMaker messageWithType:EMMessageBodyTypeImage
                                                body:@{messageImageBody:imageData,
                                                       messageImageName:imageName}
                                           extension:nil]
                 
                             type:RWMessageTypeImage
                    LocalResource:imageData];
            }];
            
            if (makeImage)
            {
                [self presentViewController:makeImage animated:YES completion:nil];
            }
            else
            {
                // alert
            }
            
            break;
        }
        case RWPurposeMenuOfCamera:
        {
            RWMakeImageController *makeImage = [RWMakeImageController makeImageWithSourceType:UIImagePickerControllerSourceTypeCamera didSelectedImage:^(NSData *imageData, NSString *imageName)
            {
                
                
                [self sendMessage:
                 
                 [RWChatMessageMaker messageWithType:EMMessageBodyTypeImage
                                                body:@{messageImageBody:imageData,
                                                       messageImageName:imageName}
                                           extension:nil]
                 
                             type:RWMessageTypeImage
                    LocalResource:imageData];
                
                [makeImage dismissViewControllerAnimated:YES completion:nil];
            }];
            
            if (makeImage)
            {
                [self presentViewController:makeImage animated:YES completion:nil];
            }
            else
            {
                // alert
            }
            
            break;
        }
        case RWPurposeMenuOfMyCard:break;
        case RWPurposeMenuOfCollect:break;
        case RWPurposeMenuOfLocation:break;
        case RWPurposeMenuOfVideoCall:break;
        case RWPurposeMenuOfSmallVideo: [self makeSmallVideo]; break;
            
        default:
            break;
    }
    
    self.view.center = _viewCenter;
    chatBar.purposeMenu.frame = __KEYBOARD_FRAME__;
    
    [chatBar.purposeMenu removeFromSuperview];
}

#pragma mark - video

- (void)makeSmallVideo
{
    [self.view addSubview:_coverLayer];
    
    CGFloat selfWidth  = self.view.bounds.size.width;
    CGFloat selfHeight = self.view.bounds.size.height;
    XZMicroVideoView *microVideoView = [[XZMicroVideoView alloc] initWithFrame:CGRectMake(0, selfHeight/3, selfWidth, selfHeight * 2/3)];
    microVideoView.delegate = self;
    
    [self.view addSubview:microVideoView];
}

#pragma mark - video - MicroVideoDelegate

- (void)touchUpDone:(NSString *)savePath
{
    EMMessage *message = [RWChatMessageMaker messageWithType:EMMessageBodyTypeVideo
                                                        body:
                                        @{messageVideoBody:savePath,
                                          messageVideoName:[RWChatManager videoName]}
                                                   extension:nil];
    
    [self sendMessage:message type:RWMessageTypeVideo
        LocalResource:savePath];
}

- (void)videoViewWillRemoveFromSuperView
{
    [_coverLayer removeFromSuperview];
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    __NAVIGATION_DEUAULT_SETTINGS__;
    
    _viewCenter = self.view.center;
    
    if (self.navigationController && !self.navigationController.navigationBar.hidden)
    {
        _viewCenter.y += (self.navigationController.navigationBar.bounds.size.height/2);
        
        CGRect statusFrame = [UIApplication sharedApplication].statusBarFrame;
        
        _viewCenter.y += (statusFrame.size.height / 2);
    }
    
    if (self.tabBarController && !self.tabBarController.tabBar.hidden)
    {
        _viewCenter.y -= (self.tabBarController.tabBar.bounds.size.height / 2);
    }
    
    _coverLayer = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _coverLayer.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
    
    _bar = [RWWeChatBar wechatBarWithAutoLayout:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.height.equalTo(@(49));
    }];
    
    _bar.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    _bar.delegate = self;
    
    [self.view addSubview:_bar];
    
    _weChat = [RWWeChatView chatViewWithAutoLayout:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.equalTo(_bar.mas_top).offset(0);
        
    } messages:_messages];
    
    _weChat.eventSource = self;
    
    [self.view addSubview:_weChat];
}

- (void)setMessages:(NSMutableArray *)messages
{
    _messages = messages;
    
    if (_weChat)
    {
        _weChat.messages = _messages;
    }
}

#pragma mark - send message

- (void)sendMessage:(EMMessage *)message type:(RWMessageType)type LocalResource:(id)resource
{
    RWWeChatMessage *chatMessage = [RWWeChatMessage message:message
                                                     header:
                                                    [UIImage imageNamed:@"MY"]
                                                       type:type
                                                  myMessage:YES
                                                messageDate:[NSDate date]
                                                   showTime:NO
                                           originalResource:resource];
    
    [_weChat addMessage:chatMessage];
}

@end
