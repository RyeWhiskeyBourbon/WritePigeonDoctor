//
//  RWSettingsViewController.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/7/25.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWSettingsViewController.h"
#import "UMComSimplicityDiscoverViewController.h"
#import "UMComSession.h"
#import "UMComUnReadNoticeModel.h"
#import "UMComNotificationMacro.h"
#import "UITabBar+badge.h"
#import "XZSettingWebViewController.h"
#import "FeedBackViewController.h"
@interface RWSettingsViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
UIScrollViewDelegate
>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIView *userMessageView;//通知的小红点
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UILabel * nameLab;
@property (nonatomic,strong) NSArray *dataSource;

@end

static NSString *const  setListCell = @"viewListCell";

@implementation RWSettingsViewController

@synthesize dataSource;

#pragma --- life cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNoticeItemViews:) name:kUMComUnreadNotificationRefreshNotification object:nil];
    
    if ([UMComSession sharedInstance].unReadNoticeModel.totalNotiCount > 0) {
        
        self.userMessageView.hidden = NO;
        [self.tabBarController.tabBar setBadgeStyle:1 value:12 atIndex:3];
    }
    else
    {
        self.userMessageView.hidden = YES;
        [self.tabBarController.tabBar setBadgeStyle:2 value:0 atIndex:3];
    }

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self initView];
    [self initSetDatas];
}

-(void)initView
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -50, SCREEN_WIDTH, 50)];
    self.scrollView.backgroundColor = __WPD_MAIN_COLOR__;
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    

    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.frame = CGRectMake(SCREEN_WIDTH/2-45, 80, 80, 80);
    _loginBtn.layer.masksToBounds = YES;
    _loginBtn.layer.cornerRadius = 40;
    [_loginBtn setImage:[UIImage imageNamed:@"45195.jpg"] forState:UIControlStateNormal];
    _loginBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentCenter;
    [ _loginBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    _nameLab = [[UILabel alloc]initWithFrame:CGRectMake(0, _loginBtn.bottom+10, SCREEN_WIDTH, 30)];
    _nameLab.textAlignment = NSTextAlignmentCenter;
    _nameLab.text = @"未登录";
    _nameLab.textColor = Wonderful_WhiteColor1;
    
    [self.scrollView addSubview:_loginBtn];
    [self.scrollView addSubview:_nameLab];
    [self.tableView addSubview:self.scrollView];
}

- (void)initSetDatas
{
    NSArray *arr1 = @[@{@"title"     :@"健康档案",
                       @"icon" : @""},
                      @{@"title"     :@"我的社区",
                       @"icon" : @""}];
    NSArray *arr2 = @[@{@"title"     :@"邀请好友",
                        @"icon" : @""},
                      @{@"title"     :@"帮助",
                        @"icon" : @""},
                      @{@"title"     :@"意见建议",
                        @"icon" : @""},
                      @{@"title"     :@"白鸽声明",
                        @"icon" : @""}];
    dataSource = @[arr1,arr2];
}

#pragma --- Lazy loading

- (UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-44) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = Wonderful_GrayColor2;
        _tableView.backgroundView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    return _tableView;
}

#pragma --- TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return ((NSArray *)dataSource[0]).count;
    }
     return ((NSArray *)dataSource[1]).count;;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 170;
    } else
    {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    static NSString *cellIdentifier = @"userCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    if (section == 0) {
        if (row == 1) {
            CGFloat padding = 2;
            CGFloat defaultNoticeViewOriginX = 115;
            CGSize nameSize = [cell.textLabel.text sizeWithFont:cell.textLabel.font];
            CGFloat noticeViewOriginX = cell.textLabel.frame.origin.x + nameSize.width + padding;
            if (noticeViewOriginX >= cell.contentView.bounds.size.width) {
                noticeViewOriginX = cell.contentView.bounds.size.width - padding;
            }
            else if (noticeViewOriginX <= 0)
            {
                noticeViewOriginX = defaultNoticeViewOriginX;
            }
            self.userMessageView = [self creatNoticeViewWithOriginX:noticeViewOriginX];
            self.userMessageView.center = CGPointMake(self.userMessageView.center.x+11, cell.textLabel.frame.origin.y+11);
            [cell.contentView addSubview:self.userMessageView];
        }
        cell.textLabel.text = dataSource[0][row][@"title"];
    }else
    {
        cell.textLabel.text = dataSource[1][row][@"title"];
    }
   
    return cell;
}

#pragma --- TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        if (row == 1) {
        UMComSimplicityDiscoverViewController * VC = [[UMComSimplicityDiscoverViewController alloc] init];
        [self pushNextWithViewcontroller:VC];
       }
     }
    else if (section == 1)
    {
        switch (row) {
            case 0:
            {
                
            }
                break;
            case 1:
            {
                XZSettingWebViewController * WB = [[XZSettingWebViewController alloc]init];
                WB.url = @"http://www.zhongyuedu.com/api/tk_aboutUs.htm";
                WB.title = @"帮助";
                [self pushNextWithViewcontroller:WB];
  
            }
                break;
            case 2:
            {
            
            
            }
                break;
            case 3:
            {
                XZSettingWebViewController * WB = [[XZSettingWebViewController alloc]init];
                WB.url = @"http://www.zhongyuedu.com/api/tk_aboutUs.htm";
                WB.title = @"白鸽声明";
                [self pushNextWithViewcontroller:WB];
            }
                break;
   
            default:
                break;
        }
    }
}

- (UIView *)creatNoticeViewWithOriginX:(CGFloat)originX
{
    CGFloat noticeViewWidth = 7;
    UIView *itemNoticeView = [[UIView alloc]initWithFrame:CGRectMake(originX,0, noticeViewWidth, noticeViewWidth)];
    itemNoticeView.backgroundColor = [UIColor redColor];
    itemNoticeView.layer.cornerRadius = noticeViewWidth/2;
    itemNoticeView.clipsToBounds = YES;
    if ([UMComSession sharedInstance].unReadNoticeModel.totalNotiCount > 0) {
        itemNoticeView.hidden = NO;
    }
    else
    {
        itemNoticeView.hidden = YES;
    }
    return itemNoticeView;
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView)
    {
        CGFloat offsetY = self.tableView.contentOffset.y;
        if (offsetY <= 0 && offsetY >= -100)
        {
            self.scrollView.frame = CGRectMake(0, -50 + offsetY / 2, SCREEN_WIDTH, 220 - offsetY / 2);
        }
        else if (offsetY < -100)
        {
            [self.tableView setContentOffset:CGPointMake(0, -100)];
        }
    }
}

#pragma --- Action

- (void)loginBtnAction
{
    NSLog(@"登录");
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
