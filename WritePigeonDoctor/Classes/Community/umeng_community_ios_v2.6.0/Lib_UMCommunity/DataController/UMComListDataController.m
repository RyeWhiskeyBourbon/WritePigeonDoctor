//
//  UMComDataController.m
//  UMCommunity
//
//  Created by umeng on 16/4/29.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComListDataController.h"
#import "UMComMacroConfig.h"

@implementation UMComListDataController
@synthesize haveNextPage = _haveNextPage;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataArray = [NSMutableArray array];
        self.count = UMCom_Limit_Page_Count;
    }
    return self;
}
- (instancetype)initWithCount:(NSInteger)count
{
    self = [self init];
    if (self) {
        if (count > 0) {
            self.count = count;
        }else{
            self.count = UMCom_Limit_Page_Count;
        }
    }
    return self;
}

- (instancetype)initWithRequestType:(UMComPageRequestType)requestType count:(NSInteger)count
{
    self = [self init];
    if (self) {
        self.pageRequestType = requestType;
        self.count = count;
    }
    return self;
}

- (void)setHaveNextPage:(BOOL)haveNextPage
{
    _haveNextPage = haveNextPage;
}

- (BOOL)haveNextPage
{
    _haveNextPage = ([self.nextPageUrl isKindOfClass:[NSString class]] &&self.nextPageUrl.length > 0);
    return _haveNextPage;
}


/**
 *先读取本地数据再读网络数据
 */
- (void)fecthDataWithCompletion:(UMComDataListRequestCompletion)localFecthcompletion            serverDataCompletion:(UMComDataListRequestCompletion)serverRequestCompletion
{

}


-(void)fecthLocalDataWithCompletion:(UMComDataListRequestCompletion)localFecthcompletion
{
    if (localFecthcompletion) {
        localFecthcompletion(nil,nil);
    }
}

-(void)saveLocalDataWithDataArray:(NSArray*)dataArray
{
}

/**
 *请求第一页数据
 */
- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{

}

/**
 *请求下一页数据
 */
- (void)loadNextPageDataWithCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] fecthNextPageWithNextPageUrl:self.nextPageUrl pageRequestType:self.pageRequestType completion:^(NSDictionary *responseObject, NSError *error) {
        [weakSelf handleNextPageData:responseObject error:error completion:completion];
    }];
}

- (void)handleNewData:(NSDictionary *)data error:(NSError *)error completion:(UMComDataRequestCompletion)completion
{
    if (![data isKindOfClass:[NSDictionary class]]) {
        if (completion) {
            completion(nil, error);
        }
        return;
    }
    if (!self.dataArray) {
        self.dataArray = [NSMutableArray array];
    }else{
        [self.dataArray removeAllObjects];
    }
    
    
    NSArray *feedList = [data valueForKey:UMComModelDataKey];
    if ([feedList isKindOfClass:[NSArray class]] && feedList.count >0) {
        [self.dataArray addObjectsFromArray:feedList];
    }
    self.nextPageUrl = [data valueForKey:UMComModelDataNextPageUrlKey];
    self.canVisitNextPage = [[data valueForKey:UMComModelDataVisitKey] boolValue];
    if (completion) {
        completion([data valueForKey:UMComModelDataKey], error);
    }
}

- (void)handleNextPageData:(NSDictionary *)data error:(NSError *)error completion:(UMComDataListRequestCompletion)completion
{
    if (![data isKindOfClass:[NSDictionary class]]) {
        if (completion) {
            completion(nil, error);
        }
        return;
    }
    NSArray *feedList = [data valueForKey:UMComModelDataKey];
    if ([feedList isKindOfClass:[NSArray class]] && feedList.count >0) {
        [self.dataArray addObjectsFromArray:feedList];
    }
    self.nextPageUrl = [data valueForKey:UMComModelDataNextPageUrlKey];
    self.canVisitNextPage = [[data valueForKey:UMComModelDataVisitKey] boolValue];
    if (completion) {
        completion([data valueForKey:UMComModelDataKey], error);
    }
}

@end
