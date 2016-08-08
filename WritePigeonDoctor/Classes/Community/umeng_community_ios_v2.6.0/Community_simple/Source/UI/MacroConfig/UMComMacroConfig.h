//
//  UMComMacroConfig.h
//  UMCommunity
//
//  Created by 张军华 on 16/5/24.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, UMComTopFeedType)
{
    UMComTopFeedType_None,
    UMComTopFeedType_GloalTopFeed,              //全局置顶,取feed对象的is_top字段
    UMComTopFeedType_TopicTopFeed,              //话题置顶，取feed对象的is_topic_top字段来判断
    UMComTopFeedType_GloalTopAndTopicTopFeed,   //全局和话题都置顶才会置顶,取feed对象的is_top&is_topic_top字段同时满足
    UMComTopFeedType_GloalTopOrTopicTopFeed,   //全局和话题其中一个置顶,取feed对象的is_top或is_topic_top字段只要一个满足就置顶
};


//通过UI发送网络请求,回调后的本地生成Dictionary中获得数据的key
#define UMComModelDataKey @"data"
#define UMComModelDataNextPageUrlKey @"next_page_url"
#define UMComModelDataVisitKey @"visit"



//点赞feed,回调后的本地生成Dictionary中获得数据的key
#define UMComModelFeedLikeKey @"feedLiked"
#define UMComModelLikedFeedIDKey @"likedFeedID"


//网络数据解析成json字典的key
#define UMComJsonVisitKey @"visit"
#define UMComJsonNextPageUrlKey @"navigator"
#define UMComJsonItemsKey @"items"

#define UMComJsonTopItemsKey @"top_items"
#define UMComJsonTopicTopItemsKey @"topic_top_items"
