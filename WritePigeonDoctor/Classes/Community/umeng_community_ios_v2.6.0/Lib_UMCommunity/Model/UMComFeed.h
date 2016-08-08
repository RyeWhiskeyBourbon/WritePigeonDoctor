//
//  UMComFeed.h
//  UMCommunity
//
//  Created by umeng on 15/11/6.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UMComModelObject.h"

#define FeedStatusDeleted 2

typedef NS_OPTIONS(NSUInteger, EUMTopFeedType) {
    EUMTopFeedType_None                     = 0,            /*不置顶*/
    EUMTopFeedType_GlobalTopFeed            = 2,            /*全局置顶*/
    EUMTopFeedType_TopicTopFeed             = 4,            /*话题下置顶*/
    EUMTopFeedType_GlobalAndTopicTopFeed    = 6,            /*同时话题置顶和全局置顶*/
    EUMTopFeedType_Mask                     = 0x00000000    /*置顶的掩码*/
};

@class UMComComment, UMComLike, UMComTopic, UMComUser,UMComImageUrl, UMComLocation;


@interface UMComFeed : UMComModelObject

#pragma mark - 固定的base属性
/** feedID feed的唯一ID */
@property (nonatomic, retain) NSString * feedID;
/** feed的内容 */
@property (nonatomic, retain) NSString * text;
/** feed标题 */
@property (nonatomic, retain) NSString * title;

/** feed状态，大于或等与2表示已被删除，小于2表示正常 */
@property (nonatomic, retain) NSNumber * status;
/** 是否已经点赞 */
@property (nonatomic, retain) NSNumber * liked;
/** 点赞个数 */
@property (nonatomic, retain) NSNumber * likes_count;
/** 评论个数 */
@property (nonatomic, retain) NSNumber * comments_count;
/**内部使用(目前没有用到) */
@property (nonatomic, retain) NSNumber * seq;
/** 转发个数 */
@property (nonatomic, retain) NSNumber * forward_count;
/** 用于判断是否可以对Feed创建者禁言,值为1表示可以禁言，值为0表示不能禁言 */
@property (nonatomic, retain) NSNumber *ban_user;
/** 是否是全局置顶 */
@property (nonatomic, retain) NSNumber * is_top;
/** 判断Feed是否为精华，0为普通，1为精华 */
@property (nonatomic, retain) NSNumber *  tag;
/** feed类型，1表示公告，0表示普通 */
@property (nonatomic, retain) NSNumber * type;
/** 创建时间 */
@property (nonatomic, retain) NSString * create_time;
/*内部使用(目前没用)*/
@property (nonatomic, retain) NSNumber * user_mark;
/** 是否收藏 */
@property (nonatomic, retain) NSNumber * has_collected;
/** 字段值为111（Feed全部权限）或者100（删除feed权限）目前只有这两种权限可以操作feed,值为0则没有任何相关权限 */
@property (nonatomic, retain) NSNumber *permission;

/** 转发Feed的id，如果Feed不是转发，则为空 */
@property (nonatomic, retain) NSString * parent_feed_id;
/** 原始Feed的id，如果Feed不是转发，则为空 */
@property (nonatomic, retain) NSString * origin_feed_id;

/** 自定义字段(创建Feed的时候加自定义的内容) */
@property (nonatomic, retain) NSString * custom;

/** 文本类型 0:普通文本, 1:富文本, 2:视频*/
@property (nonatomic, retain) NSNumber * media_type;

/** 是否推荐 BOLL类型 */
@property (nonatomic, retain) NSNumber * is_recommended;

/** 分享链接 */
@property (nonatomic, retain) NSString * share_link;


//富文本相关 since version 2.5.0
/** 富文本的内容 media_type = 1的时候有值*/
@property (nonatomic, retain) NSString * rich_text;
/** 富文本的url(此url是请求服务器的来获得富文本的内容) media_type = 1的时候有值*/
@property (nonatomic, retain) NSString * rich_text_url;

#pragma mark - 固定的relation属性
/*地理位置*/
@property (nonatomic, retain) UMComLocation* location;
/**  Feed相关用户*/
@property (nonatomic, retain) NSArray *related_user;
/** feed创建者 */
@property (nonatomic, retain) UMComUser *creator;
/** feed图片url数组 保存的对象为`UMComImageUrl` */
@property (nonatomic, retain) NSArray *image_urls;

/** 原始Feed，如果Feed不是转发，则为空 */
@property (nonatomic, retain) UMComFeed *origin_feed;

/** Feed所属的话题 */
@property (nonatomic, retain) NSArray *topics;


#pragma mark - 可变的基本属性(随着情景值会发生变化)
/*是否话题置顶*/
@property (nonatomic, retain) NSNumber * is_topic_top;

/** 距离（在获取附近的Feed`UMComNearbyFeedsRequest`的时候返回） */
@property (nonatomic, retain) NSNumber * distance;


/** 分享次数 */
@property (nonatomic, retain) NSNumber * share_count;

/** 保留字段 */
@property (nonatomic, retain) NSNumber * source_mark;

#pragma mark - 可变的relation属性(随着情景值会发生变化)


