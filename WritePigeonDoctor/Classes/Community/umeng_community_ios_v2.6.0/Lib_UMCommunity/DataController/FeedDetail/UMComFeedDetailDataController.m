//
//  UMComFeedDetailDataController.m
//  UMCommunity
//
//  Created by umeng on 16/5/3.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComFeedDetailDataController.h"
#import "UMComUser.h"
#import "UMComFeed.h"
#import "UMComComment.h"
#import "UMComSession.h"
#import "UMComMacroConfig.h"
#import "UMComErrorCode.h"

@interface UMComFeedDetailDataController ()

@end

@implementation UMComFeedDetailDataController

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)refreshFeedWithCompletion:(UMComDataRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    
    [[UMComDataRequestManager defaultManager] fecthFeedWithFeedId:self.feed.feedID commentId:nil completion:^(NSDictionary *responseObject, NSError *error) {
        if ([responseObject isKindOfClass:[NSDictionary class]] && [responseObject valueForKey:UMComModelDataKey]) {
            weakSelf.feed = [responseObject valueForKey:UMComModelDataKey];
            if (completion) {
                completion(weakSelf.feed, nil);
            }
        }else{
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}


- (void)deletedFeedWithCompletion:(UMComDataRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] feedDeleteWithFeedID:self.feed.feedID completion:^(NSDictionary *responseObject, NSError *error) {
        if (!error) {
            weakSelf.feed.status = @3;
            if (completion) {
                completion([responseObject valueForKey:UMComModelDataKey], nil);
            }
        }else{
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

- (void)likeFeedWithCompletion:(UMComDataRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    BOOL isLike = ![self.feed.liked boolValue];
    [[UMComDataRequestManager defaultManager] feedLikeWithFeedID:self.feed.feedID isLike:isLike completion:^(NSDictionary *responseObject, NSError *error) {
        
        if (!error) {
            NSDictionary* dic =  (NSDictionary*)responseObject;
            if (dic && [dic isKindOfClass:[NSDictionary class]]) {
                
                id feedLikeValue =  [dic valueForKey:UMComModelFeedLikeKey];
                if (feedLikeValue && [feedLikeValue isKindOfClass:[NSNumber class]]) {
                    
                    weakSelf.feed.liked = feedLikeValue;
                    if (weakSelf.feed.liked.boolValue) {
                        weakSelf.feed.likes_count = @(weakSelf.feed.likes_count.integerValue + 1);
                    }
                    else{
                        weakSelf.feed.likes_count = @(weakSelf.feed.likes_count.integerValue - 1);
                    }
                    
                    if (completion) {
                        completion(responseObject, error);
                    }
                }
            }
        }else{
            if (error.code == ERR_CODE_LIKE_HAS_BEEN_CANCELED) {
                if ([self.feed.liked boolValue]) {
                    self.feed.liked = @(NO);
                    self.feed.likes_count = @(self.feed.likes_count.integerValue -1);
                }
            }
            else if (error.code == ERR_CODE_FEED_HAS_BEEN_LIKED)
            {
                if (![self.feed.liked boolValue]) {
                    self.feed.liked = @(YES);
                    self.feed.likes_count = @(self.feed.likes_count.integerValue + 1);
                }
            }
            if (completion) {
                completion(nil, error);
            }
        }
        
        /*
        NSInteger likeCount = [weakSelf.feed.likes_count integerValue];
        NSNumber *liked = weakSelf.feed.liked;
        if (!error) {
            if (isLike == YES) {
                liked = @1;
                likeCount += 1;
            }else{
                if (likeCount > 0) {
                    likeCount -= 1;
                }
                liked = @0;
            }
            weakSelf.feed.liked = liked;
            weakSelf.feed.likes_count = @(likeCount);
            if (completion) {
                completion(responseObject, error);
            }
        }else{
            if (error.code == ERR_CODE_FEED_HAS_BEEN_LIKED
                ) {
                liked = @1;
                likeCount += 1;
            }else if (error.code == ERR_CODE_LIKE_HAS_BEEN_CANCELED){
                liked = @0;
                if (likeCount > 0) {
                    likeCount -= 1;
                }
            }
            weakSelf.feed.liked = liked;
            weakSelf.feed.likes_count = @(likeCount);
            if (completion) {
                completion(nil, error);
            }
        }
         */
    }];
}

- (void)spamFeedWithCompletion:(UMComDataRequestCompletion)completion
{
    [[UMComDataRequestManager defaultManager] feedSpamWithFeedID:self.feed.feedID completion:^(NSDictionary *responseObject, NSError *error) {
        if (!error) {
            if (completion) {
                completion([responseObject valueForKey:UMComModelDataKey], nil);
            }
        }else{
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

- (void)favoriteFeedWithCompletion:(UMComDataRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    BOOL isFavorite = ![self.feed.has_collected boolValue];
    [[UMComDataRequestManager defaultManager] feedFavouriteWithFeedId:self.feed.feedID isFavourite:isFavorite completionBlock:^(NSDictionary *responseObject, NSError *error) {

        if (!error) {
            if (isFavorite == YES) {
                weakSelf.feed.has_collected = @1;
            }else{
                weakSelf.feed.has_collected = @0;
            }
            if (completion) {
                completion(responseObject, error);
            }
        }else{
            if (error.code == ERR_CODE_HAS_ALREADY_COLLECTED
                ) {
                weakSelf.feed.has_collected = @1;
            }else if (error.code == ERR_CODE_HAS_NOT_COLLECTED){
                weakSelf.feed.has_collected = @0;
            }
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

- (void)commentFeedWithContent:(NSString *)content
                        images:(NSArray *)images
                    completion:(UMComDataRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] commentFeedWithFeedID:self.feed.feedID commentContent:content replyCommentID:nil replyUserID:nil commentCustomContent:nil images:images completion:^(NSDictionary *responseObject, NSError *error) {
        if ([responseObject isKindOfClass:[NSDictionary class]] && [responseObject valueForKey:UMComModelDataKey]) {
            weakSelf.feed.comments_count = @([weakSelf.feed.comments_count intValue]+1);
            if (completion) {
                completion([responseObject valueForKey:UMComModelDataKey], nil);
            }else{
                if (completion) {
                    completion(nil, error);
                }
            }
        }
        else{
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

- (void)replyCommentFeedWithComment:(UMComComment *)comment
                            content:(NSString *)content
                             images:(NSArray *)images
                         completion:(UMComDataRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] commentFeedWithFeedID:self.feed.feedID commentContent:content replyCommentID:comment.commentID replyUserID:comment.creator.uid commentCustomContent:nil images:images completion:^(NSDictionary *responseObject, NSError *error) {
        weakSelf.currentComment = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]] && [responseObject valueForKey:UMComModelDataKey]) {
                weakSelf.feed.comments_count = @([weakSelf.feed.comments_count intValue]+1);
                if (completion) {
                    completion([responseObject valueForKey:UMComModelDataKey], nil);
                }
            }else{
                if (completion) {
                    completion(nil, error);
                }
            }
    }];
}

- (void)deletedComment:(UMComComment *)comment completion:(UMComDataRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] commentDeleteWithCommentID:comment.commentID feedID:self.feed.feedID completion:^(NSDictionary *responseObject, NSError *error) {
        if (!error) {
            if ([weakSelf.feed.comments_count intValue] > 0) {
                weakSelf.feed.comments_count = @([weakSelf.feed.comments_count intValue]-1);
            }
            if (completion) {
                completion(responseObject, nil);
            }
        }else{
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

- (void)likeComment:(UMComComment *)comment completion:(UMComDataRequestCompletion)completion
{
    BOOL isLike = ![comment.liked boolValue];
    [[UMComDataRequestManager defaultManager] commentLikeWithCommentID:comment.commentID isLike:isLike completion:^(NSDictionary *responseObject, NSError *error) {
        NSInteger likeCount = [comment.likes_count integerValue];
        if (!error) {
            if (isLike) {
                comment.liked = @1;
                likeCount += 1;
            }else{
                comment.liked = @0;
                likeCount -= 1;
            }
            if (likeCount < 0) {
                likeCount = 0;
            }
            comment.likes_count = @(likeCount);
            if (completion) {
                completion(responseObject, nil);
            }
        }else{
            if (error.code == ERR_CODE_FEED_HAS_BEEN_LIKED) {
                comment.liked = @1;
                likeCount += 1;
            }else if (error.code == ERR_CODE_LIKE_HAS_BEEN_CANCELED){
                comment.liked = @0;
                likeCount -= 1;
            }
            if (likeCount < 0) {
                likeCount = 0;
            }
            comment.likes_count = @(likeCount);
            if (completion) {
                completion(nil, error);
            }
        }

    }];
}

- (void)spamComment:(UMComComment *)comment completion:(UMComDataRequestCompletion)completion
{
    [[UMComDataRequestManager defaultManager] commentSpamWithCommentID:comment.commentID completion:^(NSDictionary *responseObject, NSError *error) {
        if (!error) {
            if (completion) {
                completion(responseObject, nil);
            }
        }else{
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

- (void)spamUser:(UMComUser *)user completion:(UMComDataRequestCompletion)completion
{
    [[UMComDataRequestManager defaultManager] userSpamWitUID:user.uid completion:^(NSDictionary *responseObject, NSError *error) {
        if (!error) {
            if (completion) {
                completion(responseObject, nil);
            }
        }else{
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

#pragma mark - check 

- (BOOL)checkAuthDeleteFeed
{
    return ([self.feed.permission integerValue] >= 100);
}


/**
 *  判断当前用户是否有举报功能针对feed
 *
 *  @return YES 表示需要举报 NO表示不需要举报
 *  @note 如果用户feed是自己发的，就不需要出现举报按钮(自己举报自己没有意义).
 *        如果用户是全局管理员，也不需要出现举报按钮.(全局管理员可以直接删除，举报功能多余)
 *        如果用户是这个话题的管理员，也不需要举报按钮。
 */
- (BOOL) checkNeedReport
{
    //针对feed
    //如果是本人发布的就不需要举报
    NSString* temp_LogUid = [UMComSession sharedInstance].uid;
    NSString* temp_CreatorUid = self.feed.creator.uid;
    if (temp_LogUid && temp_CreatorUid && [temp_LogUid isEqualToString:temp_CreatorUid]) {
        return NO;
    }
    
    //如果当前是全局管理员
    NSNumber* typeNumber = @1;
    if(typeNumber && typeNumber.shortValue == 1)
    {
        return NO;
    }
    
    //此处简单的判断当前帖子的permission为100以上就认为有删除权限，不需要举报
    int permission = 0;
    permission = self.feed.permission.intValue;
    if (permission >= 100) {
        return NO;
    }
    
    return YES;
}

/**
 *  判断是否可以举报当前feed创建者
 *
 *  @return YES 表示需要举报 NO表示不需要举报
 *  @note 如果用户feed是自己发的，就不需要出现举报按钮(自己举报自己没有意义).其他情况都可以举报(包括全局管理员和话题管理员)
 */
- (BOOL)checkNeedReportCreatorWithFeed:(UMComFeed *)feed
{
    //针对feed
    //如果是本人发布的就不需要举报
    NSString* temp_LogUid = [UMComSession sharedInstance].uid;
    NSString* temp_CreatorUid = feed.creator.uid;
    if (temp_LogUid && temp_CreatorUid && [temp_LogUid isEqualToString:temp_CreatorUid]) {
        return NO;
    }
    return YES;
}

/**
 *  判断当前用户是否有举报功能针对评论
 *
 *  @return YES 表示需要举报 NO表示不需要举报
 *  @note 如果用户feed是自己发的，就不需要出现举报按钮(自己举报自己没有意义).
 *        如果用户是全局管理员，也不需要出现举报按钮.(全局管理员可以直接删除，举报功能多余)
 *        如果用户是这个话题的管理员，也不需要举报按钮。
 */
- (BOOL) checkNeedReportForCurComment:(UMComComment*)curComment
{
    
    //判断当前评论是否属于自己
    NSString* temp_LogUid = [UMComSession sharedInstance].uid;
    NSString* temp_CreatorUid = curComment.creator.uid;
    if (temp_LogUid && temp_CreatorUid && [temp_LogUid isEqualToString:temp_CreatorUid]) {
        return NO;
    }
    
    //判断当前是否全局管理员
    NSNumber* typeNumber = @1;
    if(typeNumber && typeNumber.shortValue == 1)
    {
        return NO;
    }
    
    if (!curComment) {
        return YES;
    }
    //此处简单的判断当前帖子的permission为100以上就认为有删除权限，不需要举报
    int permission = 0;
    permission = self.feed.permission.intValue;
    if (permission >= 100) {
        return NO;
    }
    return YES;
}

/**
 *  判断是否为html格式的feed
 *
 *  @return YES htmlFeed NO 普通feed
 */
-(BOOL) isHtmlData
{
    if (self.feed.media_type.intValue == 1 &&  self.feed.rich_text && self.feed.rich_text.length > 0) {
        return YES;
    }
    return NO;
}



@end
