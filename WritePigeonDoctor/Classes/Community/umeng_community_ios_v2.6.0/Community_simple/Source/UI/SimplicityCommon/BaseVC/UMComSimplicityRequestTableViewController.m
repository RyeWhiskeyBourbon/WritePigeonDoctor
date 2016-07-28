
//
//  UMComSimplicityRequestTableViewController.m
//  UMCommunity
//
//  Created by umeng on 15/11/16.
//  Copyright © 2015年 Umeng. All rights reserved.
//

#import "UMComSimplicityRequestTableViewController.h"
#import "UMComScrollViewDelegate.h"
#import "UIViewController+UMComAddition.h"
#import "UMComSession.h"
#import "UMComShowToast.h"



typedef NS_ENUM(NSInteger, UMComVisitType){
    UMComVisitType_None                         = -1,        //< 初始化状态
    UMComVisitType_VisitNeedLoginForMoreData    = 0,         //< 需要登录才能访问更多数据
    UMComVisitType_VisitNeedLoginForNoMoreData  = 1,         //< 需要登录访问，但是没有下一页数据
    
    UMComVisitType_Visit                        = 2,          //< 可以访问（目前没有用到,UMComVisitType_VisitForMoreData和UMComVisitType_VisitForNoMoreData都可以表示可以访问）
    UMComVisitType_VisitForMoreData             = 3,        //< 可以访问下一页数据
    UMComVisitType_VisitForNoMoreData           = 4         //< 可以访问没有下一页数据
};

@interface UMComSimplicityRequestTableViewController ()<UITableViewDelegate, UITableViewDataSource, UMComScrollViewDelegate>

@property (nonatomic, assign) CGPoint lastPosition;

//检查是否访客模式
-(BOOL) checkGuestMode;
@property(nonatomic,assign)UMComVisitType visitMoreDataMode;

-(void) doRefreshData;
- (void) fetchLocalData;
-(void) refreshDataFromServer;

@end

@implementation UMComSimplicityRequestTableViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initData];
    }
    return self;
}

 - (void)initData
{
    self.isLoadFinish = YES;
    self.isAutoStartLoadData = YES;
    
    self.visitMoreDataMode = UMComVisitType_None;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshData];
    self.isLoadFinish = YES;
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    self.refreshControl = [[UIRefreshControl alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];

    [self.refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:UMComLocalizedString(@"um_com_pull_refresh", @"下拉可以刷新")]];
    
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    
    self.loadMoreStatusView = [[UMComStatusView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [self.tableView.tableFooterView addSubview:self.loadMoreStatusView];
    self.tableView.separatorColor = UMComColorWithColorValueString(UMCom_Feed_BgColor);
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    self.scrollViewDelegate = self;
    
    [self setForumUIBackButtonWithImage:UMComSimpleImageWithImageName(@"um_forum_back_gray")];
    [self setForumUITitle:self.title];
    
    [self updateTableviewConstraints];
}


- (void)updateTableviewConstraints
{
    UITableView *tableView = self.tableView;
    
    [tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSDictionary *dict1 = NSDictionaryOfVariableBindings(tableView);
    NSDictionary *metrics = @{@"hPadding":@0,@"topPadding":@0,@"vPadding":@0};
    NSString *vfl = @"|-hPadding-[tableView]-hPadding-|";
    NSString *vfl0 = @"V:|-topPadding-[tableView]-vPadding-|";
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl options:0 metrics:metrics views:dict1]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl0 options:0 metrics:metrics views:dict1]];
}

