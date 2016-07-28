//
//  UMComFeedListDataController.m
//  UMCommunity
//
//  Created by umeng on 16/5/3.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComFeedListDataController.h"
#import "UMComSession.h"
#import "UMComFeed.h"
#import "UMComMacroConfig.h"
#import "UMComDataBasePublicHeader.h"
#import "UMComErrorCode.h"

@interface UMComFeedListDataController ()
@end

@implementation UMComFeedListDataController


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.count = UMCom_Limit_Page_Count;
    }
    return self;
}


- (void)deleteFeed:(UMComFeed *)feed completion:(UMComDataRequestCompletion)completion
{
    [[UMComDataRequestManager defaultManager] feedDeleteWithFeedID:feed.feedID completion:^(NSDictionary *responseObject, NSError *error) {
        if (completion) {
            completion(responseObject,error);
        }
    }];
}

- (void)likeFeed:(UMComFeed *)feed completion:(UMComDataRequestCompletion)completion
{
   [[UMComDataRequestManager defaultManager] feedLikeWithFeedID:feed.feedID isLike:![feed.liked boolValue] completion:^(NSDictionary *responseObject, NSError *error) {
        if (error.code == ERR_CODE_LIKE_HAS_BEEN_CANCELED) {
            if ([feed.liked boolValue]) {
                    feed.liked = @(NO);
                    feed.likes_count = @(feed.likes_count.integerValue -1);
            }
        }
        else if (error.code == ERR_CODE_FEED_HAS_BEEN_LIKED)
        {
            if (![feed.liked boolValue]) {
                feed.liked = @(YES);
                feed.likes_count = @(feed.likes_count.integerValue + 1);
            }
        }
        if (completion) {
            completion(responseObject,error);
        }
    }];
}

