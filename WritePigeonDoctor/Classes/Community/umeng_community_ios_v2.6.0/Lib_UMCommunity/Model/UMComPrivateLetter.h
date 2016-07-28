//
//  UMComPrivateLetter.h
//  UMCommunity
//
//  Created by umeng on 15/12/1.
//  Copyright © 2015年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UMComModelObject.h"

@class UMComPrivateMessage, UMComUser;


@interface UMComPrivateLetter : UMComModelObject


/**
 私信唯一ID
 */
@property (nullable, nonatomic, retain) NSString *letter_id;
/**
 上一次更新时间
 */
@property (nullable, nonatomic, retain) NSString *update_time;
/**
 未读聊天记录个数
 */
@property (nullable, nonatomic, retain) NSNumber *unread_count;
/**
 私信互动的用户
 */
@property (nullable, nonatomic, retain) UMComUser *user;
/**
 最近一条私信聊天记录
 */
@property (nullable, nonatomic, retain) UMComPrivateMessage *last_message;
/**
 私信聊天记录列表(进入下一页的数据，本页协议是没有的)
 */
//@property (nullable, nonatomic, retain) NSArray<UMComPrivateMessage *> *message_records;



// Insert code here to declare functionality of your managed object subclass

/**
 通过私信id获取到本地 UMComPrivateLetter 对象的方法，如果本地没有， 则会新建一个
 
 @param letter_id 私信id
 
 */
+ (UMComPrivateLetter *)objectWithObjectId:(NSString *)letter_id;


@end
