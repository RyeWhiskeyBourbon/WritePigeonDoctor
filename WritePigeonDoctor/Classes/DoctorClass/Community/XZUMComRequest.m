//
//  XZUMComRequest.m
//  WritePigeonDoctor
//
//  Created by ZYJY on 16/8/1.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "XZUMComRequest.h"

#define Manager [UMComDataRequestManager defaultManager]

@implementation XZUMComRequest

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
                            completion:(UMComRequestCompletion)completion
{
   [Manager userCustomAccountLoginWithName:name sourceId:sourceId icon_url:icon_url gender:gender age:age custom:custom score:score levelTitle:levelTitle level:level contextDictionary:context userNameType:userNameType userNameLength:userNameLength completion:^(NSDictionary *responseObject, NSError *error) {
       completion(responseObject,error);
   }];
}

/**
 用户普通登录方式
 @param name 用户名 (必选， 但是只有第一次登录有效)
 @param sourceType 平台类型（必选）
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
+ (void)userLoginWithName:(NSString *)name
                   source:(UMComSnsType)sourceType
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
               completion:(UMComRequestCompletion)completion
{
   [Manager userLoginWithName:name source:sourceType sourceId:sourceId icon_url:icon_url gender:gender age:age custom:custom score:score levelTitle:levelTitle level:level contextDictionary:context userNameType:userNameType userNameLength:userNameLength completion:^(NSDictionary *responseObject, NSError *error) {
      completion(responseObject,error);
   }];
}
+ (void)fecthUserProfileWithUid:(NSString *)uid
                         source:(NSString *)source
                     source_uid:(NSString *)source_uid
                     completion:(UMComRequestCompletion)completion
{
   [Manager fecthUserProfileWithUid:uid source:source source_uid:source_uid completion:^(NSDictionary *responseObject, NSError *error) {
       completion(responseObject,error);
   }];
}

+ (void)userFollowWithUserID:(NSString *)uid
                    isFollow:(BOOL)isFollow
                  completion:(UMComRequestCompletion)completion
{
    [Manager userFollowWithUserID:uid isFollow:isFollow completion:^(NSDictionary *responseObject, NSError *error) {
        completion(responseObject,error);
    }];
}

@end