- (void)favouriteFeed:(UMComFeed *)feed completion:(UMComDataRequestCompletion)completion
{
    BOOL isFavorite = ![feed.has_collected boolValue];
    [[UMComDataRequestManager defaultManager] feedFavouriteWithFeedId:feed.feedID isFavourite:isFavorite completionBlock:^(NSDictionary *responseObject, NSError *error) {
        if (!error) {
            if (isFavorite == YES) {
               feed.has_collected = @1;
            }else{
                feed.has_collected = @0;
            }
            if (completion) {
                completion(responseObject, error);
            }
        }else{
            if (error.code == ERR_CODE_HAS_ALREADY_COLLECTED
                ) {
                feed.has_collected = @1;
            }else if (error.code == ERR_CODE_HAS_NOT_COLLECTED){
                feed.has_collected = @0;
            }
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

- (void)commentFeedWithFeedID:(NSString *)feedID
               commentContent:(NSString *)commentContent
               replyCommentID:(NSString *)replyCommentID
                  replyUserID:(NSString *)replyUserID
         commentCustomContent:(NSString *)commentCustomContent
                       images:(NSArray *)images
                   completion:(UMComRequestCompletion)completion
{
    [[UMComDataRequestManager defaultManager] commentFeedWithFeedID:feedID commentContent:commentContent replyCommentID:replyCommentID replyUserID:replyUserID commentCustomContent:commentCustomContent images:images completion:^(NSDictionary *responseObject, NSError *error) {
        
    }];
}

- (void)feedForwardWithFeedID:(NSString *)feedId
                      content:(NSString *)content
                    topic_ids:(NSArray *)topic_ids
                  relatedUids:(NSArray *)uids
                     feedType:(NSInteger)type
                 locationName:(NSString *)locationName
                     location:(CLLocation *)location
                       custom:(NSString *)customContent
                   completion:(UMComRequestCompletion)completion;
{
    [[UMComDataRequestManager defaultManager] feedForwardWithFeedID:feedId content:content topic_ids:topic_ids relatedUids:uids feedType:type locationName:locationName location:location custom:customContent completion:^(NSDictionary *responseObject, NSError *error) {
        
    }];
}
//
- (void)spamFeed:(UMComFeed *)feed completion:(UMComDataRequestCompletion)completion
{
    
}
//
- (void)shareFeed:(UMComFeed *)feed toPlatform:(NSString *)platform completion:(UMComDataRequestCompletion)completion
{
    
}




- (void)fecthDataWithCompletion:(UMComDataListRequestCompletion)localFecthcompletion            serverDataCompletion:(UMComDataListRequestCompletion)serverRequestCompletion
{
    __weak typeof(self) weakSelf = self;
    if (self.isReadLoacalData) {
        [self fecthLocalDataWithCompletion:^(NSArray *responseData, NSError *error) {
            if (localFecthcompletion) {
                localFecthcompletion(responseData, error);
            }
            [weakSelf refreshNewDataCompletion:serverRequestCompletion];
        }];
    }else{
        [self refreshNewDataCompletion:serverRequestCompletion];
        
    }

}


/**
 *  过滤普通流中的置顶数据
 *
 *  @param orginCommonFeedList 从网络取得普通流
 *
 *  @return 返回新的过滤的array(默认返回自身)
 */
-(NSArray*) filterTopItemWithCommonFeed:(NSArray*)orginCommonFeedList;
{
    return orginCommonFeedList;
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
    
    //设置置顶数据
    if (self.topFeedListDataController && self.topFeedListDataController.topDataArray &&
        self.topFeedListDataController.topDataArray.count > 0) {
        [self.dataArray addObjectsFromArray:self.topFeedListDataController.topDataArray];
        self.topItemsCount = self.topFeedListDataController.topDataArray.count;
    }
    else
    {
        self.topItemsCount = 0;
    }
    
    
    
    NSArray *feedList = [data valueForKey:UMComModelDataKey];
    
    if (self.topFeedListDataController) {
        feedList = [self filterTopItemWithCommonFeed:feedList];
    }
    
    if ([feedList isKindOfClass:[NSArray class]] && feedList.count >0) {
        [self.dataArray addObjectsFromArray:feedList];
    }
    self.nextPageUrl = [data valueForKey:UMComModelDataNextPageUrlKey];
    self.canVisitNextPage = [[data valueForKey:UMComModelDataVisitKey] boolValue];
    if (completion) {
        completion(self.dataArray, error);
    }
}

- (void)handleNextPageData:(NSDictionary *)data error:(NSError *)error completion:(UMComDataListRequestCompletion)completion
{
    if (![data isKindOfClass:[NSDictionary class]]) {
        self.nextPageUrl = nil;
        self.canVisitNextPage = NO;
        if (completion) {
            completion(nil, error);
        }
        return;
    }
    
    NSArray *feedList = [data valueForKey:UMComModelDataKey];
    
    if (self.topFeedListDataController) {
        feedList = [self filterTopItemWithCommonFeed:feedList];
    }
    
    if ([feedList isKindOfClass:[NSArray class]] && feedList.count >0) {
        [self.dataArray addObjectsFromArray:feedList];
    }
    
    self.nextPageUrl = [data valueForKey:UMComModelDataNextPageUrlKey];
    self.canVisitNextPage = [[data valueForKey:UMComModelDataVisitKey] boolValue];
    if (completion) {
        completion([data valueForKey:UMComModelDataKey], error);
    }
}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    
    __weak typeof(self) weakself = self;
    if (self.topFeedListDataController) {
        
        [self.topFeedListDataController refreshNewDataCompletion:^(NSArray *responseData, NSError *error) {
            
            [weakself doRefreshNewDataCompletion:^(NSArray *responseData, NSError *error) {

                //是否存储网络的对象
                if (weakself.isSaveLoacalData && responseData && [responseData isKindOfClass:[NSArray class]]) {
                    [weakself saveLocalDataWithDataArray:responseData];
                }
                
                if (completion) {
                    completion(responseData,error);
                }
                

                
                
            }];
        }];
    }
    else{
        [self doRefreshNewDataCompletion:^(NSArray *responseData, NSError *error) {
            
            //是否存储网络的对象
            if (weakself.isSaveLoacalData && responseData && [responseData isKindOfClass:[NSArray class]]) {
                [weakself saveLocalDataWithDataArray:responseData];
            }
            
            if (completion) {
                completion(responseData,error);
            }

        }];
    }
}


- (void)doRefreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    if (completion) {
        completion(nil,nil);
    }
}


-(void)fecthLocalDataWithCompletion:(UMComDataListRequestCompletion)localFecthcompletion
{
    [[UMComDataBaseManager shareManager] fetchASyncUMComFeedWithType:g_relatedIDTableTypeFromPageRequestType(self.pageRequestType) withCompleteBlock:^(id feedArray, NSError * error) {
        
        if (localFecthcompletion) {
            localFecthcompletion(feedArray,error);
        }
        
    }];
}

-(void)saveLocalDataWithDataArray:(NSArray*)dataArray
{
    [[UMComDataBaseManager shareManager]  saveRelatedIDTableWithType:g_relatedIDTableTypeFromPageRequestType(self.pageRequestType) withFeeds:dataArray];
}

@end

@implementation UMComFeedListOfRealTimeHotController

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_RealTimeHotFeed count:count];
    if (self) {
        
    }
    return self;
}

