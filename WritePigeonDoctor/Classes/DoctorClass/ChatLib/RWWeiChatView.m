

//
//  RWWeiChatView.m
//  RWWeChatController
//
//  Created by zhongyu on 16/7/13.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWWeiChatView.h"
#import "AppDelegate.h"

@interface RWWeChatView ()

<
    UITableViewDelegate,
    UITableViewDataSource,
    UIGestureRecognizerDelegate,
    RWWeChatViewEvent
>

@property (nonatomic,copy)void (^autoLayout)(MASConstraintMaker *);

@end

static NSString *const chatCell = @"chatCell";

@implementation RWWeChatView

+ (instancetype)chatViewWithAutoLayout:(void (^)(MASConstraintMaker *))autoLayout messages:(NSMutableArray *)messages
{
    RWWeChatView *chatView = [[RWWeChatView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    
    chatView.autoLayout = autoLayout;
    chatView.messages = messages;
    
    return chatView;
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    
    [self mas_remakeConstraints:_autoLayout];
    
    if (_messages)
    {
        [self reloadData];
        [self scrollToRowAtIndexPath:
                        [NSIndexPath indexPathForRow:_messages.count-1 inSection:0]
                    atScrollPosition:UITableViewScrollPositionBottom
                            animated:NO];
    }
}

- (void)setMessages:(NSMutableArray *)messages
{
    _messages = messages;
    
    if (_messages)
    {
        [self reloadData];
    }
}

- (void)setAutoLayout:(void (^)(MASConstraintMaker *))autoLayout
{
    _autoLayout = autoLayout;
    
    if (self.superview)
    {
        [self mas_remakeConstraints:_autoLayout];
    }
}

- (void)addMessage:(RWWeChatMessage *)message
{
    if (!_messages)
    {
        _messages = [[NSMutableArray alloc] init];
    }
    
    [_messages addObject:message];
    
    [self reloadData];
    [self scrollToRowAtIndexPath:
                [NSIndexPath indexPathForRow:_messages.count-1 inSection:0]
                            atScrollPosition:UITableViewScrollPositionBottom
                                    animated:NO];
}

- (void)removeMessage:(RWWeChatMessage *)message
{
    
}

#pragma scroll view delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTextMenu];
}

#pragma mark - gestureRecognizer

- (void)touchSpace
{
    [self removeTextMenu];
    
    [_eventSource touchSpaceAtwechatView:self];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isMemberOfClass:[UIView class]])
    {
        return NO;
    }
    
    return YES;
}

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    
    if (self)
    {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor clearColor];
        
        self.allowsSelection = NO;
        self.scrollsToTop = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.allowsSelection = NO;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self registerClass:[RWWeChatCell class] forCellReuseIdentifier:chatCell];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchSpace)];
        
        tap.delegate = self;
        
        [self addGestureRecognizer:tap];
    }
    
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RWWeChatCell *cell = [tableView dequeueReusableCellWithIdentifier:chatCell
                                                         forIndexPath:indexPath];
    
    cell.message = _messages[indexPath.row];
    cell.eventSource = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RWWeChatMessage *message = _messages[indexPath.row];
    
    return message.itemHeight;
}

#pragma mark - text menu

CGRect getTopRestrain(RWWeChatCell * cell)
{
    CGFloat width = cell.message.messageType == RWMessageTypeText?240:180;
    CGFloat height = 40;
    CGFloat x = !cell.message.isMyMessage?
                __MARGINS__ * 2 + __HEADER_SIZE__:
                __MAIN_SCREEN_WIDTH__ - (__MARGINS__ * 2 + __HEADER_SIZE__) - width;
    
    CGFloat top = cell.frame.origin.y;
    
    if (cell.message.showTime)
    {
        CGSize itemSize =
                    getFitSize(cell.message.dateString, __RWGET_SYSFONT(10.f), 0, 1);
        top += (itemSize.height + __MARGINS__ + __TIME_MARGINS__ * 2);
    }
    
    CGFloat y = top - height;
    
    return CGRectMake(x, y, width, height);
}

- (void)addTextMenuWithWechatCell:(RWWeChatCell *)wechat
{
    [self removeTextMenu];
    
    RWChatMenuView * menu = [RWChatMenuView menuWithFrame:getTopRestrain(wechat)
                                                    order:^(RWTextMenuType type)
    {
        [self removeTextMenu];
        
        switch (type)
        {
            case RWTextMenuTypeOfCopy:
            {
                UIPasteboard *paste = [UIPasteboard generalPasteboard];
                
                EMTextMessageBody *body = (EMTextMessageBody *)wechat.message.message.body;
                
                paste.string = body.text;
                
                break;

            }
            case RWTextMenuTypeOfRelay:
                //转发
                break;
            case RWTextMenuTypeOfCollect:
                //收藏
                break;
            case RWTextMenuTypeOfDelete:
            {
                [_messages removeObject:wechat.message];
                [self reloadData];
                break;
            }
            default:break;
        }
        
    } message:wechat.message arrowheadDistance:getArrowheadX(wechat)];
    
    menu.tag = 19085;
    [self addSubview:menu];
}

