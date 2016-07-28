//
//  UMComDataLocalPersistenceHandleDelegate.h
//  UMCommunity
//
//  Created by umeng on 16/3/15.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMComTools.h"


typedef void(^DadaHandleCompletion)(id data, NSError *error);

@protocol UMComDataLocalPersistenceHandleDelegate <NSObject>

#pragma mark - Feed
/**
 处理我关注的Feed列表
 */
- (void)handleMyFollowedFeedsData:(NSDictionary *)data
                            error:(NSError *)error
                       completion:(DadaHandleCompletion)completion;

/**
 处理推荐Feed列表
 */
- (void)handleRecommentFeedsData:(NSDictionary *)data
                           error:(NSError *)error
                      completion:(DadaHandleCompletion)completion;

//处理最新的Feed列表
- (void)handleNewsFeedsData:(NSDictionary *)data
                      error:(NSError *)error
                 completion:(DadaHandleCompletion)completion;
/**
 处理社区下的热门Feed列表
 */
- (void)handleHotestFeedsData:(NSDictionary *)data
                        error:(NSError *)error
                   completion:(DadaHandleCompletion)completion;

/**
 处理好友的Feed列表
 */
- (void)handleFriendsFeedsData:(NSDictionary *)data
                         error:(NSError *)error
                    completion:(DadaHandleCompletion)completion;

/**
 *  处理相关feed流类型的置顶
 *
 *  @param topFeedCount 请求topfeed的数量
 *  @param completion     返回的block处理
 */
- (void)handleTopFeedsTopFeedData:(NSDictionary *)data
                            error:(NSError *)error
                       completion:(DadaHandleCompletion)completion;

/**
 *  处理相关话题ID下feed流类型的置顶
 *
 *  @param topFeedCount   请求topfeed的数量
 *  @param topfeedTopicID 请求置顶的Feed的话题ID
 *  @param completion     返回的block处理
 */
- (void)handleTopFeedsTopFeedData:(NSDictionary *)data
                            error:(NSError *)error
                   topfeedTopicID:(NSString*)topfeedTopicID
                       completion:(DadaHandleCompletion)completion;

/**
 处理keywords相关的Feed列表
 */
- (void)handleSearchFeedsData:(NSDictionary *)data
                        error:(NSError *)error
                   completion:(DadaHandleCompletion)completion;

//处理附近的Feed列表
- (void)handleNearbyFeedsData:(NSDictionary *)data
                        error:(NSError *)error
                   completion:(DadaHandleCompletion)completion;

//处理对应feedIds列表对应的Feed列表
- (void)handleFeedsFeedIdsData:(NSDictionary *)data
                         error:(NSError *)error
                    completion:(DadaHandleCompletion)completion;


//处理用户时间轴的Feed列表
- (void)handleUserTimelineData:(NSDictionary *)data
                         error:(NSError *)error
                          fuid:(NSString *)fuid
                      sortType:(UMComTimeLineFeedListType)sortType
                    completion:(DadaHandleCompletion)completion;

//处理用户被@的Feed列表
- (void)handleUserBeAtFeedData:(NSDictionary *)data
                         error:(NSError *)error
                    completion:(DadaHandleCompletion)completion;

//处理用户收藏的Feed列表
- (void)handleUserFavouriteFeedsData:(NSDictionary *)data
                               error:(NSError *)error
                          completion:(DadaHandleCompletion)completion;

//处理话题相关的Feed列表
- (void)handleTopicRelatedFeedsData:(NSDictionary *)data
                              error:(NSError *)error
                            topicId:(NSString *)topicId
                           sortType:(UMComTopicFeedListSortType)sortType
                          isReverse:(BOOL)isReverse
                         completion:(DadaHandleCompletion)completion;

//处理话题下的热门Feed列表
- (void)handleTopicHotFeedsData:(NSDictionary *)data
                          error:(NSError *)error
                         inDays:(NSInteger)days
                        topicId:(NSString *)topicId
                     completion:(DadaHandleCompletion)completion;

//处理该话题下推荐feed列表
- (void)handleTopicRecommendFeedsData:(NSDictionary *)data
                                error:(NSError *)error
                              topicId:(NSString *)topicId
                           completion:(DadaHandleCompletion)completion;

//处理单个
- (void)handleOneFeedData:(NSDictionary *)data
                    error:(NSError *)error
                   feedId:(NSString *)feedId
                commentId:(NSString *)commentId
               completion:(DadaHandleCompletion)completion;


//创建 feed（发消息）
- (void)handleCreateFeedData:(NSDictionary *)data
                       error:(NSError *)error
                  completion:(DadaHandleCompletion)completion;

//点赞某个feed或取消
- (void)handleLikeFeedData:(NSDictionary *)data
                     error:(NSError *)error
                      feed:(NSString *)feedId
                completion:(DadaHandleCompletion)completion;


/**
 *  @param feedId 转发的feedid
 */
