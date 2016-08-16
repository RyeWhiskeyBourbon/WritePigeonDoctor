//
//  RWSettingsViewController.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/7/25.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWSettingsViewController.h"
#import "UMComSimplicityDiscoverViewController.h"
#import "UMComLoginManager.h"
#import "UMComSession.h"
#import "UMComUnReadNoticeModel.h"
#import "UMComNotificationMacro.h"
#import "UITabBar+badge.h"
#import "XZSettingWebViewController.h"
#import "FeedBackViewController.h"
#import "UMComSimpleProfileSettingController.h"
#import "RWDataBaseManager.h"
#import "RWMainTabBarController.h"
#import "FollowingTableViewController.h"
#import "RWNameCardController.h"

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

@property (nonatomic,strong)RWUser *faceUser;

@end

static NSString *const  setListCell = @"viewListCell";

@implementation RWSettingsViewController

@synthesize dataSource;

#pragma --- life cycle

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([RWChatManager defaultManager].connectionState)
    {
        RWMainTabBarController *tabBar = (RWMainTabBarController *)self.tabBarController;
        
        [tabBar toRootViewController];
        [self.tabBarController toLoginViewController];
        
        return;
    }
    
    RWUser *user = [[RWDataBaseManager defaultManager] getDefualtUser];
    
    if (user.header) {
        [_loginBtn setImage:[UIImage imageWithData:user.header]
                   forState:UIControlStateNormal];
    }else
    {
        [_loginBtn setImage:[UIImage imageNamed:@"user_image"] forState:UIControlStateNormal];
    }
    _nameLab.text = user.name?user.name:user.username;
    self.navigationController.navigationBarHidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNoticeItemViews:) name:kUMComUnreadNotificationRefreshNotification object:nil];
    
    if ([UMComSession sharedInstance].unReadNoticeModel.totalNotiCount > 0) {
        
        self.userMessageView.hidden = NO;
        [self.tabBarController.tabBar setBadgeStyle:0 value:0 atIndex:3];
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
    _loginBtn.frame = CGRectMake(SCREEN_WIDTH/2-40, 80, 80, 80);
    _loginBtn.backgroundColor = [UIColor whiteColor];
    _loginBtn.layer.masksToBounds = YES;
    _loginBtn.layer.cornerRadius = 40;
    
    _loginBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentCenter;
    
    _nameLab = [[UILabel alloc]initWithFrame:CGRectMake(0, _loginBtn.bottom+10, SCREEN_WIDTH, 30)];
    _nameLab.textAlignment = NSTextAlignmentCenter;
    _nameLab.textColor = Wonderful_WhiteColor1;
    
    [self.scrollView addSubview:_loginBtn];
    [self.scrollView addSubview:_nameLab];
    [self.tableView addSubview:self.scrollView];
}

- (void)initSetDatas
{
    NSArray *arr1 = @[@{@"title"     :@"我的名片",
                        @"icon" : @""},
                       @{@"title"     :@"个人设置",
                       @"icon" : @""},
                       @{@"title"     :@"社区管理",
                       @"icon" : @""},
                       @{@"title"     :@"我的关注",
                        @"icon" : @""}];
    NSArray *arr2 = @[@{@"title"     :@"帮助",
                        @"icon" : @""},
                      @{@"title"     :@"白鸽客服",
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
        _tableView.backgroundColor = Wonderful_GrayColor1;
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
        
        cell.textLabel.text = dataSource[0][row][@"title"];
        
        if (row == 2) {
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
        switch (row) {
            case 0:
            {
                RWNameCardController * NV = [[RWNameCardController alloc]init];
                [self pushNextWithViewcontroller:NV];
            }
                break;
            case 1:
            {
                UMComSimpleProfileSettingController *SE = [[UMComSimpleProfileSettingController alloc] init];
                [self pushNextWithViewcontroller:SE];

            }
                break;
            case 2:
            {
                UMComSimplicityDiscoverViewController * UM = [[UMComSimplicityDiscoverViewController alloc] init];
                [self pushNextWithViewcontroller:UM];
            }
                break;
            case 3:
            {
                FollowingTableViewController * FV = [[FollowingTableViewController alloc]init];
                [self pushNextWithViewcontroller:FV];
            }
                break;
            default:
                break;
            }
        }
    else if (section == 1)
    {
        switch (row) {
            case 0:
            {
                XZSettingWebViewController * WB = [[XZSettingWebViewController alloc]init];
                WB.url = @"http://www.zhongyuedu.com/tgm/test/test20/";
                WB.title = @"帮助";
                [self pushNextWithViewcontroller:WB];
            }
                break;
            case 1:
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"白鸽提示" message:@"你确定拨打:4008-355-366?" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                   
                }];
                
                UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                  
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4008-355-366"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                }];
                [alertController addAction:cancelAction];
                [alertController addAction:sureAction];
                [self presentViewController:alertController animated:YES completion:nil];

            }
                break;
            case 2:
            {
                if([RWChatManager defaultManager].connectionState)
                {
                    [self.tabBarController toLoginViewController];
                    
                    return;
                }

                FeedBackViewController * FB = [[FeedBackViewController alloc]init];
                FB.title = @"意见建议";
                [self pushNextWithViewcontroller:FB];
            
            }
                break;
            case 3:
            {
                XZSettingWebViewController * WB = [[XZSettingWebViewController alloc]init];
                WB.url = @"http://www.zhongyuedu.com/tgm/test/test19/";
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
