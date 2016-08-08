//
//  UMComFeedDetailDataController.h
//  UMCommunity
//
//  Created by umeng on 16/5/3.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMComDataRequestManager.h"

@class UMComUser, UMComFeed, UMComComment;

@interface UMComFeedDetailDataController : NSObject


/**
 *Feed
 */
@property (nonatomic, strong) UMComFeed *feed;

/***
 *被回复的用户
 */
@property (nonatomic, strong) UMComUser *replyUser;

/***
 *当前评论
 */
@property (nonatomic, strong) UMComComment *currentComment;

- (void)refreshFeedWithCompletion:(UMComDataRequestCompletion)completion;

- (void)deletedFeedWithCompletion:(UMComDataRequestCompletion)completion;

- (void)likeFeedWithCompletion:(UMComDataRequestCompletion)completion;

- (void)spamFeedWithCompletion:(UMComDataRequestCompletion)completion;

- (void)favoriteFeedWithCompletion:(UMComDataRequestCompletion)completion;

- (void)commentFeedWithContent:(NSString *)content
                        images:(NSArray *)images
                    completion:(UMComDataRequestCompletion)completion;


- (void)replyCommentFeedWithComment:(UMComComment *)comment
                            content:(NSString *)content
                             images:(NSArray *)images
                         completion:(UMComDataRequestCompletion)completion;

- (void)deletedComment:(UMComComment *)comment completion:(UMComDataRequestCompletion)completion;

- (void)likeComment:(UMComComment *)comment completion:(UMComDataRequestCompletion)completion;

- (void)spamComment:(UMComComment *)comment completion:(UMComDataRequestCompletion)completion;

- (void)spamUser:(UMComUser *)user completion:(UMComDataRequestCompletion)completion;



#pragma mark - check

- (BOOL)checkAuthDeleteFeed;
/**
 *  判断当前用户是否有举报功能针对feed
 *
 *  @return YES 表示需要举报 NO表示不需要举报
 *  @note 如果用户feed是自己发的，就不需要出现举报按钮(自己举报自己没有意义).
 *        如果用户是全局管理员，也不需要出现举报按钮.(全局管理员可以直接删除，举报功能多余)
 *        如果用户是这个话题的管理员，也不需要举报按钮。
 */
- (BOOL) checkNeedReport;

/**
 *  判断是否可以举报当前feed创建者
 *
 *  @return YES 表示需要举报 NO表示不需要举报
 *  @note 如果用户feed是自己发的，就不需要出现举报按钮(自己举报自己没有意义).其他情况都可以举报(包括全局管理员和话题管理员)
 */
- (BOOL)checkNeedReportCreatorWithFeed:(UMComFeed *)feed;

/**
 *  判断当前用户是否有举报功能针对评论
 *
 *  @return YES 表示需要举报 NO表示不需要举报
 *  @note 如果用户feed是自己发的，就不需要出现举报按钮(自己举报自己没有意义).
 *        如果用户是全局管理员，也不需要出现举报按钮.(全局管理员可以直接删除，举报功能多余)
 *        如果用户是这个话题的管理员，也不需要举报按钮。
 */
- (BOOL) checkNeedReportForCurComment:(UMComComment*)curComment;

/**
 *  判断是否为html格式的feed
 *
 *  @return YES htmlFeed NO 普通feed
 */
-(BOOL) isHtmlData;
@end