- (void)handleForwardData:(NSDictionary *)data
                    error:(NSError *)error
                     feed:(NSString *)feedId
               completion:(DadaHandleCompletion)completion;


//举报feed
- (void)handleSpamFeedData:(NSDictionary *)data
                     error:(NSError *)error
                      feed:(NSString *)feedId
                completion:(DadaHandleCompletion)completion;

//删除feed
- (void)handleDeleteFeedData:(NSDictionary *)data
                       error:(NSError *)error
                        feed:(NSString *)feedId
                  completion:(DadaHandleCompletion)completion;


//收藏某个feed操作/取消收藏某个feed操作
- (void)handleFavouriteFeedData:(NSDictionary *)data
                          error:(NSError *)error
                         feedId:(NSString *)feedId
                    resultBlock:(DadaHandleCompletion)completion;

//统计分享信息
- (void)handleShareCallbackData:(NSDictionary *)data
                          error:(NSError *)error
                         feedId:(NSString *)feedId
                     completion:(DadaHandleCompletion)completion;

//处理未读feed消息数
- (void)handleUnreadFeedCountData:(NSDictionary *)data
                            error:(NSError *)error
                      resultBlock:(DadaHandleCompletion)completion;


#pragma mark - user

//处理keywords相关的用户列表
- (void)handleSearchUsersData:(NSDictionary *)data
                        error:(NSError *)error
                     keywords:(NSString *)keywords
                   completion:(DadaHandleCompletion)completion;

//处理某个话题相关的活跃用户列表
- (void)handleTopicActiveUsersData:(NSDictionary *)data
                             error:(NSError *)error
                           topicId:(NSString *)topicId
                        completion:(DadaHandleCompletion)completion;

//处理推荐的用户列表
- (void)handleRecommentUsersData:(NSDictionary *)data
                           error:(NSError *)error
                      completion:(DadaHandleCompletion)completion;

//处理某个用户的粉丝列表
- (void)handleUserFansData:(NSDictionary *)data
                     error:(NSError *)error
                      fuid:(NSString *)fuid
                completion:(DadaHandleCompletion)completion;

//处理某个用户关注的人的列表
- (void)handleUserFollowingsData:(NSDictionary *)data
                           error:(NSError *)error
                            fuid:(NSString *)fuid
                      completion:(DadaHandleCompletion)completion;

//处理某个用户的详细信息
- (void)handleUserProfileData:(NSDictionary *)data
                        error:(NSError *)error
                   completion:(DadaHandleCompletion)completion;


//用户登录

- (void)handleUserLoginData:(NSDictionary *)data
                      error:(NSError *)error
               userNameType:(UMComUserNameType)userNameType
             userNameLength:(UMComUserNameLength)userNameLength
                 completion:(DadaHandleCompletion)completion;

//关注和取消关注用户
- (void)handleUserFollowData:(NSDictionary *)data
                       error:(NSError *)error
                        fuid:(NSString *)fuid
                  completion:(DadaHandleCompletion)completion;

/**
 更新用户信息
 @warning iconDict 的结构{240:"小图url",360:"中图url",orgin:"大图url",format:"格式"}
 */
//修改用户资料
- (void)handleUpdateProfileData:(NSDictionary *)data
                          error:(NSError *)error
                   userNameType:(UMComUserNameType)userNameType
                 userNameLength:(UMComUserNameLength)userNameLength
                     completion:(DadaHandleCompletion)completion;

- (void)handleUpdateUserAvatarData:(NSDictionary *)data
                             error:(NSError *)error
                        completion:(DadaHandleCompletion)completion;

//举报用户
- (void)handleSpamUserData:(NSDictionary *)data
                     error:(NSError *)error
                       uid:(NSString *)uid
                completion:(DadaHandleCompletion)completion;

//管理员对用户禁言
- (void)handleBanUserData:(NSDictionary *)data
                    error:(NSError *)error
                      uid:(NSString *)uid
               completion:(DadaHandleCompletion)result;


//处理未读消息数
//- (void)unreadMessageCountUid:(NSString *)uid resultBlock:(DadaHandleCompletion)completion;

#pragma mark - topic

//处理所有的话题列表
- (void)handleAllTopicsData:(NSDictionary *)data
                      error:(NSError *)error
                 completion:(DadaHandleCompletion)completion;

//处理keywords相关的话题列表
- (void)handleSearchTopicsData:(NSDictionary *)data
                         error:(NSError *)error
                    completion:(DadaHandleCompletion)completion;
//处理某个用户关注的话题列表
- (void)handleUserFocusTopicsData:(NSDictionary *)data
                            error:(NSError *)error
                             fuid:(NSString *)fuid
                       completion:(DadaHandleCompletion)completion;

//处理推荐话题列表
- (void)handleRecommendTopicsData:(NSDictionary *)data
                            error:(NSError *)error
                       completion:(DadaHandleCompletion)completion;

//处理单个话题
- (void)handleOneTopicData:(NSDictionary *)data
                     error:(NSError *)error
                completion:(DadaHandleCompletion)completion;

