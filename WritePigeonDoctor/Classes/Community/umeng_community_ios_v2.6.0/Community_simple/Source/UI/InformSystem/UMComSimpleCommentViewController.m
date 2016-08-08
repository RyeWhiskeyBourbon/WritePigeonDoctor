//
//  UMComSimpleCommentViewController.m
//  UMCommunity
//
//  Created by wyq.Cloudayc on 5/25/16.
//  Copyright © 2016 Umeng. All rights reserved.
//

#import "UMComSimpleCommentViewController.h"
#import "UIViewController+UMComAddition.h"
#import "UMComTools.h"
#import "UMComSimpleSubCommentViewController.h"
#import "UMComCommentListDataController.h"
#import "UMComFeedClickActionDelegate.h"
#import "UMComSimpleFeedDetailViewController.h"
#import "UMComSimplicityUserCenterViewController.h"
#import "UMComSession.h"
#import "UMComUnReadNoticeModel.h"
#import "UMComWebViewController.h"

@interface UMComSimpleCommentViewController ()
<UMComFeedClickActionDelegate>

@property (nonatomic, strong) UIButton *sentCommentButton;
@property (nonatomic, strong) UIButton *receivedCommentButton;
@property (nonatomic, strong) CALayer *lineLayer;

@property (nonatomic, strong) UMComSimpleSubCommentViewController *sentCommentVC;
@property (nonatomic, strong) UMComSimpleSubCommentViewController *receivedCommentVC;

@end

@implementation UMComSimpleCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setForumUITitle:UMComLocalizedString(@"um_com_my_comment", @"评论")];
    
    [self initButton];
    
    [self initController];
    
    [self constraintControllerView:_sentCommentVC.view];
    [self constraintControllerView:_receivedCommentVC.view];
    
    [self switchToReceivedComment];
    self.view.backgroundColor = UMComColorWithColorValueString(@"#e8eaee");
    
    [UMComSession sharedInstance].unReadNoticeModel.notiByCommentCount = 0;
}

- (void)initButton
{
    self.sentCommentButton = [self getButtonWithName:UMComLocalizedString(@"um_com_sent_comment", @"发出的评论") selector:@selector(switchToSentComment)];
    CGSize viewSize = self.view.frame.size;
    _sentCommentButton.frame = CGRectMake(viewSize.width / 2.f, 0.f, viewSize.width / 2.f, 44.f);
    
    self.receivedCommentButton = [self getButtonWithName:UMComLocalizedString(@"um_com_received_comment", @"收到的评论") selector:@selector(switchToReceivedComment)];
    _receivedCommentButton.frame = CGRectMake(0.f, 0.f, viewSize.width / 2.f, 44.f);
    
    CALayer *bottomLineLayer = [[CALayer alloc] init];
    bottomLineLayer.backgroundColor = UMComColorWithColorValueString(@"#dfdfdf").CGColor;
    bottomLineLayer.frame = CGRectMake(0.f, _sentCommentButton.frame.size.height - 1.f, viewSize.width, 1.f);
    
    self.lineLayer = [[CALayer alloc] init];
    _lineLayer.frame = CGRectMake(0.f, _sentCommentButton.frame.size.height - 2.f, viewSize.width / 2.f, 2.f);
    _lineLayer.backgroundColor = UMComColorWithColorValueString(@"469ef8").CGColor;
    
    [self.view addSubview:_sentCommentButton];
    [self.view addSubview:_receivedCommentButton];
    
    [self.view.layer addSublayer:bottomLineLayer];
    
    [self.view.layer addSublayer:_lineLayer];
}

