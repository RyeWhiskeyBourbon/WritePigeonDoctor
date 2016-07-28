//
//  UMComDataBaseManager.h
//  UMCommunity
//
//  Created by 张军华 on 16/5/16.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMComRelatedIDTableType.h"

@class UMComModelObject,UMComFeed, UMComUser,UMComTopic,UMComMedal,UMComImageUrl,UMComTopicType,UMComComment,UMComAlbum,UMComLike,UMComNotification,UMComPrivateMessage,UMComPrivateLetter;

@interface UMComDataBaseManager : NSObject


+(instancetype)shareManager;

#pragma mark -reset数据库

-(void) resetDataBase;

#pragma mark - 单独储存对象
/**
 *  存储一组继承UMComModelObject
 *
 *  @param umComModelObjects 包含继承UMComModelObject的数组
 *  @discuss 只是存储一组继承UMComModelObject的对象
 */
-(void)saveUMComModelObjects:(NSArray*)umComModelObjects;

-(void)saveUMComFeed:(UMComFeed*)feed;
-(void)saveUMComUser:(UMComUser*)user;
-(void)saveUMComTopic:(UMComTopic*)topic;
-(void)saveUMComTopicType:(UMComTopicType*)topicType;
-(void)saveUMComMedal:(UMComMedal*)medal;
-(void)saveUMComImageUrl:(UMComImageUrl*)imageUrl;
-(void)saveUMComComment:(UMComComment*)comment;
-(void)saveUMComAlbum:(UMComAlbum*)album;
-(void)saveUMComLike:(UMComLike*)like;
-(void)saveUMComNotification:(UMComNotification*)notification;
-(void)saveUMComPrivateMessage:(UMComPrivateMessage*)privateMessage;
-(void)saveUMComPrivateLetter:(UMComPrivateLetter*)privateLetter;




#pragma mark - 储存对象和对象关联的relation表
/**
 *  存储相关的feed array 和对应feedID的relation表
 *
 *  @param type  @see UMComRelatedIDTableType
 *  @param feeds feed对象 @see UMComFeed
 */
-(void)saveRelatedIDTableWithType:(UMComRelatedIDTableType)type withFeeds:(NSArray*)feeds;

-(void)saveRelatedIDTableWithType:(UMComRelatedIDTableType)type withUsers:(NSArray*)users;

//存储相关id的type的ID(比如：推荐界面)
-(void)saveRelatedIDTableWithType:(UMComRelatedIDTableType)type withValues:(NSArray*)values;


#pragma mark - fetch对象通过对象关联的relation表
/**
 *  获取关联type的数据库的feed数据
 *
 *  @param type @see UMComRelatedIDTableType
 *
 *  @return 返回包含UMComFeed的数组
 */
-(id)fetchSyncUMComFeedWithType:(UMComRelatedIDTableType)type;
-(void)fetchASyncUMComFeedWithType:(UMComRelatedIDTableType)type withCompleteBlock:(void(^)(id,NSError*))completeBlock;


/**
 *  获得关联type的数据的user的数据
 *
 *  @param type @see UMComRelatedIDTableType
 *
 *  @return 返回包含UMComUser的数组
 */
-(id)fetchSyncUMComUserWithType:(UMComRelatedIDTableType)type;
-(void)fetchASyncUMComUserWithType:(UMComRelatedIDTableType)type withCompleteBlock:(void(^)(id,NSError*))completeBlock;


#pragma mark - 通用的保存和fetch对象的，通过relation表
/********************************************/
//通用函数------begin
/********************************************/
/**
 *  存储相关的UMComModelObject的对象，和对应relationID的relation表
 *
 *  @param type              @see UMComRelatedIDTableType
 *  @param umComModelObjects 继承UMComModelObject的类型对象
 */
-(void)saveRelatedIDTableWithType:(UMComRelatedIDTableType)type withUMComModelObjects:(NSArray*)umComModelObjects;
/**
 *  同步查找属于type类型的数据流(包括 feed, user 等)
 *
 *  @param type @see UMComRelatedIDTableType
 *
 *  @return 返回一个包含字典的数组
 */
-(id)fetchSyncWithType:(UMComRelatedIDTableType)type;

/**
 *  异步查找相关的type类型的对象
 *
 *  @param type          @see UMComRelatedIDTableType
 *  @param completeBlock 异步回调,数组类型
 */
-(void)fetchASyncWithType:(UMComRelatedIDTableType)type withCompleteBlock:(void(^)(id,NSError*))completeBlock;


/**
 *  异步删除UMComRelatedIDTableType对应的relationID表的数据
 *
 *  @param type @see UMComRelatedIDTableType
 *  @discuss 此函数只是删除了UMComRelatedIDTableType对应的relationID的表，并没有删除relationID对应的对象的表
 */
-(void)deleteRelatedIDTableWithType:(UMComRelatedIDTableType)type;

/********************************************/
//通用函数------end
/********************************************/

@end
