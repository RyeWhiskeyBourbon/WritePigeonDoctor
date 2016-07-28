//
//  UMComHttpManager.h
//  UMCommunity
//
//  Created by luyiyuan on 14/8/27.
//  Copyright (c) 2014年 luyiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "UMComTools.h"

@interface UMComHttpManager : NSObject

+ (UMComHttpManager *)shareInstance;

/******************Page request method List start*********************************/

//获取下一页请求
+ (void)getRequestNextPageWithNextPageUrl:(NSString *)urlString
                                 response:(UMComHttpRequestCompletion)response;


#pragma mark - user

//获取keywords相关的用户列表
+ (void)getSearchUsersWithCount:(NSInteger)count
                       keywords:(NSString *)keywords
                       response:(UMComHttpRequestCompletion)response;

//获取某个话题相关的活跃用户列表
+ (void)getTopicActiveUsersWithCount:(NSInteger)count
                             topicId:(NSString *)topicId
                            response:(UMComHttpRequestCompletion)response;

//获取推荐的用户列表
+ (void)getRecommentUsersWithCount:(NSInteger)count
                          response:(UMComHttpRequestCompletion)response;

//获取某个用户的粉丝列表
+ (void)getUserFansWithCount:(NSInteger)count
                        fuid:(NSString *)fuid
                    response:(UMComHttpRequestCompletion)response;

//获取某个用户关注的人的列表
+ (void)getUserFollowingsWithCount:(NSInteger)count
                              fuid:(NSString *)fuid
                          response:(UMComHttpRequestCompletion)response;

//获取某个用户的详细信息
+ (void)getUserProfileWithFuid:(NSString *)fuid
                        source:(NSString *)source
                    source_uid:(NSString *)source_uid
                      response:(UMComHttpRequestCompletion)response;

//获取附近的User列表
+ (void)getUserNearbyWithCount:(NSInteger)count
                      location:(CLLocation *)location
                      response:(UMComHttpRequestCompletion)response;


//用户登录

+ (void)userLoginWithName:(NSString *)name
                   source:(UMComSnsType)source
                 sourceId:(NSString *)sourceId
                 icon_url:(NSString *)icon_url
                   gender:(NSInteger)gender
                      age:(NSInteger)age
                   custom:(NSString *)custom
                    score:(CGFloat)score
               levelTitle:(NSString *)levelTitle
                    level:(NSInteger)level
        contextDictionary:(NSDictionary *)context
             userNameType:(UMComUserNameType)userNameType
           userNameLength:(UMComUserNameLength)userNameLength
                 response:(UMComHttpRequestCompletion)response;

//用户登录（开发者自有账号）
+ (void)userLoginInCustomAccountWithName:(NSString *)name
                                sourceId:(NSString *)sourceId
                                icon_url:(NSString *)icon_url
                                  gender:(NSInteger)gender
                                     age:(NSInteger)age
                                  custom:(NSString *)custom
                                   score:(CGFloat)score
                              levelTitle:(NSString *)levelTitle
                                   level:(NSInteger)level
                            userNameType:(UMComUserNameType)userNameType
                          userNameLength:(UMComUserNameLength)userNameLength
                                response:(UMComHttpRequestCompletion)response;

// 用户登录（友盟微社区用户系统）
+ (void)userLoginInUMCommunity:(NSString *)userAccount
                      password:(NSString *)password
                      response:(UMComHttpRequestCompletion)response;

// 用户注册（友盟微社区用户系统）
+ (void)userSignUpUMCommunity:(NSString *)userAccount
                     password:(NSString *)password
                     nickName:(NSString *)name
                     response:(UMComHttpRequestCompletion)response;

// 忘记密码（友盟微社区用户系统）
+ (void)userPasswordForgetForUMCommunity:(NSString *)userAccount
                                response:(UMComHttpRequestCompletion)response;

//关注和取消关注用户
+ (void)followWithUserID:(NSString *)fuid
                isFollow:(BOOL)isFollow
                response:(UMComHttpRequestCompletion)response;

/**
 更新用户信息
 */
//修改用户资料
+ (void)updateProfileWithName:(NSString *)name
                          age:(NSNumber *)age
                       gender:(NSNumber *)gender
                       custom:(NSString *)custom
                 userNameType:(UMComUserNameType)userNameType
               userNameLength:(UMComUserNameLength)userNameLength
                     response:(UMComHttpRequestCompletion)response;

/**
 更新用户头像
 @param 可以是NSString（图片的url）类型,也可以是UIImage(直接传图片)
 */
+ (void)updateUserIcon:(id)icon
              response:(UMComHttpRequestCompletion)response;

//举报用户
+ (void)spamUser:(NSString *)userId
        response:(UMComHttpRequestCompletion)response;

