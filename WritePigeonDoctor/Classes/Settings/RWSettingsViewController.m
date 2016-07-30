//
//  RWSettingsViewController.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/7/25.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWSettingsViewController.h"
#import "XZComSettingViewComtroller.h"
#import "UMComSimplicityDiscoverViewController.h"

@interface RWSettingsViewController ()
<
   UITableViewDelegate,
   UITableViewDataSource
>

@property (nonatomic,strong) UITableView * tableView;

@end

@implementation RWSettingsViewController

#pragma --- life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"个人中心";
    
    [self.view addSubview:self.tableView];
    
}

#pragma --- Lazy loading

- (UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]init];
        _tableView.frame = self.view.bounds;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
  
    }
    return _tableView;
}

#pragma --- TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"cell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = @"我的社区";
    
    return cell;
}

#pragma --- TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UMComSimplicityDiscoverViewController * VC = [[UMComSimplicityDiscoverViewController alloc] init];
    [self pushNextWithViewcontroller:VC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