- (void)doRefreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] fecthRealTimeHotFeedsWithCount:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakSelf handleNewData:responseObject error:error completion:completion];
    }];
}

-(void)fecthLocalDataWithCompletion:(UMComDataListRequestCompletion)localFecthcompletion
{
    [super fecthLocalDataWithCompletion:localFecthcompletion];
}

-(void)saveLocalDataWithDataArray:(NSArray*)dataArray
{
    [super saveLocalDataWithDataArray:dataArray];
}

@end

/**
 *热门Feed流
 */
@implementation UMComFeedListOfHotController

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_CommunityHotFeed count:count];
    if (self) {
        
    }
    return self;
}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] fecthFeedsHotestWithDays:self.hotDay count:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakSelf handleNewData:responseObject error:error completion:completion];
    }];
}

@end


/**
 *实时feed流
 */
@implementation UMComFeedListOfRealTimeController

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_RealTimeFeed count:count];
    if (self) {
        
    }
    return self;
}


- (void)doRefreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
        __weak typeof(self) weakSelf = self;
        [[UMComDataRequestManager defaultManager] fecthFeedsRealTimeWithCount:self.count completion:^(NSDictionary *responseObject, NSError *error) {
            [weakSelf handleNewData:responseObject error:error completion:completion];
        }];
}


-(void)fecthLocalDataWithCompletion:(UMComDataListRequestCompletion)localFecthcompletion
{
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    [[UMComDataBaseManager shareManager] fetchASyncUMComFeedWithType:g_relatedIDTableTypeFromPageRequestType(self.pageRequestType) withCompleteBlock:^(id feedArray, NSError * error) {
        CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
        NSLog(@"time fecthLocalDataWithCompletion: %0.3f", end - start);
        if (localFecthcompletion) {
            localFecthcompletion(feedArray,error);
        }
    }];
}

-(void)saveLocalDataWithDataArray:(NSArray*)dataArray
{
    [[UMComDataBaseManager shareManager]  saveRelatedIDTableWithType:g_relatedIDTableTypeFromPageRequestType(self.pageRequestType) withFeeds:dataArray];
}


-(NSArray*) filterTopItemWithCommonFeed:(NSArray*)orginCommonFeedList
{
    
    if (orginCommonFeedList && [orginCommonFeedList isKindOfClass:[NSArray class]] && orginCommonFeedList.count > 0) {
        
        NSMutableArray* filterCommonFeedList =  [NSMutableArray arrayWithCapacity:10];
        
        [orginCommonFeedList enumerateObjectsUsingBlock:^(UMComFeed*  _Nonnull feed, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (feed && [feed isKindOfClass:[UMComFeed class]]) {
                
                if ([feed.is_top isKindOfClass:[NSNumber class]] && feed.is_top.integerValue == 1) {
                    
                }
                else{
                    [filterCommonFeedList addObject:feed];
                }
            }
            
        }];
        
        return filterCommonFeedList;
    }
    
    return [super filterTopItemWithCommonFeed:orginCommonFeedList];
}

@end


/**
 *关注feed流
 */
@implementation UMComFeedListOfFocusController

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_FocusedFeed count:count];
    if (self) {
        
    }
    return self;
}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] fecthFeedsByFollowWithCount:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakSelf handleNewData:responseObject error:error completion:completion];
    }];
}

@end

/**
 *推荐feed流
 */
@implementation UMComFeedListOfRecommendController

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_RecommendFeed count:count];
    if (self) {
        
    }
    return self;
}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] fecthFeedsRecommentWithCount:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakSelf handleNewData:responseObject error:error completion:completion];
    }];
}

@end

/**
 *时间戳feed流
 */
@implementation UMComFeedListOfTimeLineController

- (instancetype)initWithCount:(NSInteger)count userID:(NSString *)userID timeLineFeedListType:(UMComTimeLineFeedListType)timeLineFeedListType
{
    self = [super initWithRequestType:UMComRequestType_RealTimeFeed count:count];
    if (self) {
        self.userID = userID;
        self.timeLineFeedListType = timeLineFeedListType;
    }
    return self;
}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] fecthFeedsTimelineWithUid:self.userID sortType:self.timeLineFeedListType count:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakSelf handleNewData:responseObject error:error completion:completion];
    }];
}

@end

/**
 *话题下最新发布的feed流
 */
