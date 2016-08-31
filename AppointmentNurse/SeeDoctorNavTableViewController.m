//
//  SeeDoctorNavTableViewController.m
//  WritePigeonDoctor
//
//  Created by ZYJY on 16/8/18.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "SeeDoctorNavTableViewController.h"
#import "SeeDoctorNavTableViewCell.h"
#import "PuborderViewController.h"
#import <MJRefresh.h>

@interface SeeDoctorNavTableViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource,
    RWRequsetDelegate
>

@property (nonatomic,strong)UITableView *doctorNavTableView;

@property (nonatomic,strong)NSArray *resource;

@property (nonatomic,strong)RWRequsetManager *requestManager;

@end

@implementation SeeDoctorNavTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"就医导航";
    _requestManager = [[RWRequsetManager alloc] init];
    _requestManager.delegate = self;
    
    [self initView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!_resource)
    {
        [_requestManager obtainServicesList];
    }
}

- (void)requsetServicesList:(NSArray *)servicesList responseMessage:(NSString *)responseMessage
{
    [_doctorNavTableView.mj_header endRefreshing];
    [_doctorNavTableView.mj_footer endRefreshing];
    
    if (servicesList)
    {
        _resource = servicesList;
        
        if (self.view.window)
        {
            [_doctorNavTableView reloadData];
        }
    }
    else
    {
        [RWSettingsManager promptToViewController:self
                                            Title:responseMessage
                                         response:nil];
    }
}

- (void)initView
{
    _doctorNavTableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                               style:UITableViewStylePlain];
    [self.view addSubview:_doctorNavTableView];
    
    [_doctorNavTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    
    _doctorNavTableView.showsVerticalScrollIndicator = NO;
    _doctorNavTableView.showsHorizontalScrollIndicator = NO;
    
    _doctorNavTableView.delegate = self;
    _doctorNavTableView.dataSource = self;
    
    [_doctorNavTableView registerClass:[SeeDoctorNavTableViewCell class]
        forCellReuseIdentifier:NSStringFromClass([SeeDoctorNavTableViewCell class])];
    
    
    _doctorNavTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                             refreshingAction:@selector(refreshHeaderAction:)];
    _doctorNavTableView.mj_header.tintColor=[UIColor blueColor];
    
    _doctorNavTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self
                                                                 refreshingAction:@selector(refreshFooterAction:)];
    _doctorNavTableView.mj_footer.hidden = YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _resource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SeeDoctorNavTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SeeDoctorNavTableViewCell class]) forIndexPath:indexPath];
    
    RWService *service = _resource[indexPath.row];
    
    [cell.docNavImg setImageWithURL:[NSURL URLWithString:service.serviceImage]
                        placeholder:nil];

    cell.doctorWayLabel.text = service.serviceName;
    cell.wayDesLabel.text = service.serviceDescription;
    
    NSString *money = service.money;
    [cell.moneyLabel setColorFontText:[NSString stringWithFormat:@"<[%@]>  元",money]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PuborderViewController * nur = [[PuborderViewController alloc]init];
    
    nur.orderService = _resource[indexPath.row];
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:nur animated:YES];
}

#pragma --- Action

-(void)refreshHeaderAction:(MJRefreshHeader *) header
{
    [_requestManager obtainServicesList];
}

-(void)refreshFooterAction:(MJRefreshFooter *) footer
{
    [_requestManager obtainServicesList];
}

@end
