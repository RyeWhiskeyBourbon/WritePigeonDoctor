//
//  RWWeiChatView.h
//  RWWeChatController
//
//  Created by zhongyu on 16/7/13.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EMSDK.h>
#import "RWChatManager.h"
#import "XZMicroVideoPlayerView.h"

@class RWWeChatMessage ,RWWeChatView,RWWeChatCell;
typedef NS_ENUM(NSInteger,RWTextMenuType);

typedef NS_ENUM(NSInteger,RWMessageType)
{
    RWMessageTypeText,
    RWMessageTypeVoice,
    RWMessageTypeImage,
    RWMessageTypeVideo
};

typedef NS_ENUM(NSInteger,RWMessageEvent)
{
    RWMessageEventPressText,
    RWMessageEventPressImage,
    RWMessageEventPressVoice,
    RWMessageEventPressVideo,
    RWMessageEventTapImage,
    RWMessageEventTapVoice,
    RWMessageEventTapVideo
};

NSString *getDate(NSDate *messageDate);
CGSize getFitSize(NSString *text,UIFont *font,CGFloat width,CGFloat lines);
CGSize getFitImageSize(UIImage *image);
CGFloat getArrowheadX(RWWeChatCell *cell);
CGRect getFitVideoSize(CGSize originalSize,BOOL isMyMessage);

@protocol RWWeChatViewEvent <NSObject>
@optional

- (void)wechatCell:(RWWeChatCell *)wechat event:(RWMessageEvent)event;

- (void)touchSpaceAtwechatView:(RWWeChatView *)wechatView;

@end

@interface RWWeChatView : UITableView

+ (instancetype)chatViewWithAutoLayout:(void (^)(MASConstraintMaker *))autoLayout messages:(NSArray *)messages;

@property (nonatomic,strong)NSMutableArray *messages;

@property (nonatomic,assign)id<RWWeChatViewEvent> eventSource;

- (void)setAutoLayout:(void (^)(MASConstraintMaker *))autoLayout;

- (void)addMessage:(RWWeChatMessage *)message;
- (void)removeMessage:(RWWeChatMessage *)message;

@end

@interface RWWeChatMessage : NSObject

+ (instancetype)message:(EMMessage *)message
                 header:(UIImage *)header
                   type:(RWMessageType)type
              myMessage:(BOOL)isMyMessage
            messageDate:(NSDate *)messageDate
               showTime:(BOOL)showTime
       originalResource:(id)originalResource;

@property (nonatomic,assign)RWMessageType messageType;

@property (nonatomic,strong)UIImage *header;
@property (nonatomic,assign)BOOL isMyMessage;
@property (nonatomic,assign)BOOL showTime;
@property (nonatomic,assign,readonly)CGFloat itemHeight;


@property (nonatomic,strong)NSDate *messageDate;
@property (nonatomic,strong,readonly)NSString *dateString;

@property (nonatomic,strong)EMMessage *message;

@property (nonatomic,strong)id originalResource;

@end

@interface RWMarginsLabel : UIView

@property (nonatomic,strong)UILabel *textLabel;
@property (nonatomic,assign)CGFloat margins;

@property (nonatomic,copy,readonly)void(^autoLayout)(MASConstraintMaker *make);

- (void)setAutoLayout:(void(^)(MASConstraintMaker *make))autoLayout;

@end

@interface RWVoicePlayButton : UIButton

@property (nonatomic,strong,readonly)UIImageView *playAnimation;
@property (nonatomic,strong)UILabel *second;

@property (nonatomic,copy,readonly)void(^autoLayout)(MASConstraintMaker *make);
@property (nonatomic,assign)BOOL isMyMessage;

- (void)setAutoLayout:(void(^)(MASConstraintMaker *make))autoLayout isMyMessage:(BOOL)isMyMessage;

@end

@interface RWWeChatCell :UITableViewCell

@property (nonatomic,assign)id<RWWeChatViewEvent> eventSource;

@property (nonatomic,strong)RWWeChatMessage *message;

@property (nonatomic,strong,readonly)RWMarginsLabel *contentLabel;
@property (nonatomic,strong,readonly)RWVoicePlayButton *voiceButton;
@property (nonatomic,strong,readonly)UIImageView *contentImage;
@property (nonatomic,strong,readonly)XZMicroVideoPlayerView *videoPlayer;


@end

@interface RWChatMenuView : UIView

+ (instancetype)menuWithFrame:(CGRect)frame order:(void (^)(RWTextMenuType type))order message:(RWWeChatMessage *)message arrowheadDistance:(CGFloat)arrowheadDistance;

@property (nonatomic,strong)RWWeChatMessage *message;

@end

typedef NS_ENUM(NSInteger,RWTextMenuType)
{
    RWTextMenuTypeOfCopy,
    RWTextMenuTypeOfRelay,
    RWTextMenuTypeOfCollect,
    RWTextMenuTypeOfDelete
};

@interface RWTextMenu : UICollectionView

+ (instancetype)textMenuWithFrame:(CGRect)frame responseOrder:(void (^)(RWTextMenuType type))order isText:(BOOL)isText;

@property (nonatomic,assign)BOOL isText;

@end

@interface RWTextMenuCell : UICollectionViewCell

@property (nonatomic,strong)UILabel *textLabel;

@end

@interface UIImage (changeColor)

- (UIImage *)imageWithColor:(UIColor *)color;

@end

@interface RWPhotoAlbum : UICollectionView

+ (instancetype)photoAlbumWithImage:(UIImage *)image;

@property (nonatomic,strong)UIImage *faceImage;

@end

@protocol RWPhotoAlbumCellDelegate <NSObject>

- (void)closeFaceView;

@end

@interface RWPhotoAlbumCell : UICollectionViewCell

@property (nonatomic,strong)UIImage *image;
@property (nonatomic,assign)id<RWPhotoAlbumCellDelegate> delegate;

@end

