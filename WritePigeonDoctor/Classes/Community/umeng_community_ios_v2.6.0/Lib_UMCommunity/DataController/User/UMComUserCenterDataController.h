//
//  UMComUserCenterDataController.h
//  UMCommunity
//
//  Created by umeng on 16/5/4.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMComDataRequestManager.h"

@interface UMComUserCenterDataController : NSObject

//- (void)getOneUserWithUid:(NSString *)uid completion:(UMComDataRequestCompletion)completion;


/**
 *  获得用户的基本信息
 *
 *  @param uid        uid
 *  @param source     source
 *  @param source_uid source_uid
 *  @param completion 回调
 */
+ (void)fecthUserProfileWithUid:(NSString *)uid
                         source:(NSString *)source
                     source_uid:(NSString *)source_uid
                     completion:(UMComDataRequestCompletion)completion;

@end
