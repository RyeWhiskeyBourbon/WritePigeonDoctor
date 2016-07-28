//
//  UMComLoginManager.h
//  UMCommunity
//
//  Created by Gavin Ye on 8/25/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMComLoginDelegate.h"
#import "UMComUser.h"


@interface UMComLoginManager : NSObject


/********************UMComFirstTimeHandelerDelegate*******************/

+ (UMComLoginManager *)shareInstance;

/**
 得到登录SDK实现对象
 
 */
+ (id<UMComLoginDelegate>)getLoginHandler;

/**
 设置登录SDK实现对象
 
 */
+ (void)setLoginHandler:(id <UMComLoginDelegate>)loginHandler;


/**
 提供社区SDK调用，默认使用友盟登录SDK，或者自定义的第三方登录SDK，实现登录功能
 
 */
+ (void)performLogin:(UIViewController *)viewController completion:(void (^)(id responseObject, NSError *error))completion;


/**
 用户注销方法
 
 @warning 调用这个方法退出登录同时会清空数据库（在没登陆的情况下慎重调用）
 */
+ (void)userLogout;

@end



