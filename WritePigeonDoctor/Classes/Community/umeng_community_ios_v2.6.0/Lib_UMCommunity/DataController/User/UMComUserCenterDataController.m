//
//  UMComUserCenterDataController.m
//  UMCommunity
//
//  Created by umeng on 16/5/4.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComUserCenterDataController.h"
#import "UMComDataRequestManager.h"
#import "UMComMacroConfig.h"

@implementation UMComUserCenterDataController


+ (void)fecthUserProfileWithUid:(NSString *)uid
                         source:(NSString *)source
                     source_uid:(NSString *)source_uid
                     completion:(UMComDataRequestCompletion)completion
{
    
    [[UMComDataRequestManager defaultManager] fecthUserProfileWithUid:uid source:source source_uid:source_uid completion:^(NSDictionary *responseObject, NSError *error) {
        
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]] && !error) {
           id user  =  [responseObject valueForKey:UMComModelDataKey];
            if (completion) {
                completion(user,nil);
                return;
            }
        }
        
        if (completion) {
            completion(responseObject,error);
        }
    }];
}

@end