//管理员对用户禁言
+ (void)banUserWithUserId:(NSString *)userId
               inTopicIDs:(NSArray *)topicIDs
                      ban:(BOOL)ban
               completion:(UMComHttpRequestCompletion)result;

//检查用户名是否合法
+ (void)checkUserName:(NSString *)name
         userNameType:(UMComUserNameType)userNameType
       userNameLength:(UMComUserNameLength)userNameLength
          resultBlock:(UMComHttpRequestCompletion)response;

//更新用户当前位置
+ (void)updateUserLocation:(CLLocation *)location
                  response:(UMComHttpRequestCompletion)response;


#pragma mark - Feed

/**
 * 获取实时热门Feed
 *
 *  @param count   请求feed的数量
 *  @param response     返回的block处理
 */
+ (void)getRealTimeHotFeedsWithCount:(NSInteger)count
                            response:(UMComHttpRequestCompletion)response;


//获取最新的Feed列表
+ (void)getRealTimeFeedsWithCount:(NSInteger)count
                         response:(UMComHttpRequestCompletion)response;

/**
 *  获取相关feed流类型的置顶
 *
 *  @param topFeedCount 请求topfeed的数量
 *  @param response     返回的block处理
 */
+ (void)getTopFeedsWithTopFeedCount:(NSInteger)topFeedCount
                       response:(UMComHttpRequestCompletion)response;

/**
 *  获取相关话题ID下feed流类型的置顶
 *
 *  @param count   请求topfeed的数量
 *  @param topicID 请求置顶的Feed的话题ID
 *  @param response     返回的block处理
 */
+ (void)getFeedsTopicTopWithTopicID:(NSString *)topicID
                              count:(NSInteger)count
                           response:(UMComHttpRequestCompletion)response;

//获取用户关注的Feed列表
+ (void)getUserFocusFeedsWithCount:(NSInteger)count
                          response:(UMComHttpRequestCompletion)response;
//获取社区下的热门Feed列表
+ (void)getHotFeedsWithCount:(NSInteger)count
                  withinDays:(NSInteger)days
                    response:(UMComHttpRequestCompletion)response;

//获取推荐Feed列表
+ (void)getRecommendFeedsWithCount:(NSInteger)count
                          response:(UMComHttpRequestCompletion)response;

//获取好友的Feed列表
+ (void)getFriendFeedsWithCount:(NSInteger)count
                       response:(UMComHttpRequestCompletion)response;

//获取keywords相关的Feed列表
+ (void)getSearchFeedsWithCount:(NSInteger)count
                       keywords:(NSString *)keywords
                       response:(UMComHttpRequestCompletion)response;

//获取附近的Feed列表
+ (void)getNearbyFeedsWithCount:(NSInteger)count
                       location:(CLLocation *)location
                       response:(UMComHttpRequestCompletion)response;

//获取对应feedIds列表对应的Feed列表
+ (void)getFeedsWithFeedIds:(NSArray *)feedIds
                   response:(UMComHttpRequestCompletion)response;

//获取单个
+ (void)getOneFeedWithFeedId:(NSString *)feedId
                   commentId:(NSString *)commentId
                    response:(UMComHttpRequestCompletion)response;

//获取用户时间轴的Feed列表
+ (void)getUserTimelineWithCount:(NSInteger)count
                            fuid:(NSString *)fuid
                        sortType:(UMComTimeLineFeedListType)sortType
                        response:(UMComHttpRequestCompletion)response;

//获取用户被@的Feed列表
+ (void)getUserBeAtFeedWithCount:(NSInteger)count
                        response:(UMComHttpRequestCompletion)response;

//获取用户收藏的Feed列表
+ (void)getUserFavouriteFeedsWithCount:(NSInteger)count
                              response:(UMComHttpRequestCompletion)response;

//获取话题相关的Feed列表
+ (void)getTopicRelatedFeedsWithCount:(NSInteger)count
                              topicId:(NSString *)topicId
                             sortType:(UMComTopicFeedListSortType)sortType
                            isReverse:(BOOL)isReverse
                             response:(UMComHttpRequestCompletion)response;

//获取话题下的热门Feed列表
+ (void)getTopicHotFeedsWithCount:(NSInteger)count
                       withinDays:(NSInteger)days
                          topicId:(NSString *)topicId
                         response:(UMComHttpRequestCompletion)response;

//获取该话题下推荐feed列表
+ (void)getTopicRecommendFeedsWithCount:(NSInteger)count
                                topicId:(NSString *)topicId
                               response:(UMComHttpRequestCompletion)response;

//获取未读feed消息数
+ (void)unreadFeedCountWithSeq:(NSNumber *)seq resultBlock:(UMComHttpRequestCompletion)response;


