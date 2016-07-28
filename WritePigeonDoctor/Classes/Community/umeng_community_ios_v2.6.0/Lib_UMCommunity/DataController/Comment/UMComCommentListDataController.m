//
//  UMComCommentListDataController.m
//  UMCommunity
//
//  Created by umeng on 16/5/18.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComCommentListDataController.h"

@interface UMComCommentListDataController ()

- (void)handleCommentData:(NSDictionary *)data error:(NSError *)error completion:(UMComDataListRequestCompletion)completion;

@end

@implementation UMComCommentListDataController


- (void)handleCommentData:(NSDictionary *)data error:(NSError *)error completion:(UMComDataListRequestCompletion)completion
{
    [self handleNewData:data error:error completion:completion];
}

@end


@implementation UMComFeedCommnetListDataController

- (instancetype)initWithCount:(NSInteger)count feedID:(NSString *)feedId replyUserID:(NSString *)replyUserId commentSortType:(UMComCommentListSortType)commentSorttype
{
    self = [super initWithRequestType:UMComRequestType_FeedComment count:count];
    if (self) {
        self.feedID = feedId;
        self.replyUserId = replyUserId;
        self.commentSortType = commentSorttype;
    }
    return self;
}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] fecthCommentsWithFeedId:self.feedID commentUserId:self.replyUserId sortType:self.commentSortType count:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakSelf handleCommentData:responseObject error:error completion:completion];
    }];
}

@end
@implementation UMComUserReceivedCommentListDataController

- (instancetype)initWithCount:(NSInteger)count feedID:(NSString *)feedId replyUserID:(NSString *)replyUserId commentSortType:(UMComCommentListSortType)commentSorttype
{
    self = [super initWithRequestType:UMComRequestType_UserReceiveComment count:count];
    if (self) {
    }
    return self;
}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] fecthCommentsUserReceivedWithCount:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakSelf handleCommentData:responseObject error:error completion:completion];
    }];
}

@end
@implementation UMComUserSentCommentListDataController

- (instancetype)initWithCount:(NSInteger)count feedID:(NSString *)feedId replyUserID:(NSString *)replyUserId commentSortType:(UMComCommentListSortType)commentSorttype
{
    self = [super initWithRequestType:UMComRequestType_UserSendComment count:count];
    if (self) {
    }
    return self;
}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] fecthCommentsUserSentWithCount:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakSelf handleCommentData:responseObject error:error completion:completion];
    }];
}

@end

