//
//  RWWeChatBar.m
//  RWWeChatController
//
//  Created by zhongyu on 16/7/15.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWWeChatBar.h"
#import "FEButton.h"

#define EMOJI_CODE_TO_SYMBOL(x) ((((0x808080F0 | (x & 0x3F000) >> 4) | (x & 0xFC0) << 10) | (x & 0x1C0000) << 18) | (x & 0x3F) << 24);

@interface RWWeChatBar ()

<
    RWWeChatBarDelegate,
    UITextViewDelegate,
    RWAccessoryDelegate,
    FEButtonViewDelegate
>

@property (nonatomic,strong)FEButton *makeVoiceMessage;

@property (nonatomic,strong)UIImageView *messageType;

@property (nonatomic,strong)UIImageView *expressionKeyboard;

@property (nonatomic,strong)UIImageView *otherFunction;

@property (nonatomic,copy)void(^autoLayout)(MASConstraintMaker *make);

@end

@implementation RWWeChatBar

+ (instancetype)wechatBarWithAutoLayout:(void (^)(MASConstraintMaker *))autoLayout
{
    RWWeChatBar *bar = [[RWWeChatBar alloc] init];
    
    bar.autoLayout = autoLayout;
    
    return bar;
}

- (void)setAutoLayout:(void (^)(MASConstraintMaker *))autoLayout
{
    _autoLayout = autoLayout;
    
    if (self.superview.window)
    {
        [self mas_makeConstraints:_autoLayout];
        [self autoLayoutViews];
    }
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    if (_autoLayout)
    {
        [self mas_makeConstraints:_autoLayout];
        [self autoLayoutViews];
    }
}

- (void)initViews
{
    _purposeMenu =
            [RWAccessoryPurposeMenu accessoryPurposeMenuWithFrame:__KEYBOARD_FRAME__];
    
    _inputView = [RWAccessoryInputView accessoryInputViewWithFrame:__KEYBOARD_FRAME__];
    
    _makeTextMessage = [[RWTextField alloc] init];
    [self addSubview:_makeTextMessage];
    
    _makeVoiceMessage = [[FEButton alloc] initWithSuperView:self
                                         setBackgroundImage:nil];
    [self addSubview:_makeVoiceMessage];
    
    _messageType = [[UIImageView alloc] init];
    _messageType.tag = RWChatBarButtonOfMessageType;
    [self addSubview:_messageType];
    
    _expressionKeyboard = [[UIImageView alloc] init];
    _expressionKeyboard.tag = RWChatBarButtonOfExpressionKeyboard;
    [self addSubview:_expressionKeyboard];
    
    _otherFunction = [[UIImageView alloc] init];
    _otherFunction.tag = RWChatBarButtonOfOtherFunction;
    [self addSubview:_otherFunction];
}

#pragma mark - voice delegate

- (void)sendVoice:(NSData *)voice time:(NSInteger)second MP3Path:(NSString *)path
{
    [_delegate sendMessage:
     
     [RWChatMessageMaker messageWithType:EMMessageBodyTypeVoice
                                    body:@{messageVideoBody:path,
                                           messageVideoName:[RWChatManager voiceName],
                                           messageVoiceDuration:@(second)}
                               extension:nil]
     
                      type:RWMessageTypeVoice LocalResource:voice];
}

- (void)setDefaultSettings
{
    self.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    self.layer.borderColor = [__BORDER_COLOR__ CGColor];
    self.layer.borderWidth = 0.3;
    
    _messageType.image = [UIImage imageNamed:@"喇叭"];
    _expressionKeyboard.image = [UIImage imageNamed:@"表情"];
    _otherFunction.image = [UIImage imageNamed:@"加号"];
    
    _purposeMenu.delegate = self;
    _inputView.delegate = self;
    
    _isTextMessage = YES;
    _makeVoiceMessage.hidden = YES;
    
    _makeTextMessage.backgroundColor = [UIColor whiteColor];
    [_makeTextMessage setMargins:5.f];
    _makeTextMessage.layer.cornerRadius = 3;
    _makeTextMessage.clipsToBounds = YES;
    _makeTextMessage.textView.font = __RWGET_SYSFONT(14);
    _makeTextMessage.textView.textAlignment = NSTextAlignmentLeft;
    _makeTextMessage.textView.delegate = self;
    _makeTextMessage.layer.borderWidth = 0.3;
    _makeTextMessage.layer.borderColor = [__BORDER_COLOR__ CGColor];
    
    _makeVoiceMessage.layer.cornerRadius = 3;
    _makeVoiceMessage.clipsToBounds = YES;
    _makeVoiceMessage.layer.borderWidth = 0.3;
    _makeVoiceMessage.layer.borderColor = [__BORDER_COLOR__ CGColor];
    _makeVoiceMessage.delegate = self;
    
    [_makeVoiceMessage setTitle:@"按住  说话"
                       forState:UIControlStateNormal];
    [_makeVoiceMessage setTitleColor:__BORDER_COLOR__
                            forState:UIControlStateNormal];
    
    [_makeVoiceMessage setTitle:@"松开  发送"
                       forState:UIControlStateSelected];
    [_makeVoiceMessage setTitleColor:self.backgroundColor
                            forState:UIControlStateSelected];
    
    [self addGestureRecognizers];
}