- (void)creatNoFeedTip
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/2-40, self.view.frame.size.width,40)];
    label.backgroundColor = [UIColor clearColor];
    label.text = UMComLocalizedString(@"um_com_emptyData", @"暂时没有内容哦!");
    label.font = UMComFontNotoSansLightWithSafeSize(17);
    label.textColor = [UMComTools colorWithHexString:FontColorGray];
    label.textAlignment = NSTextAlignmentCenter;
    label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    label.hidden = YES;
    [self.view addSubview:label];
    self.noDataTipLabel = label;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.noDataTipLabel && self.doNotShowNodataNote == NO) {
        [self creatNoFeedTip];
    }
    // 未登录时发送请求可能会不断收到未登录错误码而不断弹出登录
    // 修改为第一次加载后开始手动下拉刷新加载
    self.isAutoStartLoadData = NO;
    
    
    //首先判断非访客模式===begin
    if (self.visitMoreDataMode == UMComVisitType_None) {
        //第一次进入的时候初始化为UMComVisitType_None的时候，表示未知状态，不需要判断其是否为访客模式，需要等到第一次网络请求到了，包含的访客模式(即为visitMoreDataMode赋非UMComVisitType_None的值)
        return;
    }
    
    //如果当前是访客模式即登录了，但是visitMoreDataMode为非访客模式，就需要修改其提示加载更多
    if ([self checkGuestMode]) {
        if (self.visitMoreDataMode == UMComVisitType_VisitNeedLoginForMoreData)
        {
            //非访客模式直接显示加载更多
            [self.loadMoreStatusView setLoadStatus:UMComNoLoad];
        }
        else if (self.visitMoreDataMode == UMComVisitType_VisitNeedLoginForNoMoreData)
        {
            //非访客模式直接显示加载完成
            [self.loadMoreStatusView setLoadStatus:UMComFinish];
        }
        else if (self.visitMoreDataMode == UMComVisitType_VisitForMoreData)
        {
            [self.loadMoreStatusView setLoadStatus:UMComNoLoad];
        }
        else if (self.visitMoreDataMode == UMComVisitType_VisitForNoMoreData)
        {
            [self.loadMoreStatusView setLoadStatus:UMComFinish];
        }
        else{}
    }
    //首先判断非访客模式===end
    
}


////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataController.dataArray.count > 0)//有数据
    {
        self.noDataTipLabel.hidden = YES;
        if (self.dataController.nextPageUrl && [self.dataController.nextPageUrl isKindOfClass:[NSString class]])//有下一页数据
        {
            self.loadMoreStatusView.hidden = NO;
            
            //有下一页就显示上来加载更多
            [self.loadMoreStatusView setLoadStatus:UMComNoLoad];
            
            //最后判断是否为可访问下一页，如果不能访问就显示登陆后访问更多数据
            if (!self.dataController.canVisitNextPage)
            {
                [self.loadMoreStatusView setLoadStatus:UMComNeedLoginMode];
            }
        }
        else//没有下一页数据
        {
            self.loadMoreStatusView.hidden = NO;
            //没有下一页就显示最后一页
            [self.loadMoreStatusView setLoadStatus:UMComFinish];
        }
    }
    else//数据为空
    {
        self.loadMoreStatusView.hidden = YES;
        self.noDataTipLabel.hidden = NO;
    }
    return self.dataController.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    return cell;
}

#pragma mark -

- (BOOL)isBeginScrollBottom:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y>0 && scrollView.contentSize.height >scrollView.frame.size.height && (scrollView.contentSize.height-scrollView.contentOffset.y<scrollView.bounds.size.height)) {
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)isScrollToBottom:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y>0 && (scrollView.contentSize.height-scrollView.contentOffset.y<scrollView.bounds.size.height-65)) {
        return YES;
    }else{
        return NO;
    }
}