@implementation UMComFeedListOfTopicLatesController

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_TopicLatesReleaseFeed count:count];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithCount:(NSInteger)count topicId:(NSString *)topicId topicFeedSortType:(UMComTopicFeedListSortType)topicFeedSortType
{
    self = [super initWithRequestType:UMComRequestType_TopicLatesReleaseFeed count:count];
    if (self) {
        self.topicId = topicId;
        self.topicFeedSortType = topicFeedSortType;
    }
    return self;
}


- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] fecthFeedsTopicRelatedWithTopicId:self.topicId sortType:self.topicFeedSortType isReverse:self.isReverse count:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakSelf handleNewData:responseObject error:error completion:completion];
    }];
}

@end

/**
 *话题下热门feed流
 */
@implementation UMComFeedListOfTopicHotController

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_TopicHottestFeed count:count];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithCount:(NSInteger)count topicId:(NSString *)topicId hotDay:(NSInteger)hotDay
{
    self = [super initWithRequestType:UMComRequestType_TopicHottestFeed count:count];
    if (self) {
        self.topicId = topicId;
        self.hotDay = hotDay;
    }
    return self;
}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] fecthFeedsTopicHotWithDays:self.hotDay topicId:self.topicId count:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakSelf handleNewData:responseObject error:error completion:completion];
    }];
}

@end

/**
 *话题下推荐feed流
 */
@implementation UMComFeedListOfTopicRecommendController

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_TopicRecommendFeed count:count];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithCount:(NSInteger)count topicId:(NSString *)topicId
{
    self = [super initWithRequestType:UMComRequestType_TopicRecommendFeed count:count];
    if (self) {
        self.topicId = topicId;
    }
    return self;
}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] fecthFeedsTopicRecommendWithTopicId:self.topicId count:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakSelf handleNewData:responseObject error:error completion:completion];
    }];
}

@end

/**
 *被@的feed流
 */
@implementation UMComFeedListOfBeAtController

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_UserBaAtFeed count:count];
    if (self) {
        
    }
    return self;
}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] fecthFeedsUserBeAtWithCount:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakSelf handleNewData:responseObject error:error completion:completion];
    }];
}

@end

/**
 *我的好友圈的feed流
 */
@implementation UMComFeedListOfFriendsController

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_UserFriendsFeed count:count];
    if (self) {
        
    }
    return self;
}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] fecthFeedsFriendsWithCount:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakSelf handleNewData:responseObject error:error completion:completion];
    }];
}

@end

/**
 *我的收藏的feed流
 */
@implementation UMComFeedListOfFavoriteController

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_UserFavoriteFeed count:count];
    if (self) {
        
    }
    return self;
}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] fecthFeedsUserFavouriteWithCount:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakSelf handleNewData:responseObject error:error completion:completion];
    }];
}

@end

/**
 *附近的feed流
 */
@implementation UMComFeedListOfSurroundingController

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_SurroundingFeed count:count];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithCount:(NSInteger)count location:(CLLocation *)location
{
    self = [super initWithRequestType:UMComRequestType_SurroundingFeed count:count];
    if (self) {
        self.locatoion = location;
    }
    return self;
}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] fecthFeedsNearbyWithLocation:self.locatoion count:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakSelf handleNewData:responseObject error:error completion:completion];
    }];
}

@end

/**
 *搜索的feed流
 */
@implementation UMComFeedListOfSearchController

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_CoummunitySearchFeed count:count];
    if (self) {
    }
    return self;
}

- (instancetype)initWithCount:(NSInteger)count keyWord:(NSString *)keyWord
{
    self = [super initWithRequestType:UMComRequestType_CoummunitySearchFeed count:count];
    if (self) {
        self.keyWord = keyWord;
    }
    return self;
}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] fecthFeedsSearchWithKeywords:self.keyWord count:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakSelf handleNewData:responseObject error:error completion:completion];
    }];
}

@end


@implementation UMComCreateFeedDataController


+ (void)feedCreateWithContent:(NSString *)content
                        title:(NSString *)title
                     location:(CLLocation *)location
                 locationName:(NSString *)locationName
                 related_uids:(NSArray<NSString *> *)related_uids
                    topic_ids:(NSArray<NSString *> *)topic_ids
                       images:(NSArray *)images
                         type:(NSNumber *)type
                       custom:(NSString *)custom
                   completion:(UMComDataRequestCompletion)completion
{
    [UMComDataRequestManager  feedCreateWithContent:content title:title location:location locationName:locationName related_uids:related_uids topic_ids:topic_ids images:images type:type custom:custom completion:^(NSDictionary *responseObject, NSError *error) {

        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]] && !error) {
            id feed  = [responseObject valueForKey:UMComModelDataKey];
            if (feed && [feed isKindOfClass:[UMComFeed class]]) {
                if (completion) {
                    completion(feed,nil);
                }
                return;
            }
        }
        
        if (completion) {
            completion(responseObject,error);
        }
    }];
}