#pragma mark - textView Delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        if (!textView.text.length)
        {
            [textView resignFirstResponder];
            
            return NO;
        }
        
        if (_delegate)
        {
            [_delegate sendMessage:
             
             [RWChatMessageMaker messageWithType:EMMessageBodyTypeText
                                            body:@{messageTextBody:textView.text}
                                       extension:nil]
             
                              type:RWMessageTypeText
                     LocalResource:nil];
        }
        
        textView.text = nil;
        
        return NO;
    }
    
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (_delegate)
    {
        [_delegate beginEditingTextAtChatBar:self];
        _faceResponceAccessory = RWChatBarButtonNone;
    }
    
    return YES;
}

#pragma mark - accessory delegate

- (void)accessoryInputView:(RWAccessoryInputView *)inputView selectedItem:(NSString *)item
{
    NSString *text = _makeTextMessage.textView.text;
    
    _makeTextMessage.textView.text = [NSString stringWithFormat:@"%@%@",text,item];
}

- (void)deleteAItemAtAccessoryInputView:(RWAccessoryInputView *)inputView
{
    NSString *text = _makeTextMessage.textView.text;
    
    if (text.length == 0)
    {
        return;
    }
    else if (text.length == 1)
    {
        _makeTextMessage.textView.text = nil;
        return;
    }
    
    if (isContainsEmoji([text substringFromIndex:text.length - 2]))
    {
        if (text.length == 2)
        {
            _makeTextMessage.textView.text = nil;
            return;
        }
        
        _makeTextMessage.textView.text = [text substringToIndex:text.length - 2];
    }
    else
    {
        _makeTextMessage.textView.text = [text substringToIndex:text.length - 1];
    }
}

- (void)sendMessageAtAccessoryInputView:(RWAccessoryInputView *)inputView
{
    if (_delegate)
    {
        [_delegate sendMessage:
         
         [RWChatMessageMaker messageWithType:EMMessageBodyTypeText
                                        body:
                                    @{messageTextBody:_makeTextMessage.textView.text}
                                   extension:nil]
         
                          type:RWMessageTypeText
                 LocalResource:nil];
        
        _makeTextMessage.textView.text = nil;
    }
}

- (void)accessoryPurposeMenu:(RWAccessoryPurposeMenu *)purposeMenu selectedFunction:(RWPurposeMenu)function
{
    if (_delegate)
    {
        [_delegate chatBar:self selectedFunction:function];
    }
}

#pragma mark - Gesture

- (void)addGestureRecognizers
{
    UITapGestureRecognizer *tapMessageType = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewWithGestureRecognizer:)];
    tapMessageType.numberOfTapsRequired = 1;
    _messageType.userInteractionEnabled = YES;
    [_messageType addGestureRecognizer:tapMessageType];
    
    UITapGestureRecognizer *tapExpression = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewWithGestureRecognizer:)];
    tapExpression.numberOfTapsRequired = 1;
    _expressionKeyboard.userInteractionEnabled = YES;
    [_expressionKeyboard addGestureRecognizer:tapExpression];
    
    UITapGestureRecognizer *tapOtherFunc = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewWithGestureRecognizer:)];
    tapOtherFunc.numberOfTapsRequired = 1;
    _otherFunction.userInteractionEnabled = YES;
    [_otherFunction addGestureRecognizer:tapOtherFunc];
}

