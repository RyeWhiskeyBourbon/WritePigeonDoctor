//
//  UMComNetworkConfig.h
//  UMCommunity
//
//  Created by 张军华 on 16/4/13.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  网络地址的基地址的配置文件(用于区分上线和测试服务器)
 */

//定义测试的服务器的宏
//#define UM_COM_TEST_SERVER

//请求服务器的基地址
extern NSString *const UMBaseApiPath;

//阿里百川上传图片的地址
extern NSString* const ABCBaseApiPath;
