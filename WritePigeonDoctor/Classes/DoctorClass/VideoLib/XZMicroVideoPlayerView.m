//
//  XZMicroVideoPlayerView.m
//  Protice
//
//  Created by ZYJY on 16/7/14.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "XZMicroVideoPlayerView.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "XZMicroVideoView.h"
#import "UIImage+XZMicroVideoPlayer.h"
#import "EMVideoMessageBody.h"
#import "RWWeiChatView.h"

@interface XZMicroVideoPlayerView()


@end

@implementation XZMicroVideoPlayerView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _selfFrame = frame;
        self.backgroundColor = [UIColor blackColor];
        [self addSubviews];
        [self configSubviews];
        [self relayoutSubViews];
        [self addObserver];
    }
    return self;
}
- (void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEndPlay:)name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onScaling:)];
    [self addGestureRecognizer:tap];
}

- (void)addSubviews
{
    _playerLayer = [AVPlayerLayer layer];
    [self.layer addSublayer:_playerLayer];
    
    _playerBtn = [[UIButton alloc] init];
    [self addSubview:_playerBtn];
}

- (void)configSubviews
{
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _playerLayer.masksToBounds = YES;
    
    [_playerBtn setBackgroundColor:[UIColor clearColor]];
    [_playerBtn setBackgroundImage:[UIImage imageNamed:@"record_playbutton"] forState:UIControlStateNormal];
    [_playerBtn setBackgroundImage:[UIImage imageNamed:@"record_errorbutton"] forState:UIControlStateDisabled];
    [_playerBtn addTarget:self action:@selector(onPlay:) forControlEvents:UIControlEventTouchUpInside];
}

//设置小视频消息封面图片
- (void)setCoverImage
{
    UIImage * image = [UIImage xz_previewImageWithVideoURL:_videoURL];
    _playerLayer.contents = (__bridge id _Nullable)(image.CGImage);

}
- (void)initPlayer
{
    _playItem = [AVPlayerItem playerItemWithURL:_videoURL];
    _player   = [AVPlayer playerWithPlayerItem:_playItem];
    [_playerLayer setPlayer:_player];
}

- (void)onPlay:(UIButton *)button
{
    [self initPlayer];
    [_player play];
    button.hidden = YES;
}

-(void)onEndPlay:(NSNotification *)notification
{
    AVPlayerItem *item = (AVPlayerItem *)notification.object;
    if (_playItem == item)
    {
        _playerBtn.hidden = NO;
        [_player seekToTime:CMTimeMake(0, 1)];
    }
}

- (void)onScaling:(UITapGestureRecognizer *)tap
{
    if (tap.state != UIGestureRecognizerStateEnded)
    {
        return;
    }
    if (!_isPlaying) {
    CGRect screen = [UIScreen mainScreen].bounds;
    self.frame = screen;
    CGFloat selfWidth = self.bounds.size.width;
    CGFloat selfHeight = self.bounds.size.height;
    _playerLayer.frame = CGRectMake(0, screen.size.height/3, self.bounds.size.width, self.bounds.size.height/3);
    _playerBtn.frame = CGRectMake(selfWidth/2 - 30, selfHeight/2 - 30, 60, 60);
    _timeView = self.superview;
    UIView *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    _isPlaying = !_isPlaying;
    }else
    {
    [self removeFromSuperview];
    self.frame = _selfFrame;
    CGFloat selfWidth = self.bounds.size.width;
    CGFloat selfHeight = self.bounds.size.height;
    _playerLayer.frame = self.bounds;
    _playerBtn.frame = CGRectMake(selfWidth/2 - 30, selfHeight/2 - 30, 60, 60);
    [_timeView addSubview:self];
    _isPlaying = !_isPlaying;
    }
}
- (void)relayoutSubViews
{
    CGFloat selfWidth = self.bounds.size.width;
    CGFloat selfHeight = self.bounds.size.height;
    _playerLayer.frame = self.bounds;
    _playerBtn.frame = CGRectMake(selfWidth/2 - 30, selfHeight/2 - 30, 60, 60);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _videoURL = nil;
    _coverImage = nil;
    _playerBtn = nil;
    _playItem = nil;
    _player = nil;
    _playerLayer = nil;
}

@end
