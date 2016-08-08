//
//  UMComHttpClient.h
//  UMCommunity
//
//  Created by luyiyuan on 14/8/27.
//  Copyright (c) 2014年 luyiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "UMBaseNetwork.h"
#import "UMComTools.h"

typedef NS_ENUM(NSInteger, UMComHttpErrorCode)
{
    UMComHttpErrorCodeUnknown,
    UMComHttpErrorFromServer,
    UMComHttpErrorCodeNotGetFirtPage,
    UMComHttpErrorCodeParamError,
};

@interface UMComHttpClient : NSObject

+ (instancetype)sharedInstance;

//request by absolute URL
+ (void)requestWithMethod:(UMComHttpMethodType)method
             absolutePath:(NSString *)absolutePath
                  headers:(NSDictionary *)headers
                 response:(UMComHttpRequestCompletion)response;

//request
+ (void)requestWithMethod:(UMComHttpMethodType)method
                     path:(NSString *)path
           pathParameters:(NSDictionary *)pathParameters
           bodyParameters:(NSDictionary *)bodyParameters
                  headers:(NSDictionary *)headers
                 response:(UMComHttpRequestCompletion)response;
//同步请求
+ (void)synRequestWithMethod:(UMComHttpMethodType)method
                        path:(NSString *)path
              pathParameters:(NSDictionary *)pathParameters
              bodyParameters:(NSDictionary *)bodyParameters
                     headers:(NSDictionary *)headers
                    response:(UMComHttpRequestCompletion)response;

+ (NSError *)errorWithDomain:(NSString *)errorDomain
                        code:(UMComHttpErrorCode)code
                      reason:(NSString *)reason;


//+ (BOOL)dealResponseData:(id)data error:(NSError *)error completion:(LoadResponseCompletion)completion;

- (void)relaunchCachedRequest;

@end
