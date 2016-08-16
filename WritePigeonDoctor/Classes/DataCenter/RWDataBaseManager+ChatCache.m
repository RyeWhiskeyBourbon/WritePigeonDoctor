//
//  RWDataBaseManager+ChatCache.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/8/8.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWDataBaseManager+ChatCache.h"
#import "RWDataModels.h"

@implementation RWDataBaseManager (ChatCache)

- (BOOL)addConsultHistory:(RWHistory *)history
{
    if ([self existConsultHistory:history])
    {
        return [self updateConsultHistory:history];
    }
    
    NSString *name = NSStringFromClass([RWConsultHistory class]);
    NSManagedObjectContext *context = self.managedObjectContext;
    
    RWConsultHistory *consultHistory =
                        [NSEntityDescription insertNewObjectForEntityForName:name
                                                      inManagedObjectContext:context];
    
    consultHistory.doctorDescription = history.doctorDescription;
    consultHistory.doctorid = history.doctorid;
    consultHistory.header = history.header;
    consultHistory.name = history.name;
    consultHistory.office = history.office;
    consultHistory.professionTitle = history.professionTitle;
    consultHistory.umid = history.umid;
    
    return [self saveContext];
}

- (void)addConsultHistoryWithItem:(RWDoctorItem *)item completion:(void(^)(BOOL success))completion
{
    NSOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        
        RWHistory *history = [[RWHistory alloc] init];
        
        history.doctorDescription = item.doctorDescription;
        history.doctorid = item.EMID;
        history.header = [NSData dataWithContentsOfURL:[NSURL URLWithString:item.header]];
        
        history.name = item.name;
        history.office = item.office;
        history.professionTitle = item.professionalTitle;
        history.umid = item.umid;
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
           
            if ([self existConsultHistory:history])
            {
                completion([self updateConsultHistory:history]);
                
                return;
            }
            
            completion([self addConsultHistory:history]);
        }];
    }];
    
    [[RWChatManager defaultManager].downLoadQueue addOperation:operation];
}

- (BOOL)existConsultHistory:(RWHistory *)history
{
    NSPredicate *predicate =
                [NSPredicate predicateWithFormat:@"doctorid = %@",history.doctorid];
    NSString *name = NSStringFromClass([RWConsultHistory class]);
    
    NSArray *result = [self searchItemWithEntityName:name
                                           predicate:predicate
                                     sortDescriptors:nil];
    
    if (result.count)
    {
        return YES;
    }
    
    return NO;
}

- (BOOL)updateConsultHistory:(RWHistory *)history
{
    NSPredicate *predicate =
                    [NSPredicate predicateWithFormat:@"doctorid = %@",history.doctorid];
    NSString *name = NSStringFromClass([RWConsultHistory class]);
    
    NSArray *fetchedObjects = [self searchItemWithEntityName:name
                                                   predicate:predicate
                                             sortDescriptors:nil];
    
    if (fetchedObjects.count)
    {
        for (RWConsultHistory *consultHistory in fetchedObjects)
        {
            consultHistory.doctorDescription = history.doctorDescription;
            consultHistory.doctorid = history.doctorid;
            consultHistory.header = history.header;
            consultHistory.name = history.name;
            consultHistory.office = history.office;
            consultHistory.professionTitle = history.professionTitle;
            consultHistory.umid = history.umid;
        }
        
        return [self saveContext];
    }
    
    return NO;
}

- (BOOL)removeConsultHistory:(RWHistory *)history
{
    NSString *name = NSStringFromClass([RWConsultHistory class]);
    
    NSPredicate *predicate = history?[NSPredicate predicateWithFormat:@"doctorid = %@",history.doctorid]:nil;
    
    NSArray *result = [self searchItemWithEntityName:name
                                           predicate:predicate
                                     sortDescriptors:nil];
    
    if (result.count)
    {
        NSManagedObjectContext *context = self.managedObjectContext;
        
        for (RWConsultHistory *consultHistory in result)
        {
            [context deleteObject:consultHistory];
        }
    }
    
    return [self saveContext];
}

