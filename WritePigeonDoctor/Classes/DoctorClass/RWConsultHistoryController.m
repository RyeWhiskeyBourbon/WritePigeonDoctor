//
//  RWConsultHistoryController.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/8/9.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWConsultHistoryController.h"
#import "RWDoctorListCell.h"
#import "RWDoctorDescriptionController.h"
#import "RWDataBaseManager+ChatCache.h"
#import "RWMainTabBarController.h"
#import "RWConsultNotesController.h"
#import "RWMainTabBarController.h"
#import "RWOrderListController.h"

@interface RWConsultHistoryController ()

<
    UITableViewDelegate,
    UITableViewDataSource
>

@property (nonatomic,strong)UITableView *historyList;
@property (nonatomic,strong)NSArray *historys;
@property (nonatomic,strong)UISegmentedControl *segment;

@property (nonatomic,strong)RWDataBaseManager *baseManager;

@end

@implementation RWConsultHistoryController

- (void)initViews
{
    _historyList = [[UITableView alloc] initWithFrame:self.view.bounds
                                                style:UITableViewStylePlain];
    [self.view addSubview:_historyList];
    
    _historyList.showsVerticalScrollIndicator = NO;
    _historyList.showsHorizontalScrollIndicator = NO;
    
    _historyList.delegate = self;
    _historyList.dataSource = self;
    
    [_historyList registerClass:[RWDoctorListCell class]
         forCellReuseIdentifier:NSStringFromClass([RWDoctorListCell class])];
    
    _segment = [[UISegmentedControl alloc] initWithItems:@[@"咨询历史",@"订单列表"]];
    
    _segment.tintColor = [UIColor whiteColor];
    _segment.selectedSegmentIndex = 0;
    
    [_segment addTarget:self
                action:@selector(segmentSelected:)
      forControlEvents:UIControlEventValueChanged];
    
    [self.navigationController.navigationBar addSubview:_segment];
    
    CGRect frame = self.navigationController.navigationBar.bounds;
    CGPoint center = CGPointMake(frame.size.width / 2 , frame.size.height / 2);
    
    frame.size.width -= 180;
    frame.size.height -= 15;
    
    _segment.frame = frame;
    _segment.center = center;
}

- (void)segmentSelected:(UISegmentedControl *)segment
{
    if (segment.selectedSegmentIndex)
    {
        RWOrderListController *orderList = [[RWOrderListController alloc] init];
        orderList.segmentControl = _segment;
        
        [self.navigationController pushViewController:orderList animated:YES];
    }
    else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _historys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RWDoctorListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RWDoctorListCell class]) forIndexPath:indexPath];
    
    cell.history = _historys[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RWConsultNotesController *notesController = [[RWConsultNotesController alloc] init];
    
    notesController.history = _historys[indexPath.row];
    
    RWMainTabBarController *tabBar = (RWMainTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    [tabBar updateUnreadNumber];
    
    [_segment removeFromSuperview];
    [self pushNextWithViewcontroller:notesController];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_baseManager removeCacheMessageWith:_historys[indexPath.row]])
    {
        if ([_baseManager removeConsultHistory:_historys[indexPath.row]])
        {
            _historys = [_baseManager getConsultHistory];
            
            [_historyList reloadData];
        }
        else
        {
            MESSAGE(@"删除历史咨询失败");
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _baseManager = [RWDataBaseManager defaultManager];
    
    [self initNavigationBar];
    [self initViews];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!_segment.superview)
    {
        [self.navigationController.navigationBar addSubview:_segment];
    }
    
    if ([RWChatManager defaultManager].connectionState)
    {
        [self.tabBarController toLoginViewController];
        
        RWMainTabBarController *tabBar = (RWMainTabBarController *)self.tabBarController;
        
        [tabBar toRootViewController];
        
        return;
    }
    
    _historys = [_baseManager getConsultHistory];
    
    [_historyList reloadData];
}

- (void)initNavigationBar
{
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *faceConsult = [[UIBarButtonItem alloc] initWithTitle:@"当前咨询"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:
                                                            @selector(toFaceConsult)];
    faceConsult.width = 40;
    self.navigationItem.rightBarButtonItem = faceConsult;
}

- (void)toFaceConsult
{
    [MBProgressHUD Message:@"未找到正在咨询的订单" For:self.view];
}

@end
