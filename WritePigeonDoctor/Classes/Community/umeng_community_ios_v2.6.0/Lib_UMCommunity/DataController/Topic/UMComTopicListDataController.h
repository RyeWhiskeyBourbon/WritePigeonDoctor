//
//  UMComTopicListDataController.h
//  UMCommunity
//
//  Created by umeng on 16/5/5.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComListDataController.h"

@class UMComTopic;
@interface UMComTopicListDataController : UMComListDataController

- (void)focusedTopic:(UMComTopic *)topic completion:(UMComDataRequestCompletion)completion;

//- (void)focusedTopic:(UMComTopic *)topic completion:(UMComDataRequestCompletion)completion;


@end

/**
 *全部话题列表
 */
@interface UMComTopicsAllDataController : UMComTopicListDataController

@end

/**
 *推荐话题列表
 */
@interface UMComTopicsRecommendDataController : UMComTopicListDataController

@end

/**
 *我关注的话题列表
 */
@interface UMComTopicsFocusDataController : UMComTopicListDataController

@end

/**
 *话题组下的话题列表
 */
@interface UMComGroupTopicDataController : UMComTopicListDataController

@end



