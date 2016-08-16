//
//  RWDoctorListController.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/7/25.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWDoctorListController.h"
#import "RWDoctorListCell.h"
#import "RWDoctorDescriptionController.h"
#import "RWRequsetManager.h"
#import <MJRefresh.h>

@interface RWDoctorListController ()

<
    UITableViewDelegate,
    UITableViewDataSource,
    RWRequsetDelegate
>

@property (nonatomic,strong)UITableView *doctorList;
@property (nonatomic,strong)RWRequsetManager *requestManager;
@property (nonatomic,assign)NSInteger page;

@end

@implementation RWDoctorListController

- (void)initViews
{
    _doctorList = [[UITableView alloc] initWithFrame:self.view.bounds
                                               style:UITableViewStylePlain];
    [self.view addSubview:_doctorList];
    
    [_doctorList mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    
    _doctorList.showsVerticalScrollIndicator = NO;
    _doctorList.showsHorizontalScrollIndicator = NO;
    
    _doctorList.delegate = self;
    _doctorList.dataSource = self;
    
    [_doctorList registerClass:[RWDoctorListCell class]
        forCellReuseIdentifier:NSStringFromClass([RWDoctorListCell class])];
    
    
    _doctorList.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                            refreshingAction:@selector(refreshHeaderAction:)];
    _doctorList.mj_header.tintColor=[UIColor blueColor];
    
    _doctorList.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self
                                                               refreshingAction:@selector(refreshFooterAction:)];
}


-(void)refreshHeaderAction:(MJRefreshHeader *) header
{
    _page = 1;
    
    [_requestManager obtainOfficeDoctorListWithURL:_doctorListUrl page:_page];
}

-(void)refreshFooterAction:(MJRefreshFooter *) footer
{
    [_requestManager obtainOfficeDoctorListWithURL:_doctorListUrl page:_page];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _doctorResource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RWDoctorListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RWDoctorListCell class]) forIndexPath:indexPath];
    
    cell.doctor = _doctorResource[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RWDoctorDescriptionController *doctor = [RWDoctorDescriptionController doctorDescroptionWith:_doctorResource[indexPath.row]];
    
    [self pushNextWithViewcontroller:doctor];
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"医生列表";
    _page = 1;
    
    [self initViews];

    _requestManager = [[RWRequsetManager alloc] init];
    _requestManager.delegate = self;
    
    [_requestManager obtainOfficeDoctorListWithURL:_doctorListUrl page:_page];
}

- (void)requsetOfficeDoctorList:(NSArray *)officeDoctorList responseMessage:(NSString *)responseMessage
{
    [_doctorList.mj_header endRefreshing];
    [_doctorList.mj_footer endRefreshing];
    
    if (officeDoctorList)
    {
        if (_page == 1)
        {
            _doctorResource = officeDoctorList;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [_doctorList reloadData];
            });
        }
        else
        {
            NSMutableArray *resource = [_doctorResource mutableCopy];
            
            for (int i = 0; i < officeDoctorList.count; i++)
            {
                [resource addObject:officeDoctorList[i]];
            }
            
            _doctorResource = [resource copy];
        }
        
        _page++;
        
        [_doctorList reloadData];
    }
    else
    {
        [MBProgressHUD Message:responseMessage For:self.view];
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_doctorList reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
