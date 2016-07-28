//
//  UMComPrivateMessage.h
//  UMCommunity
//
//  Created by umeng on 15/12/1.
//  Copyright © 2015年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UMComModelObject.h"

@class UMComPrivateLetter, UMComUser;


@interface UMComPrivateMessage : UMComModelObject


/**
 私信聊天记录唯一ID
 */
@property (nullable, nonatomic, retain) NSString *message_id;
/**
 私信聊天内容
 */
@property (nullable, nonatomic, retain) NSString *content;
/**
 私信聊天时间
 */
@property (nullable, nonatomic, retain) NSString *create_time;
/**
 私信聊天对象（用户）
 */
@property (nullable, nonatomic, retain) UMComUser *creator;

/**
 聊天所在的私信(上一页的对象)
 */
//@property (nullable, nonatomic, retain) UMComPrivateLetter *private_letter;
@property (nullable, nonatomic, retain) NSString *letter_id;


// Insert code here to declare functionality of your managed object subclass

/**
 通过聊天记录id获取到本地 UMComPrivateMessage 对象的方法，如果本地没有， 则会新建一个
 
 @param message_id 聊天记录id
 
 */
+ (UMComPrivateMessage *)objectWithObjectId:(NSString *)message_id;

@end

