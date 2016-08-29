//
//  RWRequsetManager+UserLogin.h
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/10.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWRequsetManager.h"

typedef NS_ENUM(long long,RWGender)
{
    RWGenderIsMan = 1,
    RWGenderIsWoman = 0
};

RWGender getGenderIdentifier(NSString *gender);

/**
 *  回调 RWRequsetDelegate
 */

@interface RWRequsetManager (UserLogin)
/**
 *  新用户注册
 *
 *  @param username 用户名
 *  @param password 密码
 */
- (void)registerWithUsername:(NSString *)username AndPassword:(NSString *)password verificationCode:(NSString *)verificationCode;
/**
 *  设置用户信息
 *
 *  @param header 头像
 *  @param name   昵称
 *  @param age    年龄
 *  @param sex    性别
 *  @param completion  完成 返回上传和本地保存结果
 */
- (void)setUserHeader:(UIImage *)header
                 name:(NSString *)name
                  age:(NSString *)age
                  sex:(NSString *)sex
           completion:(void(^)(BOOL success,NSString *errorReason))completion;
/**
 *  用户登录
 *
 *  @param username 用户名
 *  @param password 密码
 */
- (void)userinfoWithUsername:(NSString *)username AndPassword:(NSString *)password;
/**
 *  退出登录
 *
 *  @param complete 
 */
+ (void)userLogout:(void(^)(BOOL success))complete;
/**
 *  重置密码
 *
 *  @param username 用户名
 *  @param password 密码
 */
- (void)replacePasswordWithUsername:(NSString *)username AndPassword:(NSString *)password verificationCode:(NSString *)verificationCode;
/**
 *  获取验证码
 *
 *  @param phoneNumber
 *  @param result      
 */
- (void)obtainVerificationWithPhoneNunber:(NSString *)phoneNumber result:(void(^)(BOOL succeed,NSString *reason))result;
/**
 *  验证手机号是否符合
 *
 *  @param phoneNumber 手机号
 *
 *  @return
 */
- (BOOL)verificationPhoneNumber:(NSString *)phoneNumber;
/**
 *  验证密码是否符合标准
 *
 *  @param password 密码
 *
 *  @return
 */
- (BOOL)verificationPassword:(NSString *)password;
/**
 *  验证邮箱是否符合标准
 *
 *  @param Email 邮箱
 *
 *  @return 
 */
- (BOOL)verificationEmail:(NSString *)Email;

- (BOOL)verificationAge:(NSString *)age;

@end

