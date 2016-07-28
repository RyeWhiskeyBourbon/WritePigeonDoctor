//
//  UMComUserListDataController.m
//  UMCommunity
//
//  Created by umeng on 16/5/4.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComUserListDataController.h"
#import "UMComUser.h"
#import "UMComTopic.h"
#import <CoreLocation/CoreLocation.h>


@implementation UMComUserListDataController

- (void)followOrDisFollowUser:(UMComUser *)user completion:(UMComDataRequestCompletion)completion
{

}

- (void)spamUser:(UMComUser *)user completion:(UMComDataRequestCompletion)completion
{

}


- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    
}

- (void)fecthLocalDataWithCompletion:(UMComDataListRequestCompletion)completion
{
    
}


- (void)fecthDataWithCompletion:(UMComDataListRequestCompletion)localFecthcompletion serverDataCompletion:(UMComDataListRequestCompletion)serverRequestCompletion
{
    
}


@end


/**
 * 用户粉丝列表
 */
@implementation UMComUserFansDataController

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_UserFansUser count:count];
    if (self) {
        self.pageRequestType = UMComRequestType_UserFansUser;
    }
    return self;
}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    [[UMComDataRequestManager defaultManager] fecthUserFansWithUid:self.user.uid count:self.count completion:^(NSDictionary *responseObject, NSError *error) {
    
    }];
}

@end


/**
 *用户关注的人列表
 */
@implementation UMComUserFollowingDataController

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithCount:count];
    if (self) {
        self.pageRequestType = UMComRequestType_UserFollowsUser;
    }
    return self;
}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    [[UMComDataRequestManager defaultManager] fecthUserFollowingsWithUid:self.user.uid count:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        
    }];
}

@end

/**
 *推荐用户列表
 */
@implementation UMComUserRecommentDataController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pageRequestType = UMComRequestType_RecommentUser;
    }
    return self;
}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    [[UMComDataRequestManager defaultManager] fecthUsersRecommentWithCount:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        
    }];
}

@end

/**
 *话题下活跃用户
 */
@implementation UMComUseTopicHotDataController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pageRequestType = UMComRequestType_UserFansUser;
    }
    return self;
}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    [[UMComDataRequestManager defaultManager] fecthUsersWithActiveTopicId:self.topic.topicID count:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        
    }];
}

@end

/**
 *附近用户
 */
@implementation UMComUseNearbyDataController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pageRequestType = UMComRequestType_UserFansUser;
    }
    return self;
}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    [[UMComDataRequestManager defaultManager] fecthUserNearbyWithLocation:self.location count:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        
    }];
}

@end

@implementation UMComUseReceivedLikeDataController

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_UserFansUser count:count];
    if (self) {
        self.pageRequestType = UMComRequestType_FeedLike;
    }
    return self;
}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    [[UMComDataRequestManager defaultManager] fecthLikesUserReceivedWithCount:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [self handleNewData:responseObject error:error completion:completion];
    }];
}


@end