//处理话题类型列表
- (void)handleTopicCategorysData:(NSDictionary *)data
                           error:(NSError *)error
                      completion:(DadaHandleCompletion)completion;

//处理类型下的话题列表
- (void)handleTopicsData:(NSDictionary *)data
                   error:(NSError *)error
              categoryId:(NSString *)categoryId
              completion:(DadaHandleCompletion)completion;

//关注或取消关注某个话题
- (void)topicFocuseTopicIdData:(NSDictionary *)data
                         error:(NSError *)error
                       topicId:(NSString *)topicId
                    completion:(DadaHandleCompletion)completion;



#pragma mark - comment

//处理某个Feed的评论列表
- (void)handleFeedCommentsData:(NSDictionary *)data
                         error:(NSError *)error
                        feedId:(NSString *)feedId
                 commentUserId:(NSString *)comment_uid
                      sortType:(UMComCommentListSortType)sortType
                    completion:(DadaHandleCompletion)completion;

//处理用户收到的评论列表
- (void)handleUserCommentsReceivedData:(NSDictionary *)data
                                 error:(NSError *)error
                            completion:(DadaHandleCompletion)completion;

//处理用户写过的评论列表
- (void)handleUserCommentsSentData:(NSDictionary *)data
                             error:(NSError *)error
                        completion:(DadaHandleCompletion)completion;

//对某 feed 发表评论
- (void)handleCommentData:(NSDictionary *)data
                    error:(NSError *)error
                   feedID:(NSString *)feedID
                 replyUid:(NSString *)commentUid
           replyCommentID:(NSString *)replyCommentID
               completion:(DadaHandleCompletion)completion;

//举报feed的评论
- (void)handleSpamCommentData:(NSDictionary *)data
                        error:(NSError *)error
                    commentId:(NSString *)commentId
                   completion:(DadaHandleCompletion)completion;

//删除feed的评论
- (void)handleDeleteCommentData:(NSDictionary *)data
                          error:(NSError *)error
                      commentId:(NSString *)commentId
                         feedId:(NSString *)feedId
                     completion:(DadaHandleCompletion)completion;

- (void)handleLikeCommentData:(NSDictionary *)data
                        error:(NSError *)error
                    commentId:(NSString *)commentId
                   completion:(DadaHandleCompletion)completion;

#pragma mark - like
//处理某个Feed的点赞列表
- (void)handleFeedLikesData:(NSDictionary *)data
                      error:(NSError *)error
                     feedId:(NSString *)feedId
                 completion:(DadaHandleCompletion)completion;
//处理用户点赞列表
- (void)handleUserLikesReceivedData:(NSDictionary *)data
                              error:(NSError *)error
                         completion:(DadaHandleCompletion)completion;

//处理用户点赞记录
- (void)handleUserLikesSendsData:(NSDictionary *)data
                           error:(NSError *)error
                            fuid:(NSString *)fuid
                      completion:(DadaHandleCompletion)completion;

#pragma mark - notification

//处理用户通知列表
- (void)handleUserNotificationData:(NSDictionary *)data
                             error:(NSError *)error
                        completion:(DadaHandleCompletion)completion;


#pragma mark - album
//处理用户相册列表
- (void)handleUserAlbumData:(NSDictionary *)data
                      error:(NSError *)error
                       fuid:(NSString *)fuid
                       completion:(DadaHandleCompletion)completion;

#pragma mark - Private Letter
//处理私信列表
- (void)handlePrivateLetterData:(NSDictionary *)data
                          error:(NSError *)error
                     completion:(DadaHandleCompletion)completion;

//处理私信聊天记录
- (void)handlePrivateChartRecordData:(NSDictionary *)data
                               error:(NSError *)error
                               toUid:(NSString *)toUid
                          completion:(DadaHandleCompletion)completion;
//初始化私信窗口
- (void)handleInitChartBoxToUidData:(NSDictionary *)data
                              error:(NSError *)error
                              toUID:(NSString *)toUID
                          responese:(DadaHandleCompletion)completion;
//发送私信
- (void)handleSendPrivateMessageData:(NSDictionary *)data
                               error:(NSError *)error
                               toUid:(NSString *)toUid
                           responese:(DadaHandleCompletion)completion;


#pragma mark - location
// 处理 地理位置数据
- (void)handleLocationData:(NSDictionary *)data
                     error:(NSError *)error
                completion:(DadaHandleCompletion)completion;


#pragma mark - 社区级别
// 处理配置数据
- (void)handleConfigData:(NSDictionary *)data
                   error:(NSError *)error
              completion:(DadaHandleCompletion)completion;

- (void)handleUpdateTemplateChoiceData:(NSDictionary *)data
                                 error:(NSError *)error
                            completion:(DadaHandleCompletion)completion;

- (void)handleCommunityStatisticsData:(NSDictionary *)data
                                error:(NSError *)error
                            responese:(DadaHandleCompletion)completion;



@end