//创建 feed（发消息）
+ (void)createFeedWithContent:(NSString *)content
                        title:(NSString *)title
                     location:(CLLocation *)location
                 locationName:(NSString *)locationName
                 related_uids:(NSArray<NSString *> *)related_uids
                    topic_ids:(NSArray<NSString *> *)topic_ids
                       images:(NSArray *)images
                         type:(NSNumber *)type
                       custom:(NSString *)custom
                     response:(UMComHttpRequestCompletion)response;

//点赞某个feed或取消
+ (void)likeFeed:(NSString *)feedId
          isLike:(BOOL)isLike
        response:(UMComHttpRequestCompletion)response;

/**
 *  转发feed接口(2.4版本及以上)
 *  @param feedId 转发的feedid(必须发送)
 *  @param content 转发的内容(可选发送)
 *  @param topic_ids 转发的话题字符串(可选发送)
 *  @param uids 相关人列表(可选发送)
 *  @param type feed的类型
 *  @param locationName 地址名称(可选发送)(当前用户所在的位置名称)
 *  @param location 地址名称,lng 经度,lat纬度(可选发送)(当前用户所在的位置的经纬度)
 *  @param custom 自定义字段(可选发送)
 */
+ (void)feedForwardWithFeedID:(NSString *)feedId
                      content:(NSString *)content
                    topic_ids:(NSArray *)topic_ids
                  relatedUids:(NSArray *)uids
                     feedType:(NSNumber *)type
                 locationName:(NSString *)locationName
                     location:(CLLocation *)location
                       custom:(NSString *)customContent
                     response:(UMComHttpRequestCompletion)response;


//举报feed
+ (void)spamFeed:(NSString *)feedId
        response:(UMComHttpRequestCompletion)response;

//删除feed
+ (void)deleteFeed:(NSString *)feedId
          response:(UMComHttpRequestCompletion)response;


//收藏某个feed操作/取消收藏某个feed操作
+ (void)favouriteFeedWithFeedId:(NSString *)feedId
                    isFavourite:(BOOL)isFavourite
                    resultBlock:(UMComHttpRequestCompletion)response;

//统计分享信息
+ (void)feedShareToPlatform:(NSString *)platform
                     feedId:(NSString *)feedId
                   response:(UMComHttpRequestCompletion)response;



#pragma mark - topic

//获取所有的话题列表
+ (void)getAllTopicsWithCount:(NSInteger)count
                     response:(UMComHttpRequestCompletion)response;

//获取keywords相关的话题列表
+ (void)getSearchTopicsWithCount:(NSInteger)count
                        keywords:(NSString *)keywords
                        response:(UMComHttpRequestCompletion)response;
//获取某个用户关注的话题列表
+ (void)getUserFocusTopicsWithCount:(NSInteger)count
                               fuid:(NSString *)fuid
                           response:(UMComHttpRequestCompletion)response;

//获取推荐话题列表
+ (void)getRecommendTopicsWithCount:(NSInteger)count
                           response:(UMComHttpRequestCompletion)response;

//获取单个话题
+ (void)getOneTopicWithTopicId:(NSString *)topicId
                      response:(UMComHttpRequestCompletion)response;

//获取话题组列表
+ (void)getTopicGroupsWithCount:(NSInteger)count
                       response:(UMComHttpRequestCompletion)response;

//获取话题组下的话题列表
+ (void)getTopicsWithTopicGroupID:(NSString *)groupID
                            count:(NSInteger)count
                         response:(UMComHttpRequestCompletion)response;

//关注或取消关注某个话题
+ (void)topicFollowerWithTopicID:(NSString *)topicId
                        isFollow:(BOOL)isFollow
                        response:(UMComHttpRequestCompletion)response;

#pragma mark - like
//获取某个Feed的点赞列表
+ (void)getFeedLikesWithCount:(NSInteger)count
                       feedId:(NSString *)feedId
                     response:(UMComHttpRequestCompletion)response;
//获取用户点赞列表
+ (void)getUserLikesReceivedWithCount:(NSInteger)count
                             response:(UMComHttpRequestCompletion)response;

//获取用户点赞记录
+ (void)getUserLikesSendsWithCount:(NSInteger)count
                          response:(UMComHttpRequestCompletion)response;

#pragma mark - comment

//获取某个Feed的评论列表
+ (void)getFeedCommentsWithCount:(NSInteger)count
                          feedId:(NSString *)feedId
                   commentUserId:(NSString *)comment_uid
                        sortType:(UMComCommentListSortType)sortType
                        response:(UMComHttpRequestCompletion)response;