#pragma mark - 额外增加的属性用来特定接口判断(新增加字段，不属于协议默认字段)

///** 是否关注 */
//@property (nonatomic, retain) NSString * is_follow;


/** 是否是全局置顶,话题置顶 0-表示不置顶，2-代表全局置顶 4-代表话题置顶 6-代表话题置顶和全局置顶 @see EUMTopFeedType */
//此属性关联is_top 和 is_topic_top
//@property (nonatomic, retain) NSNumber * is_topType;


/** NSDictionary 结构为{"geo_point" = ("116.361453","39.978916");name = "地点名称";} */
//@property (nonatomic, retain) id location;




/** (内部使用) */
//@property (nonatomic, retain) NSNumber * seq_recommend;





///**  */
//@property (nonatomic, retain) NSArray *comments;
//
///**  */
//@property (nonatomic, retain) NSArray *forward_feeds;
///**  */
//@property (nonatomic, retain) NSArray *likes;






+ (UMComFeed *)feedWithFeedAttributeDict:(NSDictionary *)attributeDict;


/**
 *通过用户名从feed相关用户中查找对应的用户
 
 @param name 用户名
 *return 返回一个UMComUser对象
 */
- (UMComUser *)relatedUserWithUserName:(NSString *)name;

/**
 *通过话题名称从feed中查找对应的话题
 
 @param topicName 话题名称
 *return 返回一个UMComTopic对象
 */
- (UMComTopic *)relatedTopicWithTopicName:(NSString *)topicName;


- (UMComLocation *)locationModel;

/**
 *判断Feed是否已被标记为删除了
 *return 如果Feed已被删除则返回YES，否则返回NO
 */
- (BOOL)isStatusDeleted;

/**
 通过feedId获取到本地 UMComFeed 对象的方法，如果本地没有， 则会新建一个
 
 @param feedId Feed的id
 
 */
+ (UMComFeed *)objectWithObjectId:(NSString *)feedId;





@end

@interface UMComFeed (CoreDataGeneratedAccessors)

- (void)insertObject:(UMComComment *)value inCommentsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCommentsAtIndex:(NSUInteger)idx;
- (void)insertComments:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCommentsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCommentsAtIndex:(NSUInteger)idx withObject:(UMComComment *)value;
- (void)replaceCommentsAtIndexes:(NSIndexSet *)indexes withComments:(NSArray *)values;
- (void)addCommentsObject:(UMComComment *)value;
- (void)removeCommentsObject:(UMComComment *)value;
- (void)addComments:(NSArray *)values;
- (void)removeComments:(NSArray *)values;
- (void)insertObject:(UMComFeed *)value inForward_feedsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromForward_feedsAtIndex:(NSUInteger)idx;
- (void)insertForward_feeds:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeForward_feedsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInForward_feedsAtIndex:(NSUInteger)idx withObject:(UMComFeed *)value;
- (void)replaceForward_feedsAtIndexes:(NSIndexSet *)indexes withForward_feeds:(NSArray *)values;
- (void)addForward_feedsObject:(UMComFeed *)value;
- (void)removeForward_feedsObject:(UMComFeed *)value;
- (void)addForward_feeds:(NSArray *)values;
- (void)removeForward_feeds:(NSArray *)values;
- (void)insertObject:(UMComLike *)value inLikesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromLikesAtIndex:(NSUInteger)idx;
- (void)insertLikes:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeLikesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInLikesAtIndex:(NSUInteger)idx withObject:(UMComLike *)value;
- (void)replaceLikesAtIndexes:(NSIndexSet *)indexes withLikes:(NSArray *)values;
- (void)addLikesObject:(UMComLike *)value;
- (void)removeLikesObject:(UMComLike *)value;
- (void)addLikes:(NSArray *)values;
- (void)removeLikes:(NSArray *)values;
- (void)insertObject:(UMComUser *)value inRelated_userAtIndex:(NSUInteger)idx;
- (void)removeObjectFromRelated_userAtIndex:(NSUInteger)idx;
- (void)insertRelated_user:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeRelated_userAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInRelated_userAtIndex:(NSUInteger)idx withObject:(UMComUser *)value;
- (void)replaceRelated_userAtIndexes:(NSIndexSet *)indexes withRelated_user:(NSArray *)values;
- (void)addRelated_userObject:(UMComUser *)value;
- (void)removeRelated_userObject:(UMComUser *)value;
- (void)addRelated_user:(NSArray *)values;
- (void)removeRelated_user:(NSArray *)values;
- (void)insertObject:(UMComTopic *)value inTopicsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromTopicsAtIndex:(NSUInteger)idx;
- (void)insertTopics:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeTopicsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInTopicsAtIndex:(NSUInteger)idx withObject:(UMComTopic *)value;
- (void)replaceTopicsAtIndexes:(NSIndexSet *)indexes withTopics:(NSArray *)values;
- (void)addTopicsObject:(UMComTopic *)value;
- (void)removeTopicsObject:(UMComTopic *)value;
- (void)addTopics:(NSArray *)values;
- (void)removeTopics:(NSArray *)values;
@end