- (void)removeTextMenu
{
    if ([self viewWithTag:19085])
    {
        [[self viewWithTag:19085] removeFromSuperview];
    }
}

#pragma mark - event Source

- (void)wechatCell:(RWWeChatCell *)wechat event:(RWMessageEvent)event
{
    [self removeTextMenu];
    
    switch (event)
    {
        case RWMessageEventPressText:
            
            [self addTextMenuWithWechatCell:wechat];
            break;
        case RWMessageEventPressImage:
            
            [self addTextMenuWithWechatCell:wechat];
            break;
        case RWMessageEventPressVoice:
            
            [self addTextMenuWithWechatCell:wechat];
            break;
        case RWMessageEventPressVideo:
            
            [self addTextMenuWithWechatCell:wechat];
            break;
        case RWMessageEventTapImage:
            [_eventSource wechatCell:wechat event:event]; break;
        case RWMessageEventTapVoice:
            [_eventSource wechatCell:wechat event:event]; break;
        case RWMessageEventTapVideo:
            [_eventSource wechatCell:wechat event:event]; break;
            
        default: break;
    }
}

@end

@interface RWWeChatCell ()

@property (nonatomic,strong)RWMarginsLabel *timeLabel;

@property (nonatomic,strong)UIImageView *headerImage;
@property (nonatomic,strong)UIImageView *arrowheadImage;

@property (nonatomic,copy)void(^autoLayout)(MASConstraintMaker *);

@end

@implementation RWWeChatCell

- (void)setMessage:(RWWeChatMessage *)message
{
    _message = message;
    
    [self setTimeLabelAutoLayoutAndSettings];
    
    if (_message.isMyMessage) [self myMessageBaseLayout];
    else [self someoneMessageBaseLayout];
    
    switch (_message.messageType)
    {
        case RWMessageTypeText:  [self setTextMessageSettings];  break;
        case RWMessageTypeVoice: [self setVoiceMessageSettings]; break;
        case RWMessageTypeImage: [self setImageMessageSettings]; break;
        case RWMessageTypeVideo: [self setVideoMessageSettings]; break;
        default: break;
    }
}

- (void)initViews
{
    _timeLabel = [[RWMarginsLabel alloc] init];
    [self addSubview:_timeLabel];
    
    _headerImage = [[UIImageView alloc] init];
    [self addSubview:_headerImage];
    
    _contentLabel = [[RWMarginsLabel alloc] init];
    [self addSubview:_contentLabel];
    
    _voiceButton = [[RWVoicePlayButton alloc] init];
    [self addSubview:_voiceButton];
    
    _contentImage = [[UIImageView alloc] init];
    [self addSubview:_contentImage];
    
    _arrowheadImage = [[UIImageView alloc] init];
    [self addSubview:_arrowheadImage];
}

- (void)setDefaultSettings
{
    _contentLabel.userInteractionEnabled = YES;
    _contentImage.userInteractionEnabled = YES;
    
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
    
    _timeLabel.margins = __TIME_MARGINS__;
    _timeLabel.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
    _timeLabel.textLabel.font = __RWGET_SYSFONT(10.f);
    _timeLabel.textLabel.numberOfLines = 1;
    _timeLabel.textLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.textLabel.textColor = [UIColor whiteColor];
    
    _timeLabel.layer.cornerRadius = 3;
    _timeLabel.clipsToBounds = YES;
    
    _voiceButton.layer.cornerRadius = 5;
    _voiceButton.clipsToBounds = YES;
    
    _contentLabel.margins = __TEXT_MARGINS__;
    _contentLabel.textLabel.font = __RWCHAT_FONT__;
    _contentLabel.textLabel.numberOfLines = 0;
    _contentLabel.textLabel.textColor = [UIColor blackColor];
    
    _contentLabel.layer.cornerRadius = 6;
    _contentLabel.clipsToBounds = YES;
    
    [self addGestureRecognizers];
}

- (void)addGestureRecognizers
{
    UILongPressGestureRecognizer *pressText = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressMessage)];
    pressText.minimumPressDuration = 1.5;
    
    [_contentLabel addGestureRecognizer:pressText];
    
    UILongPressGestureRecognizer *pressVoice = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressMessage)];
    pressVoice.minimumPressDuration = 1.5;
    
    [_voiceButton addGestureRecognizer:pressVoice];
    
    [_voiceButton addTarget:self action:@selector(voicePlay) forControlEvents:UIControlEventTouchUpInside];
    
    UILongPressGestureRecognizer *pressImage = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressMessage)];
    pressImage.minimumPressDuration = 1.5;
    
    UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageShow)];
    tapImage.numberOfTapsRequired = 1;
    
    [_contentImage addGestureRecognizer:tapImage];
    [_contentImage addGestureRecognizer:pressImage];
    
}

