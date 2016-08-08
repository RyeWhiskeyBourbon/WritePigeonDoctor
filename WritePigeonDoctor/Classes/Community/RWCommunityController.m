//
//  RWCommunityController.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/7/25.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWCommunityController.h"
#import "UMComSimpleFeedTableViewController.h"
#import "UMComFeedListDataController.h"

@interface RWCommunityController ()

@property(nonatomic,strong)UMComSimpleFeedTableViewController *realTimeFeedVc;
@property(nonatomic,strong)UMComSimpleFeedTableViewController *hotFeedVc;

//- (void)refreshNoticeItemViews:(NSNotification*)notification;

@end

@implementation RWCommunityController

- (id)init
{
    if (self = [super init]) {
        [UMComResourceManager setResourceType:UMComResourceType_Simplicity];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"白鸽医生";
    
    [UMComResourceManager setResourceType:UMComResourceType_Simplicity];
    [[UMComDataRequestManager defaultManager] updateTemplateChoice:2 completion:nil];
    [self creatSubViewControllers];
}

#if 1

//实时feed

- (void)creatSubViewControllers
{
    
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
    [self addChildViewController:realTimeFeedVc];
    self.realTimeFeedVc = realTimeFeedVc;
    
}

#elif 0

//热门feed

- (void)creatSubViewControllers
{
    
    UMComSimpleFeedTableViewController *hotFeedVc = [[UMComSimpleFeedTableViewController alloc] init];
    hotFeedVc.isShowEditButton = YES;
    hotFeedVc.isAutoStartLoadData = NO;
    hotFeedVc.dataController = [[UMComFeedListOfRealTimeHotController alloc] initWithCount:UMCom_Limit_Page_Count];
    hotFeedVc.dataController.isReadLoacalData = YES;
    hotFeedVc.dataController.isSaveLoacalData = YES;
    [self.view addSubview:hotFeedVc.view];
    [self addChildViewController:hotFeedVc];
    self.hotFeedVc = hotFeedVc;
    
}

#endif

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.realTimeFeedVc.view.frame = self.view.bounds;
    self.hotFeedVc.view.frame = self.view.bounds;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //token更新之后要更新首页的数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:kUMComGetTokenSucceedNotification object:nil];
    
    __DEFAULT_NAVIGATION_BAR__;
    __NAVIGATION_DEUAULT_SETTINGS__;

}

- (void)refreshData
{
    [self.realTimeFeedVc refreshData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end