- (NSArray *)getConsultHistory
{
    NSString *name = NSStringFromClass([RWConsultHistory class]);
    
    NSArray *fetchedObjects = [self searchItemWithEntityName:name
                                                   predicate:nil
                                             sortDescriptors:nil];
    
    if (fetchedObjects.count)
    {
        NSMutableArray *consultList = [[NSMutableArray alloc] init];
        
        for (RWConsultHistory *consultHistory in fetchedObjects)
        {
            RWHistory *history = [[RWHistory alloc] init];
            
            history.doctorDescription = consultHistory.doctorDescription;
            history.doctorid = consultHistory.doctorid;
            history.header = consultHistory.header;
            history.name = consultHistory.name;
            history.office = consultHistory.office;
            history.professionTitle = consultHistory.professionTitle;
            history.umid = consultHistory.umid;
            
            [consultList addObject:history];
        }
        
        return consultList;
    }
    
    return nil;
}

- (RWHistory *)getConsultHistoryWithDoctorID:(NSString *)doctorID
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"doctorid = %@",doctorID];
    NSString *name = NSStringFromClass([RWConsultHistory class]);
    
    NSArray *result = [self searchItemWithEntityName:name
                                           predicate:predicate
                                     sortDescriptors:nil];
    
    for (RWConsultHistory *consultHistory in result)
    {
        RWHistory *history = [[RWHistory alloc] init];
        
        history.doctorDescription = consultHistory.doctorDescription;
        history.doctorid = consultHistory.doctorid;
        history.header = consultHistory.header;
        history.name = consultHistory.name;
        history.office = consultHistory.office;
        history.professionTitle = consultHistory.professionTitle;
        history.umid = consultHistory.umid;
        
        return history;
    }
    
    return nil;
}

- (BOOL)cacheMessage:(RWWeChatMessage *)message
{
    if ([self existCacheMessage:message])
    {
        [self updateCacheMessage:message];
    }
    
    NSString *name = NSStringFromClass([RWChatCache class]);
    NSManagedObjectContext *context = self.managedObjectContext;
    
    RWChatCache *chatCache =
                    [NSEntityDescription insertNewObjectForEntityForName:name
                                                  inManagedObjectContext:context];

    chatCache.conversationId = message.message.conversationId;
    chatCache.date = message.messageDate;
    chatCache.from = message.message.from;
    chatCache.to = message.message.to;
    chatCache.type = @(message.message.body.type);
    chatCache.status = @(message.message.status);
    chatCache.myMessage = @(message.isMyMessage);
    chatCache.read = @(message.message.isRead);
    chatCache.messageid = message.message.messageId;
    
    switch (message.messageType)
    {
        case RWMessageTypeText:
        {
            EMTextMessageBody *body = (EMTextMessageBody *)message.message.body;
            
            chatCache.content = [body.text dataUsingEncoding:NSUTF8StringEncoding];
            
            break;
        }
        case RWMessageTypeVoice:
        {
            EMVoiceMessageBody *body = (EMVoiceMessageBody *)message.message.body;
            
            chatCache.content = message.originalResource?
                                message.originalResource:
                                [NSData dataWithContentsOfFile:body.localPath];
            chatCache.duration = @(body.duration);
            chatCache.localPath = body.localPath;
            chatCache.remotePath = body.remotePath;
            chatCache.secretKey = body.secretKey;
            
            break;
        }
        case RWMessageTypeImage:
        {
            EMImageMessageBody *body = (EMImageMessageBody *)message.message.body;
            
            chatCache.content = message.originalResource?
                                message.originalResource:
                                [NSData dataWithContentsOfFile:body.localPath];
            
            MESSAGE(@"%@",message.originalResource);
            chatCache.localPath = body.localPath;
            chatCache.remotePath = body.remotePath;
            chatCache.secretKey = body.secretKey;
            
            break;
        }
        case RWMessageTypeVideo:
        {
            EMVideoMessageBody *body = (EMVideoMessageBody *)message.message.body;
            
            chatCache.localPath = body.localPath;
            chatCache.remotePath = body.remotePath;
            chatCache.secretKey = body.secretKey;
            
            break;
        }
        default:break;
    }
    
    return [self saveContext];
}

