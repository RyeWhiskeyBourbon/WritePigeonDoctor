//
//  UMComSimplicityRequestTableViewController.h
//  UMCommunity
//
//  Created by umeng on 15/11/16.
//  Copyright © 2015年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "UMComListDataController.h"
#import "UMComDataBaseManager.h"
#import "UMComStatusView.h"

@protocol UMComScrollViewDelegate;

@class UMComStatusView;


@interface UMComSimplicityRequestTableViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>


/**
 *继承与UMComRequestTableViewController的TableViewController都带有一个dataController，负责处理为TableViewController处理数据和业务逻辑，并未tableView提供显示的model
 */
@property (nonatomic, strong) UMComListDataController *dataController;

/**
 * tableView
 */
@property (nonatomic, strong) UITableView *tableView;

/**
 *下拉刷新控件
 */
@property (nonatomic, strong) UIRefreshControl *refreshControl;

///**
// *列表数据
// */
//@property (nonatomic, strong) NSArray *dataArray;

/**
 *显示数据为空或网络问题label
 */
@property (nonatomic, strong) UILabel *noDataTipLabel;

/**
 *tableView上次滚动的位置
 */
@property (nonatomic, assign, readonly) CGPoint lastPosition;

/**
 *是否自动加载数据
 */
@property (nonatomic, assign) BOOL isAutoStartLoadData;

/**
 *网络数据是否加载完成
 */
@property (nonatomic, assign) BOOL isLoadFinish;

/**
 *是否显示数据为空的提示
 */
@property (nonatomic, assign) BOOL doNotShowNodataNote;

/**
 *上拉加载更多控件
 */
@property (nonatomic, strong) UMComStatusView *loadMoreStatusView;

/**
 *tableView滚动delegate
 */
@property (nonatomic, weak) id<UMComScrollViewDelegate> scrollViewDelegate;



#pragma mark - data
- (void)refreshData;
/**
 *刷新数据
 */
- (void)refreshDataCompletion:(void (^)())completion;

/**
 *加载更多数据
 */
- (void)loadMoreDataCompletion:(void (^)())completion;



@end