#pragma mark - click

- (void)pressMessage
{
    switch (_message.messageType)
    {
        case RWMessageTypeText:
            
            [_eventSource wechatCell:self
                               event:RWMessageEventPressText];
            break;
            
        case RWMessageTypeImage:
            
            [_eventSource wechatCell:self
                               event:RWMessageEventPressImage];
            break;
            
        case RWMessageTypeVideo:
            
            [_eventSource wechatCell:self
                               event:RWMessageEventPressVideo];
            break;
            
        case RWMessageTypeVoice:
            
            [_eventSource wechatCell:self
                               event:RWMessageEventPressVoice];
            break;
            
        default: break;
    }
}

- (void)voicePlay
{
    [_eventSource wechatCell:self
                       event:RWMessageEventTapVoice];
    
    [_voiceButton.playAnimation startAnimating];
    
    EMVoiceMessageBody *body = (EMVoiceMessageBody *)_message.message.body;
    
    NSInteger second = body.duration;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (_voiceButton.playAnimation.isAnimating)
        {
            [_voiceButton.playAnimation stopAnimating];
        }
    });
}

- (void)imageShow
{
        [_eventSource wechatCell:self
                           event:RWMessageEventTapImage];
}

- (void)videoPlay
{
    [_eventSource wechatCell:self event:RWMessageEventTapVideo];
}

#pragma mark - settings With Type

- (void)setTextMessageSettings
{
    _arrowheadImage.hidden = NO;
    _voiceButton.hidden = YES;
    _contentImage.hidden = YES;
    _contentLabel.hidden = NO;
    [_videoPlayer removeFromSuperview];
    _videoPlayer = nil;
    
    _contentLabel.textLabel.textAlignment = NSTextAlignmentLeft;
    [self getAutoLayoutParameter];
    [_contentLabel setAutoLayout:_autoLayout];
    
    if (_message.isMyMessage)
    {
        _contentLabel.backgroundColor = __WPD_MAIN_COLOR__;
    }
    else
    {
        _contentLabel.backgroundColor = [UIColor lightGrayColor];
    }
    
    EMTextMessageBody *body = (EMTextMessageBody *)_message.message.body;
    _contentLabel.textLabel.text = body.text;
}

- (void)setVoiceMessageSettings
{
    _arrowheadImage.hidden = NO;
    _contentLabel.hidden = YES;
    _contentImage.hidden = YES;
    _voiceButton.hidden = NO;
    [_videoPlayer removeFromSuperview];
    _videoPlayer = nil;
    
    EMVoiceMessageBody *body = (EMVoiceMessageBody *)_message.message.body;
    
    NSString *second = [NSString stringWithFormat:@"%d",body.duration];
    _voiceButton.second.text = [NSString stringWithFormat:@"%@“",second];
    
    if (_message.isMyMessage)
    {
        _voiceButton.backgroundColor = __WPD_MAIN_COLOR__;
    }
    else
    {
        _voiceButton.backgroundColor = [UIColor lightGrayColor];
    }
    
    [self getAutoLayoutParameter];
    [_voiceButton setAutoLayout:_autoLayout isMyMessage:_message.isMyMessage];
}

- (void)setImageMessageSettings
{
    _arrowheadImage.hidden = NO;
    _contentLabel.hidden = YES;
    _voiceButton.hidden = YES;
    _contentImage.hidden = NO;
    [_videoPlayer removeFromSuperview];
    _videoPlayer = nil;
    
    [self getAutoLayoutParameter];
    [_contentImage mas_remakeConstraints:_autoLayout];
    
    if (_message.originalResource)
    {
        _contentImage.image = [UIImage imageWithData:_message.originalResource];
    }
    else
    {
        EMImageMessageBody *body = (EMImageMessageBody *)_message.message.body;
        
        _contentImage.image = [UIImage imageWithContentsOfFile:body.localPath];
    }
}

- (void)setVideoMessageSettings
{
    _arrowheadImage.hidden = YES;
    _contentLabel.hidden = YES;
    _voiceButton.hidden = YES;
    _contentImage.hidden = YES;
    
    [self addSubview:[self getVideoPlayer]];
    
    if (_message.originalResource)
    {
        _videoPlayer.videoURL = [NSURL fileURLWithPath:_message.originalResource];
    }
    else
    {
        EMVideoMessageBody *body = (EMVideoMessageBody *)_message.message.body;
        
        _videoPlayer.videoURL = [NSURL fileURLWithPath:body.localPath];
    }
}

- (XZMicroVideoPlayerView *)getVideoPlayer
{
    if (!_videoPlayer)
    {
        _videoPlayer = [[XZMicroVideoPlayerView alloc] initWithFrame:getFitVideoSize(__VIDEO_ORIGINAL_SIZE__, _message.isMyMessage)];
    }
    
    return _videoPlayer;
}