- (void)tapViewWithGestureRecognizer:(UITapGestureRecognizer *)gestureRecognizer
{
    switch (gestureRecognizer.view.tag)
    {
        case RWChatBarButtonOfMessageType:
            
            if (_isTextMessage)
            {
                _makeTextMessage.hidden = YES;
                _makeVoiceMessage.hidden = NO;
                _isTextMessage = NO;
                _messageType.image = [UIImage imageNamed:@"keyboard"];
            }
            else
            {
                _makeTextMessage.hidden = NO;
                _makeVoiceMessage.hidden = YES;
                _isTextMessage = YES;
                _messageType.image = [UIImage imageNamed:@"喇叭"];
            }
            
            break;
        case RWChatBarButtonOfExpressionKeyboard:
            
            _faceResponceAccessory = RWChatBarButtonOfExpressionKeyboard;
            
            if (!_isTextMessage)
            {
                _makeTextMessage.hidden = NO;
                _makeVoiceMessage.hidden = YES;
                _isTextMessage = YES;
                _messageType.image = [UIImage imageNamed:@"喇叭"];
            }
            
            [_makeTextMessage.textView resignFirstResponder];
            
            if (_delegate)
            {
                [_delegate openAccessoryInputViewAtChatBar:self];
            }
            
            break;
        case RWChatBarButtonOfOtherFunction:
            
            _faceResponceAccessory = RWChatBarButtonOfOtherFunction;
            
            if (!_isTextMessage)
            {
                _makeTextMessage.hidden = NO;
                _makeVoiceMessage.hidden = YES;
                _isTextMessage = YES;
            }
            
            [_makeTextMessage.textView resignFirstResponder];
            
            if (_delegate)
            {
                [_delegate openMultiPurposeMenuAtChatBar:self];
            }
            
            break;
            
        default: break;
    }
}

- (void)autoLayoutViews
{
    [_messageType mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.width.equalTo(@(35));
        make.height.equalTo(@(35));
        make.left.equalTo(self.mas_left).offset(5);
        make.centerY.equalTo(self.mas_centerY).offset(0);
    }];
    
    [_otherFunction mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(35));
        make.height.equalTo(@(35));
        make.right.equalTo(self.mas_right).offset(-5);
        make.centerY.equalTo(self.mas_centerY).offset(0);
    }];
    
    [_expressionKeyboard mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(35));
        make.height.equalTo(@(35));
        make.right.equalTo(_otherFunction.mas_left).offset(-5);
        make.centerY.equalTo(self.mas_centerY).offset(0);
    }];
    
    UIImageView *weakType = _messageType;
    UIImageView *weakKeyboard = _expressionKeyboard;
    RWWeChatBar *weakSelf = self;
    
    [_makeTextMessage setAutoLayout:^(MASConstraintMaker *make) {
       
        make.left.equalTo(weakType.mas_right).offset(5);
        make.right.equalTo(weakKeyboard.mas_left).offset(-5);
        make.top.equalTo(weakSelf.mas_top).offset(7);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-7);
    }];
    
    [_makeVoiceMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_messageType.mas_right).offset(5);
        make.right.equalTo(_expressionKeyboard.mas_left).offset(-5);
        make.top.equalTo(self.mas_top).offset(7);
        make.bottom.equalTo(self.mas_bottom).offset(-7);
    }];
}

#pragma mark - init

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        [self initViews];
        [self setDefaultSettings];
    }
    
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    
    _makeVoiceMessage.backgroundColor = backgroundColor;
}

- (void)setDelegate:(id<RWWeChatBarDelegate>)delegate
{
    _delegate = delegate;
    
    _makeTextMessage.delegate = _delegate;
}

@end

@implementation RWTextField

+ (instancetype)textFieldWithAutoLayout:(void (^)(MASConstraintMaker *))autoLayout margins:(CGFloat)margins
{
    RWTextField *text = [[RWTextField alloc] init];
    
    [text setMargins:margins];
    [text setAutoLayout:autoLayout];
    
    return text;
}

- (void)setAutoLayout:(void (^)(MASConstraintMaker *))autoLayout
{
    _autoLayout = autoLayout;
    
    if (self.superview)
    {
        [self mas_remakeConstraints:_autoLayout];
        [self autoLayoutViewWithMargins:_margins];
    }
}

- (void)setMargins:(CGFloat)margins
{
    _margins = margins;
    
    if (self.superview && _autoLayout)
    {
        [self autoLayoutViewWithMargins:_margins];
    }
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    if (_autoLayout)
    {
        [self mas_makeConstraints:_autoLayout];
        [self autoLayoutViewWithMargins:_margins];
    }
}

