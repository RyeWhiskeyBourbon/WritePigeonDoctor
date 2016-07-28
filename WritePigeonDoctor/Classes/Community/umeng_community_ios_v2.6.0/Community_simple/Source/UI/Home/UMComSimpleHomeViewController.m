//
//  UMComSimpleHomeViewController.m
//  UMCommunity
//
//  Created by umeng on 16/4/29.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComSimpleHomeViewController.h"
#import "UMComSimpleFeedTableViewController.h"
#import "UMComFeedListDataController.h"
#import "UIViewController+UMComAddition.h"
#import "UMComSimplicityDiscoverViewController.h"

#import "UMComBriefEditViewController.h"
#import "UMComSelectTopicViewController.h"
#import "UMComLoginManager.h"

#import "UMComSession.h"
#import "UMComUnReadNoticeModel.h"


@interface UMComSimpleHomeViewController ()

@property(nonatomic,strong)UMComSimpleFeedTableViewController *realTimeFeedVc;
@property(nonatomic,strong)UMComSimpleFeedTableViewController *hotFeedVc;

- (void)refreshNoticeItemViews:(NSNotification*)notification;
@end

@implementation UMComSimpleHomeViewController

- (id)init
{
    if (self = [super init]) {
        [UMComResourceManager setResourceType:UMComResourceType_Simplicity];
    }
    return self;
}

- (void)refreshNoticeItemViews:(NSNotification*)notification
{
    if ([UMComSession sharedInstance].unReadNoticeModel.totalNotiCount > 0) {
        self.userMessageView.hidden = NO;
    }
    else
    {
        self.userMessageView.hidden = YES;
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //token更新之后要更新首页的数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:kUMComGetTokenSucceedNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUMComGetTokenSucceedNotification object:nil];
}

- (void)refreshData
{
    UMComSimpleFeedTableViewController *vc = self.childViewControllers[self.showIndex];
    [vc refreshData];
}

- (void)didTransitionToIndex:(NSInteger)index
{
    UMComSimpleFeedTableViewController *vc = self.childViewControllers[index];
    if (vc.dataController && vc.dataController.dataArray.count == 0) {
        [vc refreshData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [UMComResourceManager setResourceType:UMComResourceType_Simplicity];
    [[UMComDataRequestManager defaultManager] updateTemplateChoice:2 completion:nil];

    [self createSubViews];
    
    [self creatSubViewControllers];
    
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    //    如果当前NavigationViewController是跟视图， 则不需要显示返回按钮
    if ((rootViewController == self.navigationController && rootViewController.childViewControllers.count == 1) || rootViewController == self) {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.leftBarButtonItems = nil;
    }else{
        [self setForumUIBackButton];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNoticeItemViews:) name:kUMComUnreadNotificationRefreshNotification object:nil];
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUMComUnreadNotificationRefreshNotification object:nil];
}

- (void)createSubViews
{

}

- (void)creatSubViewControllers
{
    //最新Feed流页面
    UMComSimpleFeedTableViewController *realTimeFeedVc = [[UMComLatestSimpleFeedTableViewController alloc] init];
    realTimeFeedVc.isShowEditButton = YES;
    realTimeFeedVc.isAutoStartLoadData = NO;
    realTimeFeedVc.dataController = [[UMComFeedListOfRealTimeController alloc] initWithCount:UMCom_Limit_Page_Count];
    UMComFeedListDataController* topFeedListDataController= (UMComFeedListDataController*)realTimeFeedVc.dataController;
    topFeedListDataController.isReadLoacalData = YES;
    topFeedListDataController.isSaveLoacalData = YES;
    topFeedListDataController.topFeedListDataController = [[UMComGlobalTopFeedListDataController alloc] init];
    realTimeFeedVc.topFeedType = UMComTopFeedType_GloalTopFeed;
    [self.view addSubview:realTimeFeedVc.view];
    self.realTimeFeedVc = realTimeFeedVc;

    //最热feed流页面
    UMComSimpleFeedTableViewController *hotFeedVc = [[UMComSimpleFeedTableViewController alloc] init];
    hotFeedVc.isShowEditButton = YES;
    hotFeedVc.isAutoStartLoadData = NO;
    hotFeedVc.dataController = [[UMComFeedListOfRealTimeHotController alloc] initWithCount:UMCom_Limit_Page_Count];
    hotFeedVc.dataController.isReadLoacalData = YES;
    hotFeedVc.dataController.isSaveLoacalData = YES;
    [self.view addSubview:hotFeedVc.view];
    self.hotFeedVc = hotFeedVc;

    self.titlesArray = [NSArray arrayWithObjects:UMComLocalizedString(@"umcom_newest_feed", @"最新"), UMComLocalizedString(@"umcom_hotest_feed", @"最热"), nil];
    self.subViewControllers = [NSArray arrayWithObjects:realTimeFeedVc,hotFeedVc, nil];
    self.showIndex = 0;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //设置两个child的frame
    self.realTimeFeedVc.view.frame = self.view.bounds;
    self.hotFeedVc.view.frame = self.view.bounds;
    
}


- (void)onTouchDiscover
{
    UMComSimplicityDiscoverViewController * VC = [[UMComSimplicityDiscoverViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