#pragma mark - autoLayout With Type

- (void)setTimeLabelAutoLayoutAndSettings
{
    if (_message.showTime)
    {
        CGSize textSize = getFitSize(_message.dateString, __RWGET_SYSFONT(10.f), 0, 1);
        
        RWWeChatCell *weakSelf = self;
        
        [_timeLabel setAutoLayout:^(MASConstraintMaker *make) {
            
            make.width.equalTo(@(textSize.width + __TIME_MARGINS__ * 2));
            make.height.equalTo(@(textSize.height + __TIME_MARGINS__ * 2));
            make.top.equalTo(weakSelf.mas_top).offset(__MARGINS__);
            make.centerX.equalTo(weakSelf.mas_centerX).offset(0);
        }];
        
        _timeLabel.textLabel.text = _message.dateString;
    }
    else
    {
        [_timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.mas_top).offset(0);
            make.centerX.equalTo(self.mas_centerX).offset(0);
            make.width.equalTo(@(0));
            make.height.equalTo(@(0));
        }];
    }
}

- (void)myMessageBaseLayout
{
    MASViewAttribute *masView = _timeLabel.mas_bottom;
    
    if (!_message.showTime)
    {
        masView = self.mas_top;
    }
    
    [_headerImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(__HEADER_SIZE__));
        make.height.equalTo(@(__HEADER_SIZE__));
        make.right.equalTo(self.mas_right).offset(-__MARGINS__);
        make.top.equalTo(masView).offset(__MARGINS__);
    }];
    
    [_arrowheadImage mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.width.equalTo(@(__ARROWHEAD_SIZE__));
        make.height.equalTo(@(__ARROWHEAD_SIZE__));
        make.centerY.equalTo(_headerImage.mas_centerY).offset(0);
        make.right.equalTo(_headerImage.mas_left).offset(-5);
    }];
    
    _headerImage.image = _message.header;
    _arrowheadImage.image = [[UIImage imageNamed:@"RightCa"] imageWithColor:__WPD_MAIN_COLOR__];
}

- (void)someoneMessageBaseLayout
{
    MASViewAttribute *masView = _timeLabel.mas_bottom;
    
    if (!_message.showTime)
    {
        masView = self.mas_top;
    }
    
    [_headerImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(__HEADER_SIZE__));
        make.height.equalTo(@(__HEADER_SIZE__));
        make.left.equalTo(self.mas_left).offset(__MARGINS__);
        make.top.equalTo(masView).offset(__MARGINS__);
    }];
    
    [_arrowheadImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(__ARROWHEAD_SIZE__));
        make.height.equalTo(@(__ARROWHEAD_SIZE__));
        make.centerY.equalTo(_headerImage.mas_centerY).offset(0);
        make.left.equalTo(_headerImage.mas_right).offset(5);
    }];
    
    _headerImage.image = _message.header;
    _arrowheadImage.image = [[UIImage imageNamed:@"LifeCa"] imageWithColor:[UIColor lightGrayColor]];
}

- (void)getAutoLayoutParameter
{    
    CGFloat left = __MARGINS__ + __HEADER_SIZE__ + __ARROWHEAD_SIZE__ + 3.f;
    CGFloat right = __MARGINS__ + __HEADER_SIZE__ + __ARROWHEAD_SIZE__ + 3.f;
    
    __block RWWeChatCell *weakSelf = self;
    
    MASViewAttribute *masView = _timeLabel.mas_bottom;
    
    if (!_message.showTime)
    {
        masView = weakSelf.mas_top;
    }
    
    switch (_message.messageType)
    {
        case RWMessageTypeText:
        {
            EMTextMessageBody *body = (EMTextMessageBody *)_message.message.body;
            
            NSString *context = body.text;
            CGSize size = getFitSize(context, __RWCHAT_FONT__, 0, 1);
            
            if ((size.width + __TEXT_MARGINS__ * 2) < __TEXT_LENGHT__)
            {
                if (_message.isMyMessage)
                {
                    left += (__TEXT_LENGHT__ - (size.width + __TEXT_MARGINS__ * 2));
                }
                else
                {
                    right += (__TEXT_LENGHT__ - (size.width + __TEXT_MARGINS__ * 2));
                }
                
                _contentLabel.textLabel.textAlignment = NSTextAlignmentCenter;
            }
            break;
        }
        case RWMessageTypeImage:
        {
            EMImageMessageBody *body = (EMImageMessageBody *)_message.message.body;
            
            UIImage *image = _message.originalResource?
                            [UIImage imageWithData:_message.originalResource]:
                            [UIImage imageWithContentsOfFile:body.localPath];
            
            CGSize size = getFitImageSize(image);
            
            if (_message.isMyMessage)
            {
                left += (__PICxVID_MAX_WIDTH__ - size.width);
            }
            else
            {
                right += (__PICxVID_MAX_WIDTH__ - size.width);
            }
            
            _arrowheadImage.image = nil;
            
            break;
        }
        case RWMessageTypeVoice:
        {
            EMVoiceMessageBody *body = (EMVoiceMessageBody *)_message.message.body;
            
            NSInteger second = body.duration;
            
            CGFloat scale = second / 60.f;
            
            if (_message.isMyMessage)
            {
                left += __VOICE_LENTH(scale);
                
                if (left > __VOICE_MAX_OFFSET__)
                {
                    left = __VOICE_MAX_OFFSET__;
                }
            }
            else
            {
                right += __VOICE_LENTH(scale);
                
                if (right > __VOICE_MAX_OFFSET__)
                {
                    right = __VOICE_MAX_OFFSET__;
                }
            }
            
            break;
        }
        default: break;
    }
    
    _autoLayout = ^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakSelf.mas_left).offset(left);
        make.right.equalTo(weakSelf.mas_right).offset(-right);
        make.top.equalTo(masView).offset(__MARGINS__);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-__MARGINS__);
    };
}

