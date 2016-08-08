//
//  UMComSimpleNoticeTableViewController.m
//  UMCommunity
//
//  Created by umeng on 16/5/17.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComSimpleNoticeTableViewController.h"
#import "UMComSimpleNotificationCell.h"
#import "UMComNoticeListDataController.h"
#import "UMComNotification.h"
#import "UIViewController+UMComAddition.h"
#import "UMComUser.h"
#import "UMComSession.h"
#import "UMComUnReadNoticeModel.h"

static NSString *kUMComSimpleNotificationCellID = @"UMComSimpleNotificationCell";

@interface UMComSimpleNoticeTableViewController ()

@property (nonatomic, strong) NSMutableDictionary *cellHeightDict;

@property (nonatomic, strong) UMComSimpleNotificationCell *baseCell;

@end



@implementation UMComSimpleNoticeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setForumUITitle:UMComLocalizedString(@"um_com_notification", @"通知")];

    UINib *cellNib = [UINib nibWithNibName:kUMComSimpleNotificationCellName bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:kUMComSimpleNotificationCellID];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 203;

    
    self.cellHeightDict = [NSMutableDictionary dictionary];
    
    self.dataController = [[UMComNoticeListDataController alloc] initWithCount:UMCom_Limit_Page_Count];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = UMComColorWithColorValueString(@"#e8eaee");
    
    [self refreshData];

    [UMComSession sharedInstance].unReadNoticeModel.notiByAdministratorCount = 0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [super tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UMComSimpleNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:kUMComSimpleNotificationCellID];
    
    UMComNotification* notice = self.dataController.dataArray[indexPath.row];
    [cell reloadCellWithNotification:notice];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UMComNotification* notice = self.dataController.dataArray[indexPath.row];
    NSString *heightKey = notice.id;
    CGFloat height = 0;
    if ([self.cellHeightDict valueForKey:heightKey]) {
        height = [[self.cellHeightDict valueForKey:heightKey] floatValue];
    }else{
        if (!_baseCell) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:kUMComSimpleNotificationCellName owner:self options:nil];
            self.baseCell = [array objectAtIndex:0];
            _baseCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(_baseCell.bounds));
        }
        [_baseCell setNeedsLayout];
        [_baseCell layoutIfNeeded];
        [_baseCell reloadCellWithNotification:notice];
         height = [_baseCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        height += 1;
        [self.cellHeightDict setValue:@(height) forKey:heightKey];
    }
    return height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshDataCompletion:(void (^)())completion
{
    [self.dataController refreshNewDataCompletion:^(NSArray *responseData, NSError *error) {
        if (completion) {
            completion();
        }
        
    }];
}



@end
