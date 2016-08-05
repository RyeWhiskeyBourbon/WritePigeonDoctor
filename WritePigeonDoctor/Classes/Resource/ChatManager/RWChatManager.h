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

@protocol RWChatManagerDelegate <NSObject>

- (void)receiveMessage:(EMMessage *)message messageType:(EMMessageBodyType)messageType;

@end

@interface RWChatManager : NSObject

<
    EMClientDelegate,
    EMChatManagerDelegate
>

+ (instancetype)defaultManager;

@property (nonatomic,strong,readonly)EMClient *client;
@property (nonatomic,weak,readonly)id<IEMChatManager> chatManager;

@property (nonatomic,assign)id<RWChatManagerDelegate> delegate; 

@property (nonatomic,strong,readonly)EMConversation *faceSession;
@property (nonatomic,strong,readonly)NSMutableArray *allSessions;

@property (nonatomic,strong)NSOperationQueue *downloadQueue;

- (void)createConversationWithID:(NSString *)ID;

+ (NSString *)videoName;
+ (NSString *)voiceName;
+ (NSString *)imageNameSuffix:(NSString *)suffix;

@end

@interface RWChatMessageMaker : NSObject

+ (EMMessage *)messageWithType:(EMMessageBodyType)type body:(NSDictionary *)body extension:(NSDictionary *)extension to:(NSString *)toChatId;

@end