- (void)refreshScrollViewDidEndDragging:(UIScrollView *)refreshScrollView
{
    //首先判断非访客模式===begin
//    if (![self checkGuestMode]) {
//        return;
//    }
    //首先判断非访客模式===end
    
//    BOOL haveNextPage = self.haveNextPage;
    BOOL haveNextPage = self.dataController.haveNextPage;
    self.loadMoreStatusView.haveNextPage = haveNextPage;
    //上拉加载
    if ([self isScrollToBottom:refreshScrollView] && self.loadMoreStatusView.loadStatus != UMComLoading &&  self.refreshControl.refreshing != YES && haveNextPage == YES) {
        self.loadMoreStatusView.hidden = NO;
        //执行代理方法
        [self.loadMoreStatusView setLoadStatus:UMComLoading];
        [self loadMoreData];
        
    }
    else if (haveNextPage == NO && refreshScrollView.contentSize.height > refreshScrollView.frame.size.height && self.loadMoreStatusView.loadStatus != UMComLoading){
        [self.loadMoreStatusView setLoadStatus:UMComFinish];
    }else if (haveNextPage == NO){
        [self.loadMoreStatusView setLoadStatus:UMComFinish];
    }
}

- (void)refreshScrollViewDidScroll:(UIScrollView *)refreshScrollView
{
    //BOOL haveNextPage = self.haveNextPage;
    BOOL haveNextPage = self.dataController.haveNextPage;
    if (refreshScrollView.contentOffset.y < -150 && !self.refreshControl.refreshing) {
        [self.refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:UMComLocalizedString(@"um_com_fingerUp_refresh", @"松手即可刷新")]];
    }else if (refreshScrollView.contentOffset.y < 0){
        if (self.isLoadFinish) {
            [self.refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:UMComLocalizedString(@"um_com_pull_refresh", @"下拉可以刷新")]];
        }else{
            [self.refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:UMComLocalizedString(@"um_com_refreshing", @"正在刷新")]];
        }
    }
    
    //首先判断非访客模式===begin
    if (refreshScrollView.contentOffset.y <= 0){
        [self.loadMoreStatusView hidenVews];
        return;
    }
    
    //非访客模式，并且请求了第一次的网络数据
    if(![self checkGuestMode] && self.visitMoreDataMode != UMComVisitType_None)
    {
        [self.loadMoreStatusView setLoadStatus:UMComNeedLoginMode];
        return;
    }
    else{}
     //首先判断非访客模式===end
    
    self.loadMoreStatusView.haveNextPage = haveNextPage;
    self.loadMoreStatusView.canReadNextPage = [self checkGuestMode];
    
    //上拉
    if ([self isBeginScrollBottom:refreshScrollView] && [refreshScrollView isDragging] && self.loadMoreStatusView.loadStatus != UMComLoading && self.refreshControl.refreshing != YES && haveNextPage == YES) {//
        [self.loadMoreStatusView setLoadStatus:UMComNoLoad];
        if ([self isScrollToBottom:refreshScrollView]){
            [self.loadMoreStatusView setLoadStatus:UMComPreLoad];
        }
    }
    //上拉减速的时候，会出现弹出超过指定距离的而显示UMComPreLoad的文字，这时候需要判断减速的时候，一致保持初始状态UMComNoLoad
    else if ([self isBeginScrollBottom:refreshScrollView] && [refreshScrollView isDecelerating] && (/*self.loadMoreStatusView.loadStatus == UMComNoLoad || */self.loadMoreStatusView.loadStatus == UMComPreLoad )&& self.refreshControl.refreshing != YES && haveNextPage == YES)
    {
        [self.loadMoreStatusView setLoadStatus:UMComNoLoad];
    }
    else if (self.loadMoreStatusView.loadStatus != UMComLoading && self.loadMoreStatusView.loadStatus != UMComFinish){
        if (haveNextPage == YES) {
            if ([self isScrollToBottom:refreshScrollView]){
                [self.loadMoreStatusView setLoadStatus:UMComPreLoad];
                self.loadMoreStatusView.indicateImageView.transform = CGAffineTransformIdentity;
            }
        }else{
            [self.loadMoreStatusView setLoadStatus:UMComFinish];
        }
    }else if (refreshScrollView.contentOffset.y <= 0){
        [self.loadMoreStatusView hidenVews];
    }else if (haveNextPage == NO){
        [self.loadMoreStatusView setLoadStatus:UMComFinish];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self refreshScrollViewDidScroll:scrollView];
    if (self.isLoadFinish && self.scrollViewDelegate && [self.scrollViewDelegate respondsToSelector:@selector(customScrollViewDidScroll:lastPosition:)]) {
        [self.scrollViewDelegate customScrollViewDidScroll:scrollView lastPosition:self.lastPosition];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    self.lastPosition = scrollView.contentOffset;
    if (self.scrollViewDelegate && [self.scrollViewDelegate respondsToSelector:@selector(customScrollViewDidEnd:lastPosition:)]) {
        [self.scrollViewDelegate customScrollViewDidEnd:scrollView lastPosition:self.lastPosition];
    }
    self.lastPosition = scrollView.contentOffset;
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self refreshScrollViewDidEndDragging:scrollView];
    if (self.scrollViewDelegate && [self.scrollViewDelegate respondsToSelector:@selector(customScrollViewEndDrag:lastPosition:)]) {
        [self.scrollViewDelegate customScrollViewEndDrag:scrollView lastPosition:self.lastPosition];
    }
    self.lastPosition = scrollView.contentOffset;
}