- (BOOL)updateCacheMessage:(RWWeChatMessage *)message
{
    NSString *name = NSStringFromClass([RWChatCache class]);
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"messageid = %@ && date = %@",message.message.messageId,message.messageDate];
    
    NSArray *result = [self searchItemWithEntityName:name
                                           predicate:predicate
                                     sortDescriptors:nil];
    
    if (!result.count)
    {
        return NO;
    }
    
    for (RWChatCache *chatCache in result)
    {
        chatCache.conversationId = message.message.conversationId;
        chatCache.date = message.messageDate;
        chatCache.from = message.message.from;
        chatCache.to = message.message.to;
        chatCache.type = @(message.message.body.type);
        chatCache.status = @(message.message.status);
        chatCache.myMessage = @(message.isMyMessage);
        chatCache.read = @(message.message.isRead);
        chatCache.messageid = message.message.messageId;
        chatCache.showTime = @(message.showTime);
        
        switch (message.messageType)
        {
            case RWMessageTypeText:
            {
                EMTextMessageBody *body = (EMTextMessageBody *)message.message.body;
                
                chatCache.content = [body.text dataUsingEncoding:NSUTF8StringEncoding];
                
                break;
            }
            case RWMessageTypeVoice:
            {
                EMVoiceMessageBody *body = (EMVoiceMessageBody *)message.message.body;
                
                chatCache.content = message.originalResource?
                                    message.originalResource:
                                    [NSData dataWithContentsOfFile:body.localPath];
                chatCache.duration = @(body.duration);
                chatCache.localPath = body.localPath;
                chatCache.remotePath = body.remotePath;
                chatCache.secretKey = body.secretKey;
                
                break;
            }
            case RWMessageTypeImage:
            {
                EMImageMessageBody *body = (EMImageMessageBody *)message.message.body;
                
                chatCache.content = message.originalResource?
                                    message.originalResource:
                                    [NSData dataWithContentsOfFile:body.localPath];
                chatCache.localPath = body.localPath;
                chatCache.remotePath = body.remotePath;
                chatCache.secretKey = body.secretKey;
                
                break;
            }
            case RWMessageTypeVideo:
            {
                EMVideoMessageBody *body = (EMVideoMessageBody *)message.message.body;
                
                chatCache.content = message.originalResource?
                                    message.originalResource:
                                    [NSData dataWithContentsOfFile:body.localPath];
                chatCache.localPath = body.localPath;
                chatCache.remotePath = body.remotePath;
                chatCache.secretKey = body.secretKey;
                
                break;
            }
            default:break;
        }
    }
    
    return [self saveContext];
}

- (BOOL)existCacheMessage:(RWWeChatMessage *)message
{
    NSString *name = NSStringFromClass([RWChatCache class]);
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"messageid = %@ && date = %@",message.message.messageId,message.messageDate];
    
    NSArray *result = [self searchItemWithEntityName:name
                                           predicate:predicate
                                     sortDescriptors:nil];
    
    if (result.count)
    {
        return YES;
    }
    
    return NO;
}

- (BOOL)removeCacheMessage:(RWWeChatMessage *)message
{
    NSString *name = NSStringFromClass([RWChatCache class]);
    
    NSPredicate *predicate = message?[NSPredicate predicateWithFormat:@"messageid = %@ && date = %@",message.message.messageId,message.messageDate]:nil;
    
    NSArray *result = [self searchItemWithEntityName:name
                                           predicate:predicate
                                     sortDescriptors:nil];
    
    if (result.count)
    {
        NSManagedObjectContext *context = self.managedObjectContext;
        
        for (RWChatCache *messageCache in result)
        {
            [context deleteObject:messageCache];
        }
    }
    
    return [self saveContext];
}

- (BOOL)removeCacheMessageWith:(RWHistory *)history
{
    NSString *name = NSStringFromClass([RWChatCache class]);
    RWUser *user = [self getDefualtUser];
    
    NSPredicate *predicate = history?
                            [NSPredicate predicateWithFormat:@"(to = %@ || from = %@) && (to = %@ || from = %@)",history.doctorid,history.doctorid,user.username,user.username]:nil;
    
    NSArray *result = [self searchItemWithEntityName:name
                                           predicate:predicate
                                     sortDescriptors:nil];
    
    if (result.count)
    {
        NSManagedObjectContext *context = self.managedObjectContext;
        
        for (RWChatCache *messageCache in result)
        {
            [context deleteObject:messageCache];
        }
    }
    
    return [self saveContext];
}

