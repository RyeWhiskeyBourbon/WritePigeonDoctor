//
//  AppDelegate+Alipay.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/8/17.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "AppDelegate+Alipay.h"
#import <AlipaySDK/AlipaySDK.h>

@implementation AppDelegate (Alipay)

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"])
    {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic)
        {
            NSLog(@"result = %@",resultDic);
        }];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"])
    {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    return YES;
}

@end
