//
//  UMComBeLikedFeedViewController.m
//  UMCommunity
//
//  Created by wyq.Cloudayc on 5/19/16.
//  Copyright © 2016 Umeng. All rights reserved.
//

#import "UMComSimpleLikeMyFeedViewController.h"
#import "UMComTools.h"
#import "UIViewController+UMComAddition.h"
#import "UMComSimpleFeedDetailViewController.h"
#import "UMComSimpleAssociatedFeedTableViewCell.h"
#import "UMComFeedClickActionDelegate.h"
#import "UMComUserListDataController.h"
#import "UMComSimplicityUserCenterViewController.h"
#import "UMComLike.h"
#import "UMComSession.h"
#import "UMComUnReadNoticeModel.h"


@interface UMComSimpleLikeMyFeedViewController ()<UITableViewDataSource, UITableViewDelegate, UMComFeedClickActionDelegate>

@property (nonatomic, strong) NSMutableDictionary *cellCacheDict;

@property (nonatomic, strong) UMComSimpleAssociatedFeedTableViewCell *baseCell;

@end

@implementation UMComSimpleLikeMyFeedViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataController = [[UMComUseReceivedLikeDataController alloc] initWithCount:UMCom_Limit_Page_Count];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setForumUITitle:UMComLocalizedString(@"um_com_be_liked_feed", @"赞我的")];
    
    UINib *cellNib = [UINib nibWithNibName:kUMComSimpleAssociatedFeedTableViewCellName bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:kUMComSimpleAssociatedFeedTableViewCellId];
    
    _baseCell = [cellNib instantiateWithOwner:nil options:nil][0];
    
    self.cellCacheDict = [NSMutableDictionary dictionary];
    self.isLoadFinish = YES;
    [self refreshData];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = UMComColorWithColorValueString(@"e8eaee");
    
    [UMComSession sharedInstance].unReadNoticeModel.notiByLikeCount = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UMComLike *like = self.dataController.dataArray[indexPath.row];
    
    UMComSimpleAssociatedFeedTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kUMComSimpleAssociatedFeedTableViewCellId];
    
    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(_baseCell.bounds));
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    cell.delegate = self;
    [cell refreshWithBeLiked:like];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *heightKey = [NSString stringWithFormat:@"height_%d",(int)indexPath.row];
    
    CGFloat height = 0;
    if (![self.cellCacheDict valueForKey:heightKey] ) {
        UMComSimpleAssociatedFeedTableViewCell *cell = self.baseCell;
        
        UMComLike *like = self.dataController.dataArray[indexPath.row];
        
        cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(_baseCell.bounds));
        
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
        
        [cell refreshWithBeLiked:like];
        
        CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        height += 1;
        [self.cellCacheDict setValue:@(height) forKey:heightKey];
    }else{
        height = [[self.cellCacheDict valueForKey:heightKey] floatValue];
    }
    return height;
}

#pragma mark - data request

- (void)refreshDataCompletion:(void (^)())completion
{
    __weak typeof(self) weakSelf = self;
    [self.dataController refreshNewDataCompletion:^(NSArray *responseData, NSError *error) {
        if (responseData) {
            [weakSelf.tableView reloadData];
        }
        if (completion) {
            completion();
        }
    }];
}

- (void)loadMoreDataCompletion:(void (^)())completion
{
    __weak typeof(self) weakSelf = self;
    [self.dataController loadNextPageDataWithCompletion:^(NSArray *responseData, NSError *error) {
        if (responseData) {
            [weakSelf.tableView reloadData];
        }
        if (completion) {
            completion();
        }
    }];
}


#pragma mark - actionDeleagte
- (void)customObj:(id)obj clickOnFeedText:(UMComFeed *)feed
{
    UMComSimpleFeedDetailViewController *detailVc = [[UMComSimpleFeedDetailViewController alloc] init];
    detailVc.feed = feed;
    [self.navigationController pushViewController:detailVc animated:YES];
}

- (void)customObj:(id)obj clickOnFeedCreator:(UMComUser *)user;
{
    UMComSimplicityUserCenterViewController *userCenterVc = [[UMComSimplicityUserCenterViewController alloc] init];
    userCenterVc.user = user;
    [self.navigationController pushViewController:userCenterVc animated:YES];
}

- (void)customObj:(id)obj clickOnImageView:(UIImageView *)imageView complitionBlock:(void (^)(UIViewController *currentViewController))block
{
    if (block) {
        block(self);
    }
}

@end
