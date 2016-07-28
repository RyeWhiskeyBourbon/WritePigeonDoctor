//
//  UMCommunity.h
//  UMCommunity
//
//  Created by luyiyuan on 14/10/11.
//  Copyright (c) 2014年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UMComLoginManager.h"

/**
 友盟微社区总体控制类
 
 */
@interface UMCommunity : NSObject

/**
 设置appkey、appSecret
 
 @param appkey 应用appkey
 @param appSecret 应用appSecret
 
 */
+ (void)setAppKey:(NSString *)appkey withAppSecret:(NSString *)appSecret;


/**
 得到一个消息流页面的普通UIViewController对象
  **此UIViewController没有navigationController,为了正常显示页面需要设置它的navigationController活着通过navigationController直接push进入这个ViewController**
 
 @returns 消息流页面
 */
+ (UIViewController *)getFeedsViewController;

/**
 得到一个消息流页面的模态窗口对象
 
 @returns 消息流页面
 */
+ (UINavigationController *)getFeedsModalViewController;


@end
