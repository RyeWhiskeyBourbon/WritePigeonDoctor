//
//  UMComNoticeListDataController.m
//  UMCommunity
//
//  Created by umeng on 16/5/17.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComNoticeListDataController.h"
#import "UMComMacroConfig.h"

@implementation UMComNoticeListDataController

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_CommunityNotification count:count];
    if (self) {
        
    }
    return self;
}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] fecthMyNotificationWithCount:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakSelf handleNewData:responseObject error:error completion:completion];
    }];
}


@end
