//
//  RWChatManager.h
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/7/26.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EMSDK.h>
#import <EMSDKFull.h>
#import "RWWeChatBar.h"
#import "RWDataBaseManager+ChatCache.h"
#import "RWRequsetManager+UserLogin.h"

#ifndef __NET_STATUS__
#define __NET_STATUS__ [RWChatManager defaultManager].reachabilityStatus
#endif

BOOL _found_response(id delegate,NSString *selector);

#ifndef found_response
#define found_response _found_response
#endif

extern NSString *messageTextBody;
extern NSString *messageImageName;
extern NSString *messageImageBody;
extern NSString *messageVoiceName;
extern NSString *messageVoiceBody;
extern NSString *messageVoiceDuration;
extern NSString *messageLocationLatitude;
extern NSString *messageLocationLongitude;
extern NSString *messageLocationAddress;
extern NSString *messageVideoName;
extern NSString *messageVideoBody;

extern NSString *conversationTo;
extern NSString *UMID;

extern NSString *QueueName;
extern NSString *HeaderOperation;

typedef NS_ENUM(NSInteger,RWLinkState)
{
    RWLinkStateOfAutoLogin = 2,
    RWLinkStateOfLoginFinish = 1,
    RWLinkStateOfDropped = -1,
    RWLinkStateOfLoginFromOtherDevice = -2,
    RWLinkStateOfRemovedFromServer = -3,
    
    RWLinkStateOfUnLink = 0
};

extern NSString *RWNewMessageNotification;
extern NSString *RWDroppedNotification;
extern NSString *RWLoginFromOtherDeviceNotification;
extern NSString *RWRemovedFromServerNotification;
extern NSString *RWLoginFinishNotification;
extern NSString *RWAutoLoginNotification;
extern NSString *RWNetworkReachabilityNotification;
extern NSString *RWConnectionStateNotification;
extern NSString *RWHeaderMessageToObserve;
extern NSString *RWHeaderDownLoadFinishNotification;

@protocol RWChatManagerDelegate <NSObject>

- (void)receiveMessage:(RWWeChatMessage *)message;

@end

@interface RWChatManager : NSObject

<
    EMClientDelegate,
    EMChatManagerDelegate,
    RWRequsetDelegate
>

+ (instancetype)defaultManager;

@property (nonatomic,strong,readonly)EMClient *client;
@property (nonatomic,weak,readonly)id<IEMChatManager> chatManager;

@property (nonatomic,assign)id<RWChatManagerDelegate> delegate;

@property (nonatomic,assign)EMConnectionState connectionState;
@property (nonatomic,assign,readonly)AFNetworkReachabilityStatus reachabilityStatus;
@property (nonatomic,assign,readonly)RWLinkState statusForLink;

@property (nonatomic,strong,readonly)EMConversation *faceSession;
@property (nonatomic,strong,readonly)NSMutableArray *allSessions;

@property (nonatomic,strong)RWDataBaseManager *baseManager;
@property (nonatomic,strong)NSOperationQueue *downLoadQueue;

- (void)createConversationWithID:(NSString *)ID extension:(NSDictionary *)extension;
- (void)removeFaceConversation;

+ (NSString *)videoName;
+ (NSString *)voiceName;
+ (NSString *)imageNameSuffix:(NSString *)suffix;

void _send_notification(const NSString *name,id message);
void _notification(const NSString *name,void(^block)(NSNotification * _Nonnull note));

#define send_notification _send_notification
#define notification_observe _notification

+ (void)sendNotificationWithName:(const NSString *)name message:(id)message;
+ (void)observeNotification:(const NSString *)name usingblock:(void(^)(NSNotification * _Nonnull note))block;

@end

@interface RWChatMessageMaker : NSObject

+ (EMMessage *)messageWithType:(EMMessageBodyType)type body:(NSDictionary *)body extension:(NSDictionary *)extension;

@end
