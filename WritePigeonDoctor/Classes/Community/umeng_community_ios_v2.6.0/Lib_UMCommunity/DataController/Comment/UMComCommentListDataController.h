//
//  UMComCommentListDataController.h
//  UMCommunity
//
//  Created by umeng on 16/5/18.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComListDataController.h"
#import "UMComTools.h"

@interface UMComCommentListDataController : UMComListDataController

@end


@interface UMComFeedCommnetListDataController : UMComCommentListDataController

@property (nonatomic, assign)UMComCommentListSortType commentSortType;

@property (nonatomic, copy)NSString *replyUserId;

@property (nonatomic, copy) NSString *feedID;

- (instancetype)initWithCount:(NSInteger)count feedID:(NSString *)feedId replyUserID:(NSString *)replyUserId commentSortType:(UMComCommentListSortType)commentSorttype;

@end


@interface UMComUserReceivedCommentListDataController : UMComCommentListDataController

@property (nonatomic, assign)UMComCommentListSortType commentSortType;

@property (nonatomic, copy)NSString *replyUserId;

@property (nonatomic, copy) NSString *feedID;

- (instancetype)initWithCount:(NSInteger)count feedID:(NSString *)feedId replyUserID:(NSString *)replyUserId commentSortType:(UMComCommentListSortType)commentSorttype;

@end


@interface UMComUserSentCommentListDataController : UMComCommentListDataController

@property (nonatomic, assign)UMComCommentListSortType commentSortType;

@property (nonatomic, copy)NSString *replyUserId;

@property (nonatomic, copy) NSString *feedID;

- (instancetype)initWithCount:(NSInteger)count feedID:(NSString *)feedId replyUserID:(NSString *)replyUserId commentSortType:(UMComCommentListSortType)commentSorttype;

@end