#pragma mark - init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self initViews];
        [self setDefaultSettings];
    }
    
    return self;
}

@end

CGSize getFitSize(NSString *text,UIFont *font,CGFloat width,CGFloat lines)
{
    UILabel *temp = [[UILabel alloc] init];
    
    temp.bounds = CGRectMake(0, 0, width, 0);
    temp.text = text;
    temp.numberOfLines = lines;
    
    [temp sizeToFit];
    
    return temp.bounds.size;
}

CGSize getFitImageSize(UIImage *image)
{
    CGSize imageSize = image.size;
    
    if (imageSize.width > __PICxVID_MAX_WIDTH__)
    {
        imageSize.height = __PICxVID_MAX_WIDTH__ / imageSize.width * imageSize.height;
        imageSize.width = __PICxVID_MAX_WIDTH__;
    }
    
    if (imageSize.height > __PICxVID_MAX_HEIGHT__)
    {
        imageSize.width = __PICxVID_MAX_HEIGHT__ / imageSize.height * imageSize.width;
        imageSize.height = __PICxVID_MAX_HEIGHT__;
    }
    
    return imageSize;
}

CGRect getFitVideoSize(CGSize originalSize,BOOL isMyMessage)
{
    CGFloat width = originalSize.width;
    CGFloat height = originalSize.height;
    
    if (width > __PICxVID_MAX_WIDTH__)
    {
        height = __PICxVID_MAX_WIDTH__ / width * height;
        width = __PICxVID_MAX_WIDTH__;
    }
    
    if (height > __PICxVID_MAX_HEIGHT__)
    {
        width = __PICxVID_MAX_HEIGHT__ / height * width;
        height = __PICxVID_MAX_HEIGHT__;
    }
    
    CGFloat x = isMyMessage?__MAIN_SCREEN_WIDTH__ - (__MAIN_SCREEN_WIDTH__ - __TEXT_LENGHT__) / 2 - width:(__MAIN_SCREEN_WIDTH__ - __TEXT_LENGHT__) / 2;
    
    return CGRectMake(x, __MARGINS__, width, height);
}

NSString *getDate(NSDate *messageDate)
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *year = [dateFormatter stringFromDate:[NSDate date]];
    
    [dateFormatter setDateFormat:@"MM"];
    NSString *month = [dateFormatter stringFromDate:[NSDate date]];
    
    [dateFormatter setDateFormat:@"dd"];
    NSString *day = [dateFormatter stringFromDate:[NSDate date]];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setYear:year.integerValue];
    [comps setMonth:month.integerValue];
    [comps setDay:day.integerValue];
    
    NSDate *today = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    if ([messageDate timeIntervalSinceDate:today] > 0)
    {
        [dateFormatter setDateFormat:@"HH:ss"];
        
        NSString *time = [dateFormatter stringFromDate:messageDate];
        
        return time;
    }
    else if ([messageDate timeIntervalSinceDate:today] > -24 * 60 * 60)
    {
        [dateFormatter setDateFormat:@"HH:ss"];
        
        NSString *time = [dateFormatter stringFromDate:messageDate];
        
        return [NSString stringWithFormat:@"昨天 %@",time];
    }
    
    [dateFormatter setDateFormat:@"EEEE HH:ss"];
    
    return [dateFormatter stringFromDate:messageDate];
}

@implementation RWWeChatMessage

+ (instancetype)message:(EMMessage *)message
                 header:(UIImage *)header
                   type:(RWMessageType)type
              myMessage:(BOOL)isMyMessage
            messageDate:(NSDate *)messageDate
               showTime:(BOOL)showTime
       originalResource:(id)originalResource
{
    RWWeChatMessage *item = [[RWWeChatMessage alloc] init];
    
    item.header = header;
    item.showTime = showTime;
    item.message = message;
    item.isMyMessage = isMyMessage;
    item.originalResource = originalResource;
    [item setMessageType:type];
    
    if (messageDate)
    {
        item.messageDate = messageDate;
    }
    
    return item;
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _itemHeight = __CELL_LENGTH__;
    }
    
    return self;
}

