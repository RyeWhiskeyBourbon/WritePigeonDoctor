//
//  RWOrderListController.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/8/23.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWOrderListController.h"
#import "RWOrderController.h"
#import "RWOrderListCell.h"

@interface RWOrderListController ()

<
    UITableViewDelegate,
    UITableViewDataSource,
    RWRequsetDelegate
>

@property (nonatomic,strong)UITableView *orderList;

@property (nonatomic,strong)NSArray *orderResource;

@property (nonatomic,strong)RWRequsetManager *requestManager;
@property (nonatomic,strong)RWUser *user;

@end

@implementation RWOrderListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _requestManager = [[RWRequsetManager alloc] init];
    _requestManager.delegate = self;
    
    _user = [[RWDataBaseManager defaultManager] getDefualtUser];

    [self initNavigationBar];
    
    _orderList = [[UITableView alloc] initWithFrame:self.view.bounds
                                              style:UITableViewStylePlain];
    [self.view addSubview:_orderList];
    
    [_orderList mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    
    _orderList.delegate = self;
    _orderList.dataSource = self;
    
    [_orderList registerClass:[RWOrderListCell class]
       forCellReuseIdentifier:NSStringFromClass([RWOrderListCell class])];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!_segmentControl.superview)
    {
        [self.navigationController.navigationBar addSubview:_segmentControl];
    }
    
    [_requestManager searchOrderWithUserName:_user.username];
}

- (void)searchResultOrders:(NSArray *)orders responseMessage:(NSString *)responseMessage
{
    if (orders)
    {
        _orderResource = orders;
        [_orderList reloadData];
        
        return;
    }
    
    [RWSettingsManager promptToViewController:self
                                        Title:responseMessage
                                     response:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _orderResource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RWOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RWOrderListCell class]) forIndexPath:indexPath];
    
    cell.order = _orderResource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RWOrderController *orderController = [[RWOrderController alloc] init];
    orderController.order = _orderResource[indexPath.row];
    
    [_segmentControl removeFromSuperview];
    [self pushNextWithViewcontroller:orderController];
}

- (void)initNavigationBar
{
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *faceOrder = [[UIBarButtonItem alloc] initWithTitle:@"当前订单"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:
                                                            @selector(toFaceOrder)];
    
    self.navigationItem.rightBarButtonItem = faceOrder;
}

- (void)toFaceOrder
{
    [MBProgressHUD Message:@"未找到正在服务中的订单" For:self.view];
}

@end
