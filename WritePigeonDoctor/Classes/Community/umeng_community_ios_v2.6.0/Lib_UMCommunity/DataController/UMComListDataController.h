//
//  UMComDataController.h
//  UMCommunity
//
//  Created by umeng on 16/4/29.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMComDataRequestManager.h"

#define UMCom_Limit_Page_Count 20 //分页请求默认数据

/**
 *请求分页数据代理方法
 */
//@protocol UMComDataPageRequestDelegate <NSObject>

//
//@optional
//
///**
// *先读取本地数据再读网络数据
// */
//- (void)fecthDataWithCompletion:(UMComDataListRequestCompletion)localFecthcompletion            serverDataCompletion:(UMComDataListRequestCompletion)serverRequestCompletion;
//
///**
// *读取本地数据
// */
//- (void)fecthLocalDataWithCompletion:(UMComDataListRequestCompletion)completion;
//
///**
// *请求第一页数据
// */
//- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion;
//
///**
// *请求下一页数据
// */
//- (void)loadNextPageDataWithCompletion:(UMComDataListRequestCompletion)completion;
//
//
//@end


@interface UMComListDataController : NSObject

/**
 * 下一页请求的url(在请求任一页数据时会返回下一页请求的url，每个接口通过对应的下一页请求url请求下一页数据)
 */
@property (nonatomic, copy) NSString *nextPageUrl;

/**
 *是否能查看下一页
 */
@property (nonatomic, assign) BOOL canVisitNextPage;

/**
 *是否有下一页
 */
@property (nonatomic, assign) BOOL haveNextPage;

/**
 *每次请求的个数(在请求第一页的时候有效，之后请求下一页的个数都以请求第一页的个数为准)
 */
@property (nonatomic, assign) NSInteger count;

/**
 *数据列表（比如请求的是Feed列表， 那么dataArray中的元素就是UMComFeed类对象，以此类推）
 */
@property (nonatomic, strong) NSMutableArray *dataArray;

/**
 * 下一页请求接口类型
 */
@property (nonatomic, assign) UMComPageRequestType pageRequestType;

/**
 * 是否读本地数据 默认为NO,设置YES后，界面第一次进入会读入本地的数据，然后下拉刷新就直接读入网络的数据
 */
@property (nonatomic, assign) BOOL isReadLoacalData;

/**
 *  是否保存本地数据，默认为NO,设置为YES后，每次下来就会保存下拉刷新的第一页的数据，用作缓存
 */
@property (nonatomic, assign) BOOL isSaveLoacalData;

/**
 *  ListData下feed下置顶的个数，用于在插入新feed的时候来判断插入到置顶feed下面而在普通feed前面
 */
@property (nonatomic, assign) NSInteger topItemsCount;


- (instancetype)initWithCount:(NSInteger)count;


- (instancetype)initWithRequestType:(UMComPageRequestType)requestType count:(NSInteger)count;

///**
// *先读取本地数据再读网络数据
//*/
//- (void)fecthDataWithCompletion:(UMComDataListRequestCompletion)localFecthcompletion            serverDataCompletion:(UMComDataListRequestCompletion)serverRequestCompletion;


/**
 *  读取本地数据
 *
 *  @param localFecthcompletion 本地数据回调
 */
-(void)fecthLocalDataWithCompletion:(UMComDataListRequestCompletion)localFecthcompletion;

/**
 *  存储本地数据
 *
 */
-(void)saveLocalDataWithDataArray:(NSArray*)dataArray;

/**
 *请求第一页数据
 */
- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion;

/**
 *请求下一页数据
 */
- (void)loadNextPageDataWithCompletion:(UMComDataListRequestCompletion)completion;


/**
 *  获得处理后的数据
 *
 *  @param data       根据不同的请求类型来判断当前的字典的key
 *  @param error      @see NSError
 *  @param completion 回调方法
 */
- (void)handleNewData:(NSDictionary *)data error:(NSError *)error completion:(UMComDataRequestCompletion)completion;

@end