- (void)setMessageDate:(NSDate *)messageDate
{
    _messageDate = messageDate;
    _dateString = getDate(_messageDate);
}

- (void)setMessageType:(RWMessageType)messageType
{
    _messageType = messageType;
    
    if (_messageType == RWMessageTypeText)
    {
        EMTextMessageBody *body = (EMTextMessageBody *)_message.body;
        
        NSString *text = body.text;
        CGSize itemSize = getFitSize(text, __RWCHAT_FONT__, __TEXT_LENGHT__, 0);
        
        _itemHeight = _itemHeight + itemSize.height + __MARGINS__ * 2 + __TEXT_MARGINS__ * 2 - __CELL_LENGTH__;
        
        if (_itemHeight < __CELL_LENGTH__)
        {
            _itemHeight = __CELL_LENGTH__;
        }
    }
    else if (_messageType == RWMessageTypeImage)
    {
        EMImageMessageBody *body = (EMImageMessageBody *)_message.body;
        
        UIImage *image = _originalResource?
                        [UIImage imageWithData:_originalResource]:
                        [UIImage imageWithContentsOfFile:body.localPath];

        CGSize imageSize = getFitImageSize(image);
        
        _itemHeight = imageSize.height + __MARGINS__ * 2;
    }
    else if (_messageType == RWMessageTypeVideo)
    {
        CGRect videoBounds = getFitVideoSize(__VIDEO_ORIGINAL_SIZE__, NO);
        
        _itemHeight = videoBounds.size.height + __MARGINS__ * 2;
    }
    
    if (_showTime)
    {
        if (!_dateString)
        {
            _showTime = NO;
            return;
        }
        
        CGSize itemSize = getFitSize(_dateString, __RWGET_SYSFONT(10.f), 0, 1);
        _itemHeight += (itemSize.height + __MARGINS__ + __TIME_MARGINS__ * 2);
    }
}

@end

@implementation RWMarginsLabel

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _textLabel = [[UILabel alloc] init];
        [self addSubview:_textLabel];
        _textLabel.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)setAutoLayout:(void (^)(MASConstraintMaker *))autoLayout
{
    _autoLayout = autoLayout;
    
    [self mas_remakeConstraints:autoLayout];
    
    [_textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(_margins);
        make.left.equalTo(self.mas_left).offset(_margins);
        make.right.equalTo(self.mas_right).offset(-_margins);
        make.bottom.equalTo(self.mas_bottom).offset(-_margins);
    }];
}

- (void)setMargins:(CGFloat)margins
{
    _margins = margins;
    
    if (!_autoLayout)
    {
        return;
    }
    
    [_textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(_margins);
        make.left.equalTo(self.mas_left).offset(_margins);
        make.right.equalTo(self.mas_right).offset(-_margins);
        make.bottom.equalTo(self.mas_bottom).offset(-_margins);
    }];
}

@end

@implementation RWVoicePlayButton

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _playAnimation = [[UIImageView alloc] init];
        _playAnimation.backgroundColor = [UIColor clearColor];
        
        UIImage *voice3 = [[UIImage imageNamed:@"playVoice3"] imageWithColor:[UIColor colorWithWhite:0.4 alpha:1.0]];
        
        UIImage *voice2 = [[UIImage imageNamed:@"playVoice2"] imageWithColor:[UIColor colorWithWhite:0.4 alpha:1.0]];
        
        UIImage *voice1 = [[UIImage imageNamed:@"playVoice1"] imageWithColor:[UIColor colorWithWhite:0.4 alpha:1.0]];
        
        _playAnimation.animationImages = @[voice3,voice2,voice1,voice2];
        _playAnimation.animationDuration = 1.2;
        _playAnimation.image = voice3;
        
        [self addSubview:_playAnimation];
        
        _second = [[UILabel alloc] init];
        _second.backgroundColor = [UIColor clearColor];
        [self addSubview:_second];
        
        _second.font = [UIFont boldSystemFontOfSize:12];
        _second.textColor = [UIColor blackColor];
        _second.textAlignment = NSTextAlignmentCenter;
    }
    
    return self;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    if (_autoLayout)
    {
        [self setAutoLayout:_autoLayout isMyMessage:_isMyMessage];
    }
}