- (NSArray *)getMessageWith:(NSString *)emid
{
    NSString *name = NSStringFromClass([RWChatCache class]);
    
    RWUser *user = [self getDefualtUser];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(to = %@ || from = %@) && (to = %@ || from = %@)",emid,emid,user.username,user.username];
    
    NSArray *result = [self searchItemWithEntityName:name
                                           predicate:predicate
                                     sortDescriptors:nil];
    
    if (!result.count)
    {
        return nil;
    }
    
    NSMutableArray *messages = [[NSMutableArray alloc] init];
    
    for (RWChatCache *chatCache in result)
    {
        EMMessage *message = [[EMMessage alloc] initWithConversationID:
                                                        chatCache.conversationId
                                                                  from:chatCache.from
                                                                    to:chatCache.to
                                                                  body:nil
                                                                   ext:nil];
        message.status = chatCache.status.intValue;
        message.chatType = EMChatTypeChat;
        message.messageId = chatCache.messageid;
        message.isRead = chatCache.read;
        
        RWMessageType type;
        
        switch (chatCache.type.intValue)
        {
            case EMMessageBodyTypeText:
            {
                NSString *text = [[NSString alloc] initWithData:chatCache.content encoding:NSUTF8StringEncoding];
                
                EMTextMessageBody *body =
                                        [[EMTextMessageBody alloc] initWithText:text];
                
                message.body = body;
                
                type = RWMessageTypeText;
                
                break;
            }
            case EMMessageBodyTypeImage:
            {
                NSData *imageData = chatCache.content?chatCache.content:[NSData dataWithContentsOfFile:chatCache.localPath];
                
                NSString *name = chatCache.localPath?[[chatCache.localPath componentsSeparatedByString:@"/"] lastObject]:nil;
                
                EMImageMessageBody *body = [[EMImageMessageBody alloc] initWithData:imageData displayName:name];
                
                body.localPath = chatCache.localPath;
                body.remotePath = chatCache.remotePath;
                body.secretKey = chatCache.secretKey;
                
                message.body = body;
                
                type = RWMessageTypeImage;
                
                break;
            }
            case EMMessageBodyTypeVoice:
            {
                NSData *voiceData = chatCache.content?chatCache.content:[NSData dataWithContentsOfFile:chatCache.localPath];
                
                NSString *name = chatCache.localPath?[[chatCache.localPath componentsSeparatedByString:@"/"] lastObject]:nil;
                
                EMVoiceMessageBody *voiceBody = [[EMVoiceMessageBody alloc] initWithData:voiceData displayName:name];
                
                voiceBody.duration = chatCache.duration.intValue;
                voiceBody.localPath = chatCache.localPath;
                voiceBody.remotePath = chatCache.remotePath;
                voiceBody.secretKey = chatCache.secretKey;
                
                message.body = voiceBody ;
                
                type = RWMessageTypeVoice;
                
                break;
            }
            case EMMessageBodyTypeVideo:
            {
                NSString *name = chatCache.localPath?[[chatCache.localPath componentsSeparatedByString:@"/"] lastObject]:nil;
                
                EMVideoMessageBody *body = [[EMVideoMessageBody alloc] initWithLocalPath:chatCache.localPath displayName:name];
                
                body.localPath = chatCache.localPath;
                body.remotePath = chatCache.remotePath;
                body.secretKey = chatCache.secretKey;
                
                message.body = body;
                
                type = RWMessageTypeVideo;
                
                break;
            }
                
            default: break;
                
        }
        
        UIImage *header;
        
        if (chatCache.myMessage)
        {
            RWUser *user = [self getDefualtUser];
            
            if (user)
            {
                header = [UIImage imageWithData:user.header];
            }
        }
        else
        {
            RWHistory *history = [self getConsultHistoryWithDoctorID:message.from];
            
            if (history)
            {
                header = [UIImage imageWithData:history.header];
            }
        }

        RWWeChatMessage *cache = [RWWeChatMessage message:message
                                                   header:header
                                                     type:type
                                                myMessage:
                                                    chatCache.myMessage.boolValue
                                              messageDate:chatCache.date
                                                 showTime:chatCache.showTime.boolValue
                                         originalResource:chatCache.content];
        
        [messages addObject:cache];
    }
    
    return messages;
}

- (NSInteger)getUnreadNumber
{
    NSString *name = NSStringFromClass([RWChatCache class]);
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"read = 0"];
    
    NSArray *result = [self searchItemWithEntityName:name
                                           predicate:predicate
                                     sortDescriptors:nil];

    return result.count;
}

@end
