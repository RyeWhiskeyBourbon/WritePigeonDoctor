//
//  UMComUserListDataController.h
//  UMCommunity
//
//  Created by umeng on 16/5/4.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComListDataController.h"

@class UMComUser, UMComTopic;
/**
 * 用户相关列表DataController
 */
@interface UMComUserListDataController : UMComListDataController

/**
 *关注或取消关注用户
 */
- (void)followOrDisFollowUser:(UMComUser *)user completion:(UMComDataRequestCompletion)completion;

/**
 * 举报用户
 */
- (void)spamUser:(UMComUser *)user completion:(UMComDataRequestCompletion)completion;


@end

/**
 * 用户粉丝列表
 */
@interface UMComUserFansDataController : UMComUserListDataController

/**
 *用户
 */
@property (nonatomic, strong) UMComUser *user;

@end


/**
 *用户关注的人列表
 */
@interface UMComUserFollowingDataController : UMComUserListDataController

/**
 *用户
 */
@property (nonatomic, strong) UMComUser *user;

@end

/**
 *推荐用户列表
 */
@interface UMComUserRecommentDataController : UMComUserListDataController


@end

/**
 *话题下活跃用户
 */
@interface UMComUseTopicHotDataController : UMComUserListDataController

/**
 *活跃用户所在的话题
 */
@property (nonatomic, strong) UMComTopic *topic;

@end

/**
 *附近用户
 */
@interface UMComUseNearbyDataController : UMComUserListDataController

/**
 *当前位置
 */
@property (nonatomic, strong) CLLocation *location;

@end

/**
 * 当前登录用户被赞的feed列表
 */
@interface UMComUseReceivedLikeDataController : UMComUserListDataController


@end