- (void)setAutoLayout:(void (^)(MASConstraintMaker *make))autoLayout isMyMessage:(BOOL)isMyMessage
{
    _autoLayout = autoLayout; _isMyMessage = isMyMessage;
    
    if (self.superview)
    {
        [self mas_remakeConstraints:_autoLayout];
        
        if (_isMyMessage)
        {
            [_playAnimation mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.width.equalTo(@(16));
                make.height.equalTo(@(20));
                make.centerY.equalTo(self.mas_centerY).offset(0);
                make.right.equalTo(self.mas_right).offset(-8);
            }];
            
            [_second mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.width.equalTo(@(25));
                make.height.equalTo(@(25));
                make.centerY.equalTo(self.mas_centerY).offset(0);
                make.left.equalTo(self.mas_left).offset(8);
            }];
        }
        else
        {
            [_playAnimation mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.width.equalTo(@(16));
                make.height.equalTo(@(20));
                make.centerY.equalTo(self.mas_centerY).offset(0);
                make.left.equalTo(self.mas_left).offset(8);
            }];
            
            [_second mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.width.equalTo(@(25));
                make.height.equalTo(@(25));
                make.centerY.equalTo(self.mas_centerY).offset(0);
                make.right.equalTo(self.mas_right).offset(-8);
            }];
        }
    }
}

@end

@interface RWChatMenuView ()

@property (nonatomic,strong)RWTextMenu *menu;
@property (nonatomic,strong)UIImageView *arrowhead;
@property (nonatomic,copy)void (^order)(RWTextMenuType type);
@property (nonatomic,assign)CGFloat arrowheadDistance;

@end

CGFloat getArrowheadX(RWWeChatCell *cell)
{
    CGFloat centerX = 0.f;
    
    switch (cell.message.messageType)
    {
        case RWMessageTypeText:  centerX = cell.contentLabel.center.x; break;
        case RWMessageTypeVoice: centerX = cell.voiceButton.center.x; break;
        case RWMessageTypeImage: centerX = cell.contentImage.center.x; break;
        case RWMessageTypeVideo:    break;
        default:break;
    }
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat arrowheadDisH = cell.message.isMyMessage?screenWidth - centerX - (__MARGINS__ * 2 + __HEADER_SIZE__):centerX - (__MARGINS__ * 2 + __HEADER_SIZE__);
    
    return arrowheadDisH;
}

@implementation RWChatMenuView

+ (instancetype)menuWithFrame:(CGRect)frame order:(void (^)(RWTextMenuType type))order message:(RWWeChatMessage *)message arrowheadDistance:(CGFloat)arrowheadDistance
{
    RWChatMenuView *view = [[RWChatMenuView alloc] initWithFrame:frame];
    view.arrowheadDistance = arrowheadDistance;
    view.message = message;
    view.order = order;
    
    CGPoint arrowheadPt = view.arrowhead.center;
    
    arrowheadPt.x = message.isMyMessage?
                    view.frame.size.width -  arrowheadDistance:
                    arrowheadDistance;

    view.arrowhead.center = arrowheadPt;
    
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        UIImage *arrowheadBottom = [[UIImage imageNamed:@"bottomCa"] imageWithColor:[UIColor blackColor]];
        
        _arrowhead = [[UIImageView alloc] initWithFrame:CGRectMake(0 , frame.size.height - 10, 10, 10)];
        
        [self addSubview:_arrowhead];
        
        _arrowhead.image = arrowheadBottom;
    }
    
    return self;
}

- (void)setMessage:(RWWeChatMessage *)message
{
    _message = message;
    
    _menu = [RWTextMenu textMenuWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 8) responseOrder:^(RWTextMenuType type) {
        
        _order(type);
        
    } isText:(_message.messageType == RWMessageTypeText)];
    
    [self addSubview:_menu];
}

@end

@interface RWTextMenu ()

<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic,strong)NSArray *resource;

@property (nonatomic,copy)void (^order)(RWTextMenuType type);

@end

@implementation RWTextMenu

+ (instancetype)textMenuWithFrame:(CGRect)frame responseOrder:(void (^)(RWTextMenuType type))order isText:(BOOL)isText
{
    RWTextMenu *menu = [[RWTextMenu alloc] initWithFrame:frame];
    menu.order = order;
    menu.isText = isText;
    
    return menu;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    
    if (self)
    {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor clearColor];
        
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        
        [self registerClass:[RWTextMenuCell class] forCellWithReuseIdentifier:NSStringFromClass([RWTextMenuCell class])];
        
    }
    
    return self;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    _resource = _isText?@[@"复制",@"转发",@"收藏",@"删除"]:@[@"转发",@"收藏",@"删除"];
    
    [self reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _resource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RWTextMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([RWTextMenuCell class]) forIndexPath:indexPath];
    
    cell.textLabel.text = _resource[indexPath.row];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width / _resource.count, collectionView.frame.size.height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RWTextMenuCell *cell = (RWTextMenuCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if ([cell.textLabel.text isEqualToString:@"复制"])
    {
        _order(RWTextMenuTypeOfCopy);
    }
    else if ([cell.textLabel.text isEqualToString:@"转发"])
    {
        _order(RWTextMenuTypeOfRelay);
    }
    else if ([cell.textLabel.text isEqualToString:@"收藏"])
    {
        _order(RWTextMenuTypeOfCollect);
    }
    else if ([cell.textLabel.text isEqualToString:@"删除"])
    {
        _order(RWTextMenuTypeOfDelete);
    }
}

