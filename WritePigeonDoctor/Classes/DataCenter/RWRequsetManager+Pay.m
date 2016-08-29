//
//  RWRequsetManager+Pay.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/8/17.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWRequsetManager+Pay.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApiObject.h"
#import "WXApi.h"

#define WXID @"1381409402"

@implementation RWRequsetManager (Pay)

- (void)payOrder:(RWOrder *)order
{
    if (order.payMethot == RWPayMethotWXPay)
    {
        
    }
    else if (order.payMethot == RWPayMethotAlipay)
    {
        
    }
}

- (void)useAlipay:(NSString *)order
       fromScheme:(NSString *)scheme
         callback:(CompletionBlock)completionBlock
{
    [[AlipaySDK defaultService] payOrder:order
                              fromScheme:scheme
                                callback:^(NSDictionary *resultDic)
    {
    
    }];
}

- (void)useWeXiPayPrepayId:(NSString *)prepayId
                    package:(NSString *)package
                   nonceStr:(NSString *)nonceStr
                  timeStamp:(UInt32)timeStamp
                       sign:(NSString *)sign
{
    PayReq *payRequest = [[PayReq alloc] init];
    
    payRequest.partnerId = WXID;
    payRequest.prepayId = prepayId;
    payRequest.package = package;
    payRequest.nonceStr = nonceStr;
    payRequest.timeStamp = timeStamp;
    payRequest.sign = sign;
    
    [WXApi sendReq:payRequest];
}

- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[PayResp class]])
    {
        PayResp *response=(PayResp *)resp;
        
        switch(response.errCode)
        {
            case WXSuccess:
                
                break;
            default:
                
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                break;
        }
    }
}

@end
