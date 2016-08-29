//
//  RWRecordBaseController.h
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/8/18.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWWPDBaseController.h"

@interface RWRecordBaseController : RWWPDBaseController

<
    UITableViewDelegate,
    UITableViewDataSource
>

@property (nonatomic,strong)UITableView *RecordList;

@property (nonatomic,strong)NSArray *RecordResource;

@end
