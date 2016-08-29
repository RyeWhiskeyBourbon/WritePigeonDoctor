//
//  RWRecordBaseController.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/8/18.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWRecordBaseController.h"

@interface RWRecordBaseController ()

@end

@implementation RWRecordBaseController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _RecordList = [[UITableView alloc] initWithFrame:self.view.bounds
                                               style:UITableViewStylePlain];
    [self.view addSubview:_RecordList];
    
    [_RecordList mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    
    _RecordList.delegate = self;
    _RecordList.dataSource = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _RecordResource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
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

@end
