//
//  UMComSession.h
//  UMCommunity
//
//  Created by Gavin Ye on 9/11/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *注册消息推送的别名
 */
extern NSString * kNSAliasKey;
extern NSString *UMComTokenKey;

@class UMComUser;
@class UMComUnReadNoticeModel;

@interface UMComSession : NSObject

@property (nonatomic, strong, readwrite) NSString *token;

@property (nonatomic, readonly) NSString *uid;

@property (nonatomic, readonly) NSString *source_uid;

@property (nonatomic, readonly) NSString *source;

@property (nonatomic, readonly) NSString *appkey;

@property (nonatomic, readonly) NSString *appSecret;

@property (nonatomic, readonly) NSDictionary *baseHeader;

@property (nonatomic, assign) BOOL isShowTopicName;

@property (nonatomic, readonly) BOOL isLogin;

@property (nonatomic, strong) UMComUser *loginUser;

/**
 *  当前的社区是否为访客模式
 *  (0:没有开通访客模式，1:开通访客模式)
 */
@property (nonatomic,assign) NSInteger communityGuestMode;

/**
 unReadNoticeModel 表示未读消息数据模型（这个值需要在友盟微社区后台设置，社区初始化的时候自动获取或收到消息远程通知会自动获取）
 
 */
@property (nonatomic, strong, readonly) UMComUnReadNoticeModel *unReadNoticeModel;


/**
 maxFeedLength 表示Feed内容的最大长度， 默认为300（这个值需要在友盟微社区后台设置，社区初始化的时候自动获取）
 
 */
@property (nonatomic, assign, readonly) NSInteger maxFeedLength;

/**
 imageUploadServerType表示要将图片上传到的服务器类型，默认值为0表示上传到阿里云百川服务器,1表示上传到友盟微社区服务器，2表示开发者自己的服务器（这些值可根据需要在友盟微社区后台设置，社区初始化的时候自动获取）
 @warning 如果设置值为2，则图片上传功能和逻辑需要开发者自己实现，开发者自己上传成功之后在将图片url上传到友盟微社区即可。
 
 */
@property (nonatomic, assign, readonly) NSInteger imageUploadServerType;

/**
 comment_length 表示Feed评论的最大长度， 默认为300（这个值需要在友盟微社区后台设置，社区初始化的时候自动获取）
 
 */
@property (nonatomic, assign, readonly) NSInteger comment_length;

@property (nonatomic, copy) NSString *host;

- (NSMutableDictionary *)basePathDictionary;

+ (UMComSession *)sharedInstance;

/**
 * 设置appkey和appSecret
 *
 * @param appKey 微社区appKey
 * @param appSecret 微社区appSecret
 */
- (void)setAppkey:(NSString *)appkey withAppSecret:(NSString *)appSecret;

/**
 设置打开Log
 
 @param isLog 是否打开Log
 */
+ (void)openLog:(BOOL)isLog;

/**
 用户注销 
 
 @warning 调用这个方法退出登录同时会清空数据库（调用不要过于频繁）
 */
- (void)userLogout;


- (void)setCommunityInitConfigDataWithDict:(NSDictionary *)configDataDict;


/**
 判断用户是否具有删除的权限
 
 @return 如果具备删除的权限则返回YES，否者返回NO
 */
- (BOOL)isPermissionDelete;


/**
 判断用户是否具有发公告的权限
 
 @return 如果具备发公告的权限则返回YES，否者返回NO
 */
- (BOOL)isPermissionBulletin;

/**
 更新token
 
 */
- (void)refreshAccessToken;

@end

