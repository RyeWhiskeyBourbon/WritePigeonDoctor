//
//  UMComRelatedIDTableType.h
//  UMCommunity
//
//  Created by 张军华 on 16/6/15.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#ifndef _UMComRelatedIDTableType_
#define _UMComRelatedIDTableType_

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, UMComRelatedIDTableType) {
    
    UMComRelatedRecommendNone,
    //feed流
    UMComRelatedRealTimeFeedID, //UMComRequestType_RealTimeFeed //最新
    UMComRelatedRealTimeHotFeedID, //UMComRequestType_RealTimeHotFeed //最热
    UMComRelatedRecommendFeedID,//推荐
    
    //user流
    UMComRelatedRegisterUserID,//注册用户的相关列表
    //用于测试的
    UMComRelatedImageUrlFeedID,
};

#endif

//@interface UMComRelatedIDTableType : NSObject
//
//@end