//获取用户收到的评论列表
+ (void)getUserCommentsReceivedWithCount:(NSInteger)count
                                response:(UMComHttpRequestCompletion)response;

//获取用户写过的评论列表
+ (void)getUserCommentsSentWithCount:(NSInteger)count
                            response:(UMComHttpRequestCompletion)response;

//对某 feed 发表评论
+ (void)commentFeedWithfeedID:(NSString *)feedID
                      content:(NSString *)content
                     replyUid:(NSString *)commentUid
               replyCommentID:(NSString *)replyCommentID
                commentCustom:(NSString *)commentCustom
                       images:(NSArray *)images
                     response:(UMComHttpRequestCompletion)response;

//举报feed的评论
+ (void)spamComment:(NSString *)commentId
           response:(UMComHttpRequestCompletion)response;

//删除feed的评论
+ (void)deleteComment:(NSString *)commentId
               feedId:(NSString *)feedId
             response:(UMComHttpRequestCompletion)response;

+ (void)likeComment:(NSString *)commentId
             isLike:(BOOL)isLike
           response:(UMComHttpRequestCompletion)response;


#pragma mark - notification
//获取用户通知列表
+ (void)getUserNotificationWithCount:(NSInteger)count
                            response:(UMComHttpRequestCompletion)response;


#pragma mark - album
//获取用户相册列表
+ (void)getUserAlbumWithCount:(NSInteger)count
                         fuid:(NSString *)fuid
                     response:(UMComHttpRequestCompletion)response;

#pragma mark - Private Letter 
//获取私信列表
+ (void)getPrivateLetterWithCount:(NSInteger)count
                         response:(UMComHttpRequestCompletion)response;

//获取私信聊天记录
+ (void)getPrivateChartRecordWithCount:(NSInteger)count
                                 toUid:(NSString *)toUid
                              response:(UMComHttpRequestCompletion)response;
//初始化私信窗口
+ (void)initChartBoxWithToUid:(NSString *)toUId
                    responese:(UMComHttpRequestCompletion)response;
//发送私信
+ (void)sendPrivateMessageWithContent:(NSString *)content
                                toUid:(NSString *)toUid
                            responese:(UMComHttpRequestCompletion)response;

/******************Page request method List end*********************************/


#pragma mark - other

//获取未读消息数
//+ (void)unreadMessageCountWithUid:(NSString *)uid resultBlock:(UMComHttpRequestCompletion)response;

// 获取 地理位置数据
+ (void)getLocationNamesWithLocation:(CLLocationCoordinate2D)coordinate
                            response:(UMComHttpRequestCompletion)response;

// 获取配置数据
+ (void)getConfigDataWithResponse:(UMComHttpRequestCompletion)response;

+ (void)updateTemplateChoice:(NSUInteger)choice
                    response:(UMComHttpRequestCompletion)response;



#pragma mark - 统计
+ (void)getCommunityStatisticsDataWithResponese:(UMComHttpRequestCompletion)response;

#pragma mark  获得访客模式
/**
 *  获得当前社区的访客模式
 *  @discuss 如果是2.5版本以上，需要先获得用户或者未登录用户的App的token,在header中。
 *
 *  @param response 回调block
 */
+(void)getCommunityGuestWithResponse:(UMComHttpRequestCompletion)response;


+(void)getCommunityTokenWithAppkey:(NSString *)appKey
                         appSecret:(NSString *)appSecret
                          response:(UMComHttpRequestCompletion)response;


#pragma mark - 获得积分明细

/**
 *  获得当前登录用户的积分明细
 *
 *  @param count    申请的个数
 *  @param response 返回的数据回调的block
 */
+(void) getCommunityPointDetailWithCount:(NSInteger)count
                                response:(UMComHttpRequestCompletion)response;

#pragma mark - 积分的增减操作
/**
 *  积分的增减接口
 *
 *  @param point    增加或者减少的积分数 正数代表加积分，负数代表减积分(必传参数，必须传入有效值)
 *  @param desc     当前操作积分的描述(必传参数,必须传入有效值)
 *  @param use_unit 是否使用unit(0/1,默认为0)(此参数为0或者1) 1代表用protal后台的积分基数 0 代表不用(可选参数)
 *  @param identity 自定义业务ID，长度在128一下
 *  @param response 数据回调block
 */
+(void) postCommunityPointOperationWithPoint:(NSInteger)point
                                        desc:(NSString*)desc
                                    use_unit:(NSInteger)use_unit
                                    identity:(NSString*)identity
                                    response:(UMComHttpRequestCompletion)response;

#pragma mark - 获得货币明细
+(void) getCommunityCurrencyDetailWithCount:(NSInteger)count
                                   response:(UMComHttpRequestCompletion)response;

@end