#pragma mark - UMComRefreshTableViewDelegate

- (void)refreshDataCompletion:(void (^)())completion
{

}

- (void)loadMoreDataCompletion:(void (^)())completion
{
    __weak typeof(self) weakSelf = self;
    [self.dataController loadNextPageDataWithCompletion:^(NSArray *responseData, NSError *error) {
        if (responseData) {
            [weakSelf.tableView reloadData];
        }
        if (completion) {
            completion();
        }
    }];
}

-(void) doRefreshData
{
    if (self.dataController.isReadLoacalData) {
        //设置NO只会第一次下拉刷新取本地数据
        self.dataController.isReadLoacalData = NO;
        //取本地数据的话，就不需要显示loadMoreStatusView的views
        [self.loadMoreStatusView hidenVews];
        [self fetchLocalData];
    }
    else{
        [self refreshDataFromServer];
    }
}

- (void) fetchLocalData
{
    __weak typeof(self) weakSelf = self;
    [self.dataController fecthLocalDataWithCompletion:^(NSArray *dataArray, NSError *error) {
        
        if (dataArray && [dataArray isKindOfClass:[NSArray class]] && dataArray.count > 0) {
            weakSelf.dataController.dataArray = [NSMutableArray arrayWithArray:dataArray];
            [weakSelf.tableView reloadData];
        }
        
        [weakSelf refreshDataFromServer];
    }];

}

-(void) refreshDataFromServer
{
    if (self.isLoadFinish == NO) {
        return;
    }
    self.isLoadFinish = NO;
    [self.refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:UMComLocalizedString(@"um_com_refreshing", @"正在刷新")]];
    [self.refreshControl beginRefreshing];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    __weak typeof(self) weakSelf = self;
    [self refreshDataCompletion:^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [weakSelf.refreshControl endRefreshing];
        weakSelf.isLoadFinish = YES;
        [weakSelf.tableView reloadData];
    }];
}

- (void)refreshData
{
    [self doRefreshData];
    return;
    
  }

- (void)loadMoreData
{
    if (self.isLoadFinish == NO) {
        return;
    }
    self.isLoadFinish = NO;
    __weak typeof(self) weakSelf = self;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self loadMoreDataCompletion:^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        weakSelf.isLoadFinish = YES;
        [weakSelf.loadMoreStatusView setLoadStatus:UMComFinish];
        [weakSelf.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/**
 *  登陆用户和访客模式都会返回true，因其拥有一样的权限
 *
 *  @return true 代表访客权限 false 代表非访客权限
 */
-(BOOL) checkGuestMode
{
    //登陆用户
    if ([UMComSession sharedInstance].isLogin) {
        return YES;
    }
    
    //访客模式
    return NO;
}

@end

