//
//  UMComFeedListDataController.h
//  UMCommunity
//
//  Created by umeng on 16/5/3.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComListDataController.h"

@class UMComFeed;
@class UMComTopFeedListDataController;

@interface UMComFeedListDataController : UMComListDataController

//置顶的topFeedListDataController
@property(nonatomic,strong)UMComTopFeedListDataController* topFeedListDataController;

/**
 *  继承UMComFeedListDataController的类，需要重新此类发送下拉刷新的请求
 *
 *  @param completion 成功回调
 */
- (void)doRefreshNewDataCompletion:(UMComDataListRequestCompletion)completion;

- (void)deleteFeed:(UMComFeed *)feed completion:(UMComDataRequestCompletion)completion;

- (void)likeFeed:(UMComFeed *)feed completion:(UMComDataRequestCompletion)completion;

- (void)favouriteFeed:(UMComFeed *)feed completion:(UMComDataRequestCompletion)completion;

//
- (void)spamFeed:(UMComFeed *)feed completion:(UMComDataRequestCompletion)completion;

- (void)commentFeedWithFeedID:(NSString *)feedID
               commentContent:(NSString *)commentContent
               replyCommentID:(NSString *)replyCommentID
                  replyUserID:(NSString *)replyUserID
         commentCustomContent:(NSString *)commentCustomContent
                       images:(NSArray *)images
                   completion:(UMComRequestCompletion)completion;

- (void)feedForwardWithFeedID:(NSString *)feedId
                      content:(NSString *)content
                    topic_ids:(NSArray *)topic_ids
                  relatedUids:(NSArray *)uids
                     feedType:(NSInteger)type
                 locationName:(NSString *)locationName
                     location:(CLLocation *)location
                       custom:(NSString *)customContent
                   completion:(UMComRequestCompletion)completion;
//
- (void)shareFeed:(UMComFeed *)feed toPlatform:(NSString *)platform completion:(UMComDataRequestCompletion)completion;



/**
 *  过滤普通流中的置顶数据
 *
 *  @param orginCommonFeedList 从网络取得普通流
 *
 *  @return 返回新的过滤的array(默认返回自身)
 *  @子类可以重写来重新过滤的条件
 */
-(NSArray*) filterTopItemWithCommonFeed:(NSArray*)orginCommonFeedList;
@end

/**
 *实时热门Feed流
 */
@interface UMComFeedListOfRealTimeHotController : UMComFeedListDataController

@end

/**
 *热门Feed流
 */
@interface UMComFeedListOfHotController : UMComFeedListDataController

@property (nonatomic, assign) NSInteger hotDay;

@end

/**
 *实时feed流
 */
@interface UMComFeedListOfRealTimeController : UMComFeedListDataController

@end


/**
 *关注feed流
 */
@interface UMComFeedListOfFocusController : UMComFeedListDataController

@end

/**
 *推荐feed流
 */
@interface UMComFeedListOfRecommendController : UMComFeedListDataController

@end

/**
 *时间戳feed流
 */
@interface UMComFeedListOfTimeLineController : UMComFeedListDataController

@property (nonatomic, assign) UMComTimeLineFeedListType timeLineFeedListType;

@property (nonatomic, copy) NSString *userID;

- (instancetype)initWithCount:(NSInteger)count userID:(NSString *)userID timeLineFeedListType:(UMComTimeLineFeedListType)timeLineFeedListType;

@end

/**
 *话题下最新发布的feed流
 */
@interface UMComFeedListOfTopicLatesController : UMComFeedListDataController

@property (nonatomic, copy) NSString *topicId;
/**
 *话题下Feed的排序方式
 */
@property (nonatomic, assign) UMComTopicFeedListSortType topicFeedSortType;

@property (nonatomic, assign) BOOL isReverse;

- (instancetype)initWithCount:(NSInteger)count topicId:(NSString *)topicId topicFeedSortType:(UMComTopicFeedListSortType)topicFeedSortType;

@end

/**
 *话题下热门feed流
 */
@interface UMComFeedListOfTopicHotController : UMComFeedListDataController

@property (nonatomic, copy) NSString *topicId;

@property (nonatomic, assign) NSInteger hotDay;

- (instancetype)initWithCount:(NSInteger)count topicId:(NSString *)topicId hotDay:(NSInteger)hotDay;
@end

///**
// *话题下最新评论的feed流
// */
//@interface UMComFeedListOfToicLatesCommentController : UMComFeedListDataController
//
//@property (nonatomic, copy) NSString *topicId;
//
//
//@end


/**
 *话题下推荐feed流
 */
@interface UMComFeedListOfTopicRecommendController : UMComFeedListDataController

@property (nonatomic, copy) NSString *topicId;

- (instancetype)initWithCount:(NSInteger)count topicId:(NSString *)topicId;

@end

/**
 *被@的feed流
 */
@interface UMComFeedListOfBeAtController : UMComFeedListDataController

@end

/**
 *我的好友圈的feed流
 */
@interface UMComFeedListOfFriendsController : UMComFeedListDataController

@end

/**
 *我的收藏的feed流
 */
@interface UMComFeedListOfFavoriteController : UMComFeedListDataController

@end

/**
 *附近的feed流
 */
@interface UMComFeedListOfSurroundingController : UMComFeedListDataController

@property (nonatomic, strong) CLLocation *locatoion;

- (instancetype)initWithCount:(NSInteger)count location:(CLLocation *)location;

@end

/**
 *搜索的feed流
 */
@interface UMComFeedListOfSearchController : UMComFeedListDataController

@property (nonatomic, copy) NSString *keyWord;

- (instancetype)initWithCount:(NSInteger)count keyWord:(NSString *)keyWord;

@end

/**
 *  创建feed的dataDataController
 */
@interface UMComCreateFeedDataController : NSObject

+ (void)feedCreateWithContent:(NSString *)content
                        title:(NSString *)title
                     location:(CLLocation *)location
                 locationName:(NSString *)locationName
                 related_uids:(NSArray<NSString *> *)related_uids
                    topic_ids:(NSArray<NSString *> *)topic_ids
                       images:(NSArray *)images
                         type:(NSNumber *)type
                       custom:(NSString *)custom
                   completion:(UMComDataRequestCompletion)completion;

@end

/**
 *  话题下的feed列表
 */
@interface UMComTopicFeedDataController : UMComFeedListDataController

+ (id)fecthFeedsTopicRelatedWithTopicId:(NSString *)topicId
                               sortType:(UMComTopicFeedListSortType)sortType
                              isReverse:(BOOL)isReverse
                                  count:(NSInteger)count;

@end



/*******************************************************/
/*置顶DataController begin*/
/*******************************************************/

//所有置顶数据的基类
@interface UMComTopFeedListDataController : UMComListDataController

//置顶的数据
@property(nonatomic,strong)NSMutableArray* topDataArray;

@end

/**
 *  全局置顶DataController
 */
@interface UMComGlobalTopFeedListDataController : UMComTopFeedListDataController

@end

/**
 *  话题置顶DataController
 */
@interface UMComTopTopicFeedListDataController : UMComTopFeedListDataController

@property(nonatomic,strong) NSString* topicID;
@end

/*******************************************************/
/*置顶DataController end*/
/*******************************************************/