@end

@interface UMComTopicFeedDataController ()

@property(nonatomic,strong)NSString* topicId;

@property(nonatomic,assign)UMComTopicFeedListSortType sortType;
@property(nonatomic,assign)BOOL isReverse;
@property(nonatomic,assign)NSInteger topicFeedcount;
@end

@implementation UMComTopicFeedDataController


- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_RealTimeHotFeed count:count];
    if (self) {
        
    }
    return self;
}

+ (id)fecthFeedsTopicRelatedWithTopicId:(NSString *)topicId
                               sortType:(UMComTopicFeedListSortType)sortType
                              isReverse:(BOOL)isReverse
                                  count:(NSInteger)count
{
    UMComTopicFeedDataController*  topicFeedDataController = [[UMComTopicFeedDataController alloc] initWithRequestType:UMComRequestType_FeedWithTopicID count:count];
    topicFeedDataController.topicId = topicId;
    topicFeedDataController.sortType = sortType;
    topicFeedDataController.isReverse = isReverse;
    return topicFeedDataController;
}


- (void)doRefreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    
    __weak typeof(self) weakself  = self;
    [[UMComDataRequestManager defaultManager]  fecthFeedsTopicRelatedWithTopicId:self.topicId sortType:self.sortType isReverse:self.isReverse count:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakself handleNewData:responseObject error:error completion:completion];
    }];
}

-(NSArray*) filterTopItemWithCommonFeed:(NSArray*)orginCommonFeedList
{
    
    if (orginCommonFeedList && [orginCommonFeedList isKindOfClass:[NSArray class]] && orginCommonFeedList.count > 0) {
        
        NSMutableArray* filterCommonFeedList =  [NSMutableArray arrayWithCapacity:10];
        
        [orginCommonFeedList enumerateObjectsUsingBlock:^(UMComFeed*  _Nonnull feed, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (feed && [feed isKindOfClass:[UMComFeed class]]) {
                
                if ([feed.is_topic_top isKindOfClass:[NSNumber class]] && feed.is_topic_top.integerValue == 1) {
                    
                }
                else
                {
                    [filterCommonFeedList addObject:feed];
                }
            }
        }];
        
        return filterCommonFeedList;
    }
    
    return [super filterTopItemWithCommonFeed:orginCommonFeedList];
}

@end


/*******************************************************/
/*置顶DataController begin*/
/*******************************************************/

@implementation UMComTopFeedListDataController

- (void)handleNewData:(NSDictionary *)data error:(NSError *)error completion:(UMComDataRequestCompletion)completion
{
    if (!self.topDataArray) {
        self.topDataArray = [NSMutableArray array];
    }
    else{
        [self.topDataArray removeAllObjects];
    }
    
    if (![data isKindOfClass:[NSDictionary class]]) {
        if (completion) {
            completion(nil, error);
        }
        return;
    }
    
    NSArray *feedList = [data valueForKey:UMComModelDataKey];
    if ([feedList isKindOfClass:[NSArray class]] && feedList.count >0) {
        [self.topDataArray addObjectsFromArray:feedList];
    }
    self.nextPageUrl = [data valueForKey:UMComModelDataNextPageUrlKey];
    self.canVisitNextPage = [[data valueForKey:UMComModelDataVisitKey] boolValue];
    self.topItemsCount = self.topDataArray.count;
    
    if (completion) {
        completion([data valueForKey:UMComModelDataKey], error);
    }
}

@end
/**
 *  全局置顶DataController
 */
@implementation UMComGlobalTopFeedListDataController

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakself  = self;
    [[UMComDataRequestManager defaultManager] fetchTopFeedWithCount:self.count
                                                     WithCompletion:^(NSDictionary *responseObject, NSError *error) {
        
        [weakself handleNewData:responseObject error:error completion:completion];
    }];
}

@end

/**
 *  话题置顶DataController
 */
@implementation UMComTopTopicFeedListDataController

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakself  = self;
    [[UMComDataRequestManager defaultManager] fetchTopTopicFeedWithCount:self.count
                                                          topfeedTopicID:self.topicID
                                                          WithCompletion:^(NSDictionary *responseObject, NSError *error) {
            [weakself handleNewData:responseObject error:error completion:completion];
                                                              
      }];
}

@end

/*******************************************************/
/*置顶DataController end*/
/*******************************************************/