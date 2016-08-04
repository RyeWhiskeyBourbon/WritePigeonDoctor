//
//  XZUMComPullRequest.h
//  WritePigeonDoctor
//
//  Created by ZYJY on 16/8/2.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMComDataRequestManager.h"
@interface XZUMComPullRequest : NSObject


/**
 开发者自有账号登录
 
 @param name 用户名 (必选， 但是只有第一次登录有效)
 @param sourceId 平台用户ID（必选）
 @param icon_url 用户头像地址(可选， 只有第一次登录有效)
 @param gender 性别(可选， 只有第一次登录有效)
 @param age 年龄(可选， 只有第一次登录有效)
 @param custom 自定义字段(可选， 只有第一次登录有效)
 @param score 积分(可选， 只有第一次登录有效)
 @param levelTitle 等级title (可选， 只有第一次登录有效)
 @param level 等级(可选， 只有第一次登录有效)
 @param userNameType 用户名规则类型
 @param userNameLength 用户名长度类型
 @param completion 返回结果, responseObject是`UMComUser`对象,即登录成功之后返回的登录用户
 */
+ (void)userCustomAccountLoginWithName:(NSString *)name
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
                            completion:(UMComRequestCompletion)completion;



/**
 关注用户或者取消关注
 
 @param uid 用户的id
 @param isFollow 关注用户或者取消关注
 @param completion 结果
 */
+ (void)userFollowWithUserID:(NSString *)uid
                    isFollow:(BOOL)isFollow
                  completion:(UMComRequestCompletion)completion;

/**

@param uid 友盟账号系统的用户ID,对应的是`UMComUser`的属性uid
@param sourceUids  @"source":@"self_account" @"source_uid":自己平台UID;self_account自己的平台，source_uid自己平台UID
@returns 获取用户详细信息请求对象
 
*/

+ (void)fecthUserProfileWithUid:(NSString *)uid
                         source:(NSString *)source
                     source_uid:(NSString *)source_uid
                     completion:(UMComRequestCompletion)completion;


@end