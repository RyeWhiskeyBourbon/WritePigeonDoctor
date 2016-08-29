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
    UITableViewDataSource
>

@property (nonatomic,strong)UITableView *doctorNavTableView;

@property (nonatomic,strong)NSArray *resource;

@end

@implementation SeeDoctorNavTableViewController

- (void)makeResource
{
    _resource = @[[RWService serviceWithServiceImage:[UIImage imageNamed:@"孕妇陪诊"]
                                         serviceName:@"孕妇陪诊"
                                            maxMoney:@"699"
                                            minMoney:@"399"
                                           serviceId:RWServiceTypeAccompanyTreat
                                  serviceDescription:@"孕妇陪诊描述"],
                  [RWService serviceWithServiceImage:[UIImage imageNamed:@"取化验单"]
                                         serviceName:@"取化验单"
                                            maxMoney:@"80"
                                            minMoney:nil
                                           serviceId:RWServiceTypeGetTestReport
                                  serviceDescription:@"取化验单描述"],
                  [RWService serviceWithServiceImage:[UIImage imageNamed:@"打针输液"]
                                         serviceName:@"打针输液"
                                            maxMoney:@"699"
                                            minMoney:@"399"
                                           serviceId:RWServiceTypeAccompanyTreat
                                  serviceDescription:@"打针输液描述"]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"就医导航";
    [self makeResource];
    [self initView];
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
    
    cell.docNavImg.image = service.serviceImage;
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
    [_doctorNavTableView.mj_header endRefreshing];
}

-(void)refreshFooterAction:(MJRefreshFooter *) footer
{
    [_doctorNavTableView.mj_footer endRefreshing];
}

@end