- (void)initController
{
    self.sentCommentVC = [[UMComSimpleSubCommentViewController alloc] init];
   UMComUserSentCommentListDataController*  sentCommentDataContrller = [[UMComUserSentCommentListDataController alloc] initWithCount:UMCom_Limit_Page_Count];
    sentCommentDataContrller.pageRequestType = UMComRequestType_UserSendComment;
    _sentCommentVC.dataController = sentCommentDataContrller;
    _sentCommentVC.delegate = self;
    [self addChildViewController:_sentCommentVC];
    [self.view addSubview:_sentCommentVC.view];

    self.receivedCommentVC = [[UMComSimpleSubCommentViewController alloc] init];
    UMComUserReceivedCommentListDataController* receivedCommentListDataController = [[UMComUserReceivedCommentListDataController alloc] initWithCount:UMCom_Limit_Page_Count];
    receivedCommentListDataController.pageRequestType = UMComRequestType_UserReceiveComment;
    _receivedCommentVC.dataController = receivedCommentListDataController;
    _receivedCommentVC.delegate = self;
    [self addChildViewController:_receivedCommentVC];
    [self.view addSubview:_receivedCommentVC.view];
}

- (void)constraintControllerView:(UIView *)view
{
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSDictionary *dict1 = NSDictionaryOfVariableBindings(view, _sentCommentButton);
    NSDictionary *metrics = @{@"hPadding":@0,@"vPadding":@0,@"buttonPadding":@0};
    NSString *vfl = @"|-hPadding-[view]-hPadding-|";
    NSString *vfl0 = @"V:|-vPadding-[_sentCommentButton]-buttonPadding-[view]-vPadding-|";
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl options:0 metrics:metrics views:dict1]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl0 options:0 metrics:metrics views:dict1]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIButton *)getButtonWithName:(NSString *)name selector:(SEL)sel
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:name forState:UIControlStateNormal];
    [button setTitleColor:UMComColorWithColorValueString(@"999999") forState:UIControlStateNormal];
    [button setTitleColor:UMComColorWithColorValueString(@"469ef8") forState:UIControlStateSelected];
    [button setTitleColor:UMComColorWithColorValueString(@"469ef8") forState:UIControlStateHighlighted];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button.titleLabel setFont:UMComFontNotoSansLightWithSafeSize(14.f)];
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)switchToSentComment
{
    _sentCommentButton.selected = YES;
    _receivedCommentButton.selected = NO;
    CGRect frame = _lineLayer.frame;
    frame.origin.x = _sentCommentButton.frame.origin.x;
    _lineLayer.frame = frame;
    
    _sentCommentVC.view.hidden = NO;
    _receivedCommentVC.view.hidden = YES;
}

- (void)switchToReceivedComment
{
    _sentCommentButton.selected = NO;
    _receivedCommentButton.selected = YES;
    CGRect frame = _lineLayer.frame;
    frame.origin.x = _receivedCommentButton.frame.origin.x;
    _lineLayer.frame = frame;
    
    _sentCommentVC.view.hidden = YES;
    _receivedCommentVC.view.hidden = NO;
}



#pragma mark - actionDeleagte
- (void)customObj:(id)obj clickOnFeedText:(UMComFeed *)feed
{
    UMComSimpleFeedDetailViewController *detailVc = [[UMComSimpleFeedDetailViewController alloc] init];
    detailVc.feed = feed;
    [self.navigationController pushViewController:detailVc animated:YES];
}

- (void)customObj:(id)obj clickOnFeedCreator:(UMComUser *)user;
{
    UMComSimplicityUserCenterViewController *userCenterVc = [[UMComSimplicityUserCenterViewController alloc] init];
    userCenterVc.user = user;
    [self.navigationController pushViewController:userCenterVc animated:YES];
}

- (void)customObj:(id)obj clickOnURL:(NSString *)urlSring
{
    UMComWebViewController *webVC = [[UMComWebViewController alloc] initWithUrl:urlSring];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)customObj:(id)obj clickOnImageView:(UIImageView *)imageView complitionBlock:(void (^)(UIViewController *currentViewController))block
{
    if (block) {
        block(self);
    }
}


@end
