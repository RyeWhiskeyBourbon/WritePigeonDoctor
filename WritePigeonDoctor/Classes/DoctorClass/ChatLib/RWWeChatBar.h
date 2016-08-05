//
//  RWWeChatBar.h
//  RWWeChatController
//
//  Created by zhongyu on 16/7/15.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "RWWeiChatView.h"

@class RWWeChatBar,RWTextField;
@class RWAccessoryInputView,RWAccessoryPurposeMenu;
typedef NS_ENUM(NSInteger,RWPurposeMenu);

typedef NS_ENUM(NSInteger,RWChatBarButton)
{
    RWChatBarButtonNone = 0,
    
    RWChatBarButtonOfMessageType = 1,
    RWChatBarButtonOfExpressionKeyboard = 2,
    RWChatBarButtonOfOtherFunction = 3
};

@protocol RWWeChatBarDelegate <NSObject>
@optional

- (void)beginEditingTextAtChatBar:(RWWeChatBar *)chatBar;
- (void)sendMessage:(EMMessage *)message type:(RWMessageType)type LocalResource:(id)resource;
- (void)sendVoice:(NSData *)voice time:(NSInteger)second MP3Path:(NSString *)path;

- (void)openAccessoryInputViewAtChatBar:(RWWeChatBar *)chatBar;
- (void)openMultiPurposeMenuAtChatBar:(RWWeChatBar *)chatBar;

- (void)keyboardWillChangeSize:(NSNotification *)notification;

- (void)chatBar:(RWWeChatBar *)chatBar selectedFunction:(RWPurposeMenu)function;

@end

@interface RWWeChatBar : UIView

+ (instancetype)wechatBarWithAutoLayout:(void(^)(MASConstraintMaker *))autoLayout;

- (void)setAutoLayout:(void (^)(MASConstraintMaker *))autoLayout;

@property (nonatomic,assign,readonly)BOOL isTextMessage;

@property (nonatomic,strong)RWAccessoryPurposeMenu *purposeMenu;
@property (nonatomic,strong)RWAccessoryInputView *inputView;

@property (nonatomic,assign,readonly)RWChatBarButton faceResponceAccessory;

@property (nonatomic,assign)id<RWWeChatBarDelegate> delegate;
@property (nonatomic,strong)RWTextField *makeTextMessage;

@end

@interface RWTextField : UIView

+ (instancetype)textFieldWithAutoLayout:(void(^)(MASConstraintMaker *))autoLayout margins:(CGFloat)margins;

@property (nonatomic,strong)UITextView *textView;

@property (nonatomic,assign,readonly)CGFloat margins;
@property (nonatomic,copy,readonly)void (^autoLayout)(MASConstraintMaker *);

@property (nonatomic,assign)id<RWWeChatBarDelegate> delegate;

- (void)setMargins:(CGFloat)margins;
- (void)setAutoLayout:(void (^)(MASConstraintMaker *))autoLayout;

@end

typedef NS_ENUM(NSInteger,RWPurposeMenu)
{
    RWPurposeMenuOfPhoto = 0,
    RWPurposeMenuOfCamera,
    RWPurposeMenuOfSmallVideo,
    RWPurposeMenuOfVideoCall,
    RWPurposeMenuOfLocation,
    RWPurposeMenuOfCollect,
    RWPurposeMenuOfMyCard
};

@protocol RWAccessoryDelegate <NSObject>
@optional

- (void)accessoryInputView:(RWAccessoryInputView *)inputView selectedItem:(NSString *)item;
- (void)deleteAItemAtAccessoryInputView:(RWAccessoryInputView *)inputView;
- (void)sendMessageAtAccessoryInputView:(RWAccessoryInputView *)inputView;

- (void)accessoryPurposeMenu:(RWAccessoryPurposeMenu *)purposeMenu selectedFunction:(RWPurposeMenu)function;

@end

@interface RWAccessoryBaseView : UIView

<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic,strong)UICollectionView *inputView;

@property (nonatomic,strong)UIPageControl *pageView;

@property (nonatomic,assign)id<RWAccessoryDelegate> delegate;

@end

BOOL isContainsEmoji(NSString *string);
NSArray *defaultEmoticons();

@interface RWAccessoryInputView : RWAccessoryBaseView

+ (instancetype)accessoryInputViewWithFrame:(CGRect)frame;

@property (nonatomic,strong)UIButton *send;

@property (nonatomic,strong)NSArray *resource;

@end

@interface RWAccessoryPurposeMenu : RWAccessoryBaseView

+ (instancetype)accessoryPurposeMenuWithFrame:(CGRect)frame;

@property (nonatomic,strong)NSArray *resource;

@end

struct RWSquareTarget
{
    NSUInteger horizontal;
    NSUInteger vertical;
};

typedef struct RWSquareTarget RWSquareTarget;
RWSquareTarget RWSquareTargetMake(NSUInteger horizontal,NSUInteger vertical);

@interface RWInputViewPageCell : UICollectionViewCell

@property (nonatomic,strong,readonly)NSArray *items;
@property (nonatomic,assign,readonly)RWSquareTarget square;

- (void)compositonItems:(NSArray *)items squareTarget:(RWSquareTarget)square selectedItem:(void(^)(NSString *item))selectedItem;

@end

@interface RWInputViewItemCell : UICollectionViewCell

@property (nonatomic,strong)UILabel *item;

@end

@interface RWPurposeMenuPageCell : UICollectionViewCell

@property (nonatomic,strong,readonly)NSArray *items;
@property (nonatomic,assign,readonly)RWSquareTarget square;
@property (nonatomic,strong,readonly)NSIndexPath *superIndexPath;

- (void)compositonItems:(NSArray *)items squareTarget:(RWSquareTarget)square indexPath:(NSIndexPath *)indexPath selectedMenu:(void (^)(RWPurposeMenu menu))selectedMenu;

@end

@interface RWPurposeMenuItemCell : UICollectionViewCell

@property (nonatomic,strong)UIImageView *imageView;

@end