- (void)autoLayoutViewWithMargins:(CGFloat)margins
{
    [_textView mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left).offset(margins);
        make.right.equalTo(self.mas_right).offset(-margins);
        make.top.equalTo(self.mas_top).offset(2);
        make.bottom.equalTo(self.mas_bottom).offset(-2);
    }];
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _textView = [[UITextView alloc] init];
        _textView.showsVerticalScrollIndicator = NO;
        _textView.showsHorizontalScrollIndicator = NO;
        _textView.bounces = NO;
        _textView.returnKeyType = UIReturnKeySend;
        [self addSubview:_textView];
        _textView.backgroundColor = [UIColor clearColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWasShown:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWasHidden:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:
                                            @selector(keyboardWillChangeFrame:)
                                                     name:
                                                UIKeyboardWillChangeFrameNotification
                                                   object:nil];
    }
    
    return self;
}

- (void)keyboardWasShown:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    
    CGSize keyboardSize = [value CGRectValue].size;
    
    if (_delegate)
    {
        [_delegate keyBoardWillShowWithSize:keyboardSize];
    }
}

- (void)keyboardWasHidden:(NSNotification *)notification
{
    if (_delegate)
    {
        [_delegate keyBoardWillHidden];
    }
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];//更改后的键盘
    
    CGSize keyboardSize = [aValue CGRectValue].size;
    
    if (_delegate)
    {
        [_delegate keyboardWillChangeSize:keyboardSize];
    }
}

@end

NSArray *defaultEmoticons()
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (int i = 0x1F600; i <= 0x1F64F; i++)
    {
        if (i < 0x1F641 || i > 0x1F644)
        {
            int sym = EMOJI_CODE_TO_SYMBOL(i);
            
            NSString *emoT = [[NSString alloc] initWithBytes:&sym length:sizeof(sym) encoding:NSUTF8StringEncoding];
            [array addObject:emoT];
        }
    }
    return array;
}

BOOL isContainsEmoji(NSString *string)
{
    __block BOOL isEomji = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
     {
         const unichar hs = [substring characterAtIndex:0];
         
         if (0xd800 <= hs && hs <= 0xdbff)
         {
             if (substring.length > 1)
             {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f)
                 {
                     isEomji = YES;
                 }
             }
         }
         else
         {
             
             if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b)
             {
                 isEomji = YES;
             }
             else if (0x2B05 <= hs && hs <= 0x2b07)
             {
                 isEomji = YES;
             }
             else if (0x2934 <= hs && hs <= 0x2935)
             {
                 isEomji = YES;
             }
             else if (0x3297 <= hs && hs <= 0x3299)
             {
                 isEomji = YES;
             }
             else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a )
             {
                 isEomji = YES;
             }
             
             if (!isEomji && substring.length > 1)
             {
                 const unichar ls = [substring characterAtIndex:1];
                 
                 if (ls == 0x20e3)
                 {
                     isEomji = YES;
                 }
             }
         }
     }];
    
    return isEomji;
}

@implementation RWAccessoryBaseView

- (void)initViews
{
    self.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    _inputView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];
    [self addSubview:_inputView];
    
    _inputView.backgroundColor = self.backgroundColor;
    
    _inputView.showsVerticalScrollIndicator = NO;
    _inputView.showsHorizontalScrollIndicator = NO;
    _inputView.pagingEnabled = YES;
    
    _inputView.delegate = self;
    _inputView.dataSource = self;
    
    _pageView = [[UIPageControl alloc] init];
    [self addSubview:_pageView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.height);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self initViews];
    }
    
    return self;
}

@end

@implementation RWAccessoryInputView

+ (instancetype)accessoryInputViewWithFrame:(CGRect)frame
{
    return  [[RWAccessoryInputView alloc] initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self.inputView registerClass:[RWInputViewPageCell class]
       forCellWithReuseIdentifier:NSStringFromClass([RWInputViewPageCell class])];
        
        _send = [[UIButton alloc] init];
        [self addSubview:_send];
        
        [_send setTitle:@"发送" forState:UIControlStateNormal];
        _send.backgroundColor = [UIColor blueColor];
        _send.titleLabel.font = [UIFont systemFontOfSize:13];
        
        [_send addTarget:self
                  action:@selector(sendMessage)
        forControlEvents:UIControlEventTouchUpInside];
        
        _send.layer.cornerRadius = 5;
    }
    return self;
}

