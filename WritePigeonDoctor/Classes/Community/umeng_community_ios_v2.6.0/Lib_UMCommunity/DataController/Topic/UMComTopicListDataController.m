//
//  UMComTopicListDataController.m
//  UMCommunity
//
//  Created by umeng on 16/5/5.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComTopicListDataController.h"
#import "UMComTools.h"
#import "UMComTopic.h"
#import "UMComMacroConfig.h"

@interface UMComTopicListDataController ()

@end

@implementation UMComTopicListDataController

- (void)focusedTopic:(UMComTopic *)topic completion:(UMComDataRequestCompletion)completion
{

}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{

}

- (void)fecthLocalDataWithCompletion:(UMComDataListRequestCompletion)completion
{

}
//
//- (void)loadNextPageDataWithCompletion:(UMComDataListRequestCompletion)completion
//{
//
//}

- (void)fecthDataWithCompletion:(UMComDataListRequestCompletion)localFecthcompletion serverDataCompletion:(UMComDataListRequestCompletion)serverRequestCompletion
{

}

@end


/**
 *全部话题列表
 */
@implementation UMComTopicsAllDataController

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_AllTopic count:count];
    if (self) {
        
    }
    return self;
}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakself  = self;
    [[UMComDataRequestManager defaultManager] fecthTopicsAllWithCount:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        if (error)
        {
            completion(nil,error);
        }
        else
        {
            if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
               weakself.nextPageUrl = [responseObject valueForKey:UMComModelDataNextPageUrlKey];
               NSNumber* visit =  [responseObject valueForKey:UMComModelDataVisitKey];
               if(visit.integerValue == 0){
                   weakself.canVisitNextPage = NO;
               }
               else if(visit.integerValue == 1){
                   weakself.canVisitNextPage = YES;
               }
               else{
                   weakself.canVisitNextPage = YES;
               }
              
               NSArray* topicArray = [responseObject valueForKey:UMComModelDataKey];
               if (topicArray && [topicArray isKindOfClass:[NSArray class]]) {
                   self.dataArray = [NSMutableArray arrayWithArray:topicArray];
                   completion(self.dataArray,nil);
               }
            }
        }
    }];
}


@end

/**
 *推荐话题列表
 */
@implementation UMComTopicsRecommendDataController

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_RecommendTopic count:count];
    if (self) {
        
    }
    return self;
}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    
}

@end

/**
 *我关注的话题列表
 */
@implementation UMComTopicsFocusDataController

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_FocusedTopic count:count];
    if (self) {
        
    }
    return self;
}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    
}

@end

/**
 *话题组下的话题列表
 */
@implementation UMComGroupTopicDataController

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_GroupsTopic count:count];
    if (self) {
        
    }
    return self;
}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    
}

@end