@end

@implementation RWTextMenuCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont systemFontOfSize:13];
        _textLabel.backgroundColor = [UIColor blackColor];
        
        [self addSubview:_textLabel];
        
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(self.mas_left).offset(0.5);
            make.right.equalTo(self.mas_right).offset(-0.5);
            make.bottom.equalTo(self.mas_bottom).offset(0);
            make.top.equalTo(self.mas_top).offset(0);
        }];
    }
    
    return self;
}

@end

@implementation UIImage (changeColor)

- (UIImage *)imageWithColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end

@interface RWPhotoAlbum ()

<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    RWPhotoAlbumCellDelegate
>

@property (nonatomic,strong)NSArray *images;

@end

@implementation RWPhotoAlbum

+ (instancetype)photoAlbumWithImage:(UIImage *)image
{
    RWPhotoAlbum *photoAlbum = [[RWPhotoAlbum alloc] init];
    photoAlbum.faceImage = image;
    
    return photoAlbum;
}

- (instancetype)init
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self = [super initWithFrame:[UIScreen mainScreen].bounds
           collectionViewLayout:flowLayout];
    
    if (self)
    {
        AppDelegate *faceDelegate = [UIApplication sharedApplication].delegate;
        UIWindow *faceWindow = faceDelegate.window;
        
        [faceWindow addSubview:self];
        
        self.backgroundColor = [UIColor colorWithWhite:0.1f alpha:0.8f];
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        
        self.delegate = self;
        self.dataSource = self;
        
        [self registerClass:[RWPhotoAlbumCell class] forCellWithReuseIdentifier:NSStringFromClass([RWPhotoAlbumCell class])];
    }
    
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RWPhotoAlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([RWPhotoAlbumCell class]) forIndexPath:indexPath];
    
    cell.image = _images[indexPath.row];
    cell.delegate = self;
    
    return cell;
}

- (void)closeFaceView
{
    [self removeFromSuperview];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height);
}

- (void)setFaceImage:(UIImage *)faceImage
{
    _faceImage = faceImage;
    
    if (!_images || !_images.count)
    {
        _images = [[NSArray alloc] initWithObjects:_faceImage, nil];
        [self reloadData];
    }
    else
    {
        //影集 ？
    }
}

@end

@interface RWPhotoAlbumCell ()

<
    UIScrollViewDelegate,
    UIGestureRecognizerDelegate
>

@property (nonatomic,strong)UIScrollView *photoView;
@property (nonatomic,strong)UIImageView *imageView;

@end

@implementation RWPhotoAlbumCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        _photoView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:_photoView];
        
        _photoView.backgroundColor = [UIColor clearColor];
        _photoView.contentSize = _photoView.bounds.size;
        _photoView.scrollsToTop = NO;
        _photoView.minimumZoomScale = 0.5f;
        _photoView.maximumZoomScale = 4.0f;
        _photoView.delegate = self;
        _photoView.showsVerticalScrollIndicator = NO;
        _photoView.showsHorizontalScrollIndicator = NO;
        
        UITapGestureRecognizer *closeView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
        closeView.numberOfTapsRequired = 1;
        
        [_photoView addGestureRecognizer:closeView];
        
        _imageView = [[UIImageView alloc] init];
        [_photoView addSubview:_imageView];
        _imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *changeSize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeSize)];
        changeSize.numberOfTapsRequired = 2;
        [_imageView addGestureRecognizer:changeSize];
        
        UITapGestureRecognizer *wait = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(waitFor)];
        wait.numberOfTapsRequired = 1;
        [_imageView addGestureRecognizer:wait];
    }
    
    return self;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

- (void)changeSize
{
    if (_photoView.zoomScale == 1.0f)
    {
        _photoView.zoomScale = 2.0f;
    }
    else
    {
        _photoView.zoomScale = 1.0f;
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    _imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)close
{
    if (_delegate)
    {
        [_delegate closeFaceView];
    }
}

- (void)waitFor{}

- (void)setImage:(UIImage *)image
{
    _image = image;
    
    CGSize imageSize = _image.size;
    
    CGFloat width = __MAIN_SCREEN_WIDTH__;
    CGFloat height = width / imageSize.width * imageSize.height;
    
    if (height > __MAIN_SCREEN_HEIGHT__)
    {
        height = __MAIN_SCREEN_HEIGHT__;
        width =  height / imageSize.height * imageSize.width;
    }
    
    _imageView.frame = CGRectMake(0, 0, width, height);
    _imageView.center = CGPointMake(_photoView.contentSize.width / 2, _photoView.contentSize.height / 2);
    _photoView.contentSize = _imageView.bounds.size;
    _imageView.image = _image;
}

@end