- (void)sendMessage
{
    [self.delegate sendMessageAtAccessoryInputView:self];
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    NSMutableArray *emots = [defaultEmoticons() mutableCopy];
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < emots.count; i++)
    {
        if (i == emots.count - 1)
        {
            [temp addObject:@"i"];
            [items addObject:[temp copy]];
            [temp removeAllObjects];
            
            break;
        }
        
        if (i % 32 == 31)
        {
            [temp addObject:@"i"];
            [items addObject:[temp copy]];
            [temp removeAllObjects];
            
            continue;
        }
        
        [temp addObject:emots[i]];
    }
    
    _resource = items;
    
    self.pageView.numberOfPages = items.count;
    
    self.pageView.currentPage = 0;
    self.pageView.currentPageIndicatorTintColor = [UIColor blackColor];
    self.pageView.pageIndicatorTintColor = [UIColor whiteColor];
    
    [self autoLayoutViews];
    [self.inputView reloadData];
}

- (void)autoLayoutViews
{
    [self.pageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(-40);
        make.height.equalTo(@(20));
    }];
    
    [_send mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.equalTo(@(40));
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self.pageView.mas_bottom).offset(5);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
    }];
    
    [self.inputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self.mas_top).offset(10);
        make.bottom.equalTo(self.pageView.mas_top).offset(-10);
    }];
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _resource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.pageView.currentPage = indexPath.row;
    
    RWInputViewPageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([RWInputViewPageCell class]) forIndexPath:indexPath];
    
    [cell compositonItems:_resource[indexPath.row]
             squareTarget:RWSquareTargetMake(8, 4)
             selectedItem:^(NSString *item) {
                 
                 if ([item isEqualToString:@"i"])
                 {
                     [self.delegate deleteAItemAtAccessoryInputView:self];
                 }
                 else
                 {
                     [self.delegate accessoryInputView:self
                                          selectedItem:item];
                 }
             }];
    
    cell.backgroundColor = collectionView.backgroundColor;
    
    return cell;
}

@end

@implementation RWAccessoryPurposeMenu

+ (instancetype)accessoryPurposeMenuWithFrame:(CGRect)frame
{
    return  [[RWAccessoryPurposeMenu alloc] initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self.inputView registerClass:[RWPurposeMenuPageCell class]
           forCellWithReuseIdentifier:NSStringFromClass([RWPurposeMenuPageCell class])];
    }
    
    return self;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    _resource = @[@[[UIImage imageNamed:@"照片"],
                    [UIImage imageNamed:@"拍摄"],
                    [UIImage imageNamed:@"小视频"],
                    [UIImage imageNamed:@"小视频"],
                    [UIImage imageNamed:@"位置"],
                    [UIImage imageNamed:@"收藏"],
                    [UIImage imageNamed:@"个人名片"]]];
    
    self.pageView.numberOfPages = _resource.count;
    
    self.pageView.currentPage = 0;
    self.pageView.currentPageIndicatorTintColor = [UIColor blackColor];
    self.pageView.pageIndicatorTintColor = [UIColor whiteColor];
    
    [self autoLayoutViews];
    [self.inputView reloadData];
}

- (void)autoLayoutViews
{
    [self.pageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.height.equalTo(@(20));
    }];
    
    [self.inputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self.mas_top).offset(10);
        make.bottom.equalTo(self.pageView.mas_top).offset(-10);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _resource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RWPurposeMenuPageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([RWPurposeMenuPageCell class]) forIndexPath:indexPath];
    
    [cell compositonItems:_resource[indexPath.row]
             squareTarget:RWSquareTargetMake(4, 2)
                indexPath:indexPath
             selectedMenu:^(RWPurposeMenu menu)
    {
        [self.delegate accessoryPurposeMenu:self selectedFunction:menu];
    }];
    
    return cell;
}

@end

@interface RWInputViewPageCell ()

<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic,strong)UICollectionView *itemsContainer;

@property (nonatomic,copy)void(^selectedItem)(NSString *item);

@end

RWSquareTarget RWSquareTargetMake(NSUInteger horizontal,NSUInteger vertical)
{
    RWSquareTarget square;
    square.horizontal = horizontal;
    square.vertical = vertical;
    
    return square;
}

