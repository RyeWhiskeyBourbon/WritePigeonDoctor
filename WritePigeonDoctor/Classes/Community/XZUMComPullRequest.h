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

/**
 检查用户名合法接口
 
 @param name           用户名
 @param userNameType   用户名规范，`userNameNoBlank`没有空格，`userNameNoRestrict`没有限制
 @param userNameLength 用户名长度，`userNameLengthDefault`默认长度，`userNameLengthNoRestrict`没有长度限制
 @param completion         error的code :
 10010 户名长度错误
 10012 用户名敏感
 10016  用户名格式错误
 */
+ (void)checkUserName:(NSString *)name
         userNameType:(UMComUserNameType)userNameType
       userNameLength:(UMComUserNameLength)userNameLength
           completion:(UMComRequestCompletion)completion;
/**
 更新登录用户数据
 
 @param userAccount 用户参数Model
 @param userNameType 用户名规则类型
 @param userNameLength 用户名长度类型
 @param completion 返回结果
 */
+ (void)updateProfileWithName:(NSString *)name
                          age:(NSNumber *)age
                       gender:(NSNumber *)gender
                       custom:(NSString *)custom
                 userNameType:(UMComUserNameType)userNameType
               userNameLength:(UMComUserNameLength)userNameLength
                   completion:(UMComRequestCompletion)completion;
/**
 更新用户头像
 
 @param image 可以是NSString（图片的url）类型,也可以是UIImage(直接传图片)
 @param completion 返回结果
 */
+ (void)userUpdateAvatarWithImage:(id)image
                       completion:(UMComRequestCompletion)completion;

//获取某个用户关注的人的列表
+ (void)fecthUserFollowingsWithUid:(NSString *)uid
                             count:(NSInteger)count
                        completion:(UMComRequestCompletion)completion;

@end
