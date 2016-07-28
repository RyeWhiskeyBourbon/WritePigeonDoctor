//
//  UMComTopicGroupDataController.m
//  UMCommunity
//
//  Created by umeng on 16/5/5.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComTopicGroupDataController.h"
#import "UMComTopicType.h"

@implementation UMComTopicGroupDataController

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_TopicGroups count:count];
    if (self) {
        
    }
    return self;
}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    
}

- (void)fecthLocalDataWithCompletion:(UMComDataListRequestCompletion)completion
{
    
}

- (void)loadNextPageDataWithCompletion:(UMComDataListRequestCompletion)completion
{
    
}

- (void)fecthDataWithCompletion:(UMComDataListRequestCompletion)localFecthcompletion serverDataCompletion:(UMComDataListRequestCompletion)serverRequestCompletion
{
    
}


@end