@implementation RWInputViewPageCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        UICollectionViewFlowLayout *flowLayout =
                                            [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        _itemsContainer = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];
        
        [self addSubview:_itemsContainer];
        
        [_itemsContainer mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(self.mas_left).offset(0);
            make.right.equalTo(self.mas_right).offset(0);
            make.top.equalTo(self.mas_top).offset(0);
            make.bottom.equalTo(self.mas_bottom).offset(0);
        }];
        
        _itemsContainer.backgroundColor = [UIColor clearColor];
        
        _itemsContainer.showsVerticalScrollIndicator = NO;
        _itemsContainer.showsHorizontalScrollIndicator = NO;
        
        _itemsContainer.delegate = self;
        _itemsContainer.dataSource = self;
        
        [_itemsContainer registerClass:[RWInputViewItemCell class] forCellWithReuseIdentifier:NSStringFromClass([RWInputViewItemCell class])];
    }
    
    return self;
}

- (void)compositonItems:(NSArray *)items squareTarget:(RWSquareTarget)square selectedItem:(void(^)(NSString *item))selectedItem
{
    if (items.count > square.vertical * square.horizontal)
    {
        _items = nil; [_itemsContainer reloadData];
        return;
    }
    
    _square = square; _items = items; _selectedItem = selectedItem;
    
    [_itemsContainer reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RWInputViewItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([RWInputViewItemCell class]) forIndexPath:indexPath];
    
    cell.item.text = _items[indexPath.row];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.bounds.size.width/_square.horizontal, collectionView.bounds.size.height/_square.vertical);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectedItem)
    {
        _selectedItem(_items[indexPath.row]);
    }
}

@end

@implementation RWInputViewItemCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _item = [[UILabel alloc] init];
        _item.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_item];
        
        [_item mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(self.mas_left).offset(0);
            make.right.equalTo(self.mas_right).offset(0);
            make.bottom.equalTo(self.mas_bottom).offset(0);
            make.top.equalTo(self.mas_top).offset(0);
        }];
    }
    
    return self;
}

@end

@interface RWPurposeMenuPageCell ()

<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic,strong)UICollectionView *itemsContainer;

@property (nonatomic,copy)void(^selectedMenu)(RWPurposeMenu menu);

@end

@implementation RWPurposeMenuPageCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        UICollectionViewFlowLayout *flowLayout =
                                            [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        _itemsContainer = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];
        
        [self addSubview:_itemsContainer];
        
        [_itemsContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).offset(0);
            make.right.equalTo(self.mas_right).offset(0);
            make.top.equalTo(self.mas_top).offset(0);
            make.bottom.equalTo(self.mas_bottom).offset(0);
        }];
        
        _itemsContainer.backgroundColor = [UIColor clearColor];
        
        _itemsContainer.showsVerticalScrollIndicator = NO;
        _itemsContainer.showsHorizontalScrollIndicator = NO;
        
        _itemsContainer.delegate = self;
        _itemsContainer.dataSource = self;
        
        [_itemsContainer registerClass:[RWPurposeMenuItemCell class] forCellWithReuseIdentifier:NSStringFromClass([RWPurposeMenuItemCell class])];
    }
    
    return self;
}

- (void)compositonItems:(NSArray *)items squareTarget:(RWSquareTarget)square indexPath:(NSIndexPath *)indexPath selectedMenu:(void (^)(RWPurposeMenu menu))selectedMenu
{
    if (items.count > square.vertical * square.horizontal)
    {
        _items = nil; [_itemsContainer reloadData];
        return;
    }
    
    _square = square; _items = items;
    _selectedMenu = selectedMenu; _superIndexPath = indexPath;
    
    [_itemsContainer reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RWPurposeMenuItemCell *cell =
            [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([RWPurposeMenuItemCell class]) forIndexPath:indexPath];

    cell.imageView.image = _items[indexPath.row];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.bounds.size.width/_square.horizontal, collectionView.bounds.size.height/_square.vertical);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectedMenu)
    {
        _selectedMenu(indexPath.row + _superIndexPath.row * _square.horizontal * _square.vertical);
    }
}

@end

@implementation RWPurposeMenuItemCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
        
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(self.mas_left).offset(0);
            make.right.equalTo(self.mas_right).offset(0);
            make.bottom.equalTo(self.mas_bottom).offset(0);
            make.top.equalTo(self.mas_top).offset(0);
        }];
    }
    
    return self;
}

@end

