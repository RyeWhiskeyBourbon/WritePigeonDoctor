//
//  UMComKit.m
//  UMCommunity
//
//  Created by wyq.Cloudayc on 5/12/16.
//  Copyright © 2016 Umeng. All rights reserved.
//

#import "UMComKit.h"

@implementation UMComKit

+ (instancetype)sharedInstance
{
    static UMComKit *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UMComKit alloc] init];
    });
    return instance;
}

@end
