//
//  RWDataBaseManager+NameCardCollectMessage.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/8/14.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWDataBaseManager+NameCardCollectMessage.h"

@implementation RWDataBaseManager (NameCardCollectMessage)

- (BOOL)addNameCard:(RWCard *)card
{
    if ([self existCard:card])
    {
        return [self updateNameCard:card];
    }
    
    NSString *name = NSStringFromClass([RWNameCard class]);
    NSManagedObjectContext *context = self.managedObjectContext;
    
    RWNameCard *nameCard =
    [NSEntityDescription insertNewObjectForEntityForName:name
                                  inManagedObjectContext:context];
    
    nameCard.doctorDescription = card.doctorDescription;
    nameCard.doctorid = card.doctorid;
    nameCard.header = card.header;
    nameCard.name = card.name;
    nameCard.office = card.office;
    nameCard.professionTitle = card.professionTitle;
    nameCard.umid = card.umid;
    
    return [self saveContext];
}

- (void)addNameCardWithItem:(RWDoctorItem *)item completion:(void(^)(BOOL success))completion
{
    NSOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        
        RWCard *nameCard = [[RWCard alloc] init];
        
        nameCard.doctorDescription = item.doctorDescription;
        nameCard.doctorid = item.EMID;
        nameCard.header =
                    [NSData dataWithContentsOfURL:[NSURL URLWithString:item.header]];
        
        nameCard.name = item.name;
        nameCard.office = item.office;
        nameCard.professionTitle = item.professionalTitle;
        nameCard.umid = item.umid;
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            if ([self existCard:nameCard])
            {
                completion([self updateNameCard:nameCard]);
                
                return;
            }
            
            completion([self addNameCard:nameCard]);
        }];
    }];
    
    [[RWChatManager defaultManager].downLoadQueue addOperation:operation];
}

- (BOOL)existCard:(RWCard *)card
{
    NSPredicate *predicate =
                [NSPredicate predicateWithFormat:@"doctorid = %@",card.doctorid];
    NSString *name = NSStringFromClass([RWNameCard class]);
    
    NSArray *result = [self searchItemWithEntityName:name
                                           predicate:predicate
                                     sortDescriptors:nil];
    
    if (result.count)
    {
        return YES;
    }
    
    return NO;
}

- (BOOL)existCardID:(NSString *)cardID
{
    NSPredicate *predicate =
                            [NSPredicate predicateWithFormat:@"doctorid = %@",cardID];
    NSString *name = NSStringFromClass([RWNameCard class]);
    
    NSArray *result = [self searchItemWithEntityName:name
                                           predicate:predicate
                                     sortDescriptors:nil];
    
    if (result.count)
    {
        return YES;
    }
    
    return NO;
}

- (BOOL)updateNameCard:(RWCard *)card
{
    NSPredicate *predicate =
                        [NSPredicate predicateWithFormat:@"doctorid = %@",card.doctorid];
    NSString *name = NSStringFromClass([RWNameCard class]);
    
    NSArray *fetchedObjects = [self searchItemWithEntityName:name
                                                   predicate:predicate
                                             sortDescriptors:nil];
    
    if (fetchedObjects.count)
    {
        for (RWNameCard *nameCard in fetchedObjects)
        {
            nameCard.doctorDescription = card.doctorDescription;
            nameCard.doctorid = card.doctorid;
            nameCard.header = card.header;
            nameCard.name = card.name;
            nameCard.office = card.office;
            nameCard.professionTitle = card.professionTitle;
            nameCard.umid = card.umid;
        }
        
        return [self saveContext];
    }
    
    return NO;
}

- (BOOL)removeNameCard:(RWCard *)card
{
    NSString *name = NSStringFromClass([RWNameCard class]);
    
    NSPredicate *predicate = card?[NSPredicate predicateWithFormat:@"doctorid = %@",card.doctorid]:nil;
    
    NSArray *result = [self searchItemWithEntityName:name
                                           predicate:predicate
                                     sortDescriptors:nil];
    
    if (result.count)
    {
        NSManagedObjectContext *context = self.managedObjectContext;
        
        for (RWNameCard *nameCard in result)
        {
            [context deleteObject:nameCard];
        }
    }
    
    return [self saveContext];
}

- (NSArray *)getNameCards
{
    NSString *name = NSStringFromClass([RWNameCard class]);
    
    NSArray *fetchedObjects = [self searchItemWithEntityName:name
                                                   predicate:nil
                                             sortDescriptors:nil];
    
    if (fetchedObjects.count)
    {
        NSMutableArray *consultList = [[NSMutableArray alloc] init];
        
        for (RWNameCard *nameCard in fetchedObjects)
        {
            RWCard *card = [[RWCard alloc] init];
            
            card.doctorDescription = nameCard.doctorDescription;
            card.doctorid = nameCard.doctorid;
            card.header = nameCard.header;
            card.name = nameCard.name;
            card.office = nameCard.office;
            card.professionTitle = nameCard.professionTitle;
            card.umid = nameCard.umid;
            
            [consultList addObject:card];
        }
        
        return consultList;
    }
    
    return nil;
}

- (BOOL)hasNameCard:(RWWeChatMessage *)message
{
    NSString *cardID = message.isMyMessage?message.message.to:message.message.from;
    
    return [self existCardID:cardID];
}

- (BOOL)collectMessage:(RWWeChatMessage *)message
{
    if ([self existCacheMessage:message])
    {
        [self updateCacheMessage:message];
    }
    
    NSString *name = NSStringFromClass([RWCollectMessage class]);
    NSManagedObjectContext *context = self.managedObjectContext;
    
    RWCollectMessage *chatCache =
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
    
    return [self saveContext];
}

- (BOOL)updateCollectMessage:(RWWeChatMessage *)message
{
    NSString *name = NSStringFromClass([RWCollectMessage class]);
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"messageid = %@ && date = %@",message.message.messageId,message.messageDate];
    
    NSArray *result = [self searchItemWithEntityName:name
                                           predicate:predicate
                                     sortDescriptors:nil];
    
    if (!result.count)
    {
        return NO;
    }
    
    for (RWCollectMessage *chatCache in result)
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

- (BOOL)existCollectMessage:(RWWeChatMessage *)message
{
    NSString *name = NSStringFromClass([RWCollectMessage class]);
    
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

- (BOOL)removeCollectMessage:(RWWeChatMessage *)message
{
    NSString *name = NSStringFromClass([RWCollectMessage class]);
    
    NSPredicate *predicate = message?[NSPredicate predicateWithFormat:@"messageid = %@ && date = %@",message.message.messageId,message.messageDate]:nil;
    
    NSArray *result = [self searchItemWithEntityName:name
                                           predicate:predicate
                                     sortDescriptors:nil];
    
    if (result.count)
    {
        NSManagedObjectContext *context = self.managedObjectContext;
        
        for (RWCollectMessage *messageCache in result)
        {
            [context deleteObject:messageCache];
        }
    }
    
    return [self saveContext];
}

- (BOOL)removeCollectMessageWithCard:(RWCard *)card
{
    NSString *name = NSStringFromClass([RWCollectMessage class]);
    RWUser *user = [self getDefualtUser];
    
    NSPredicate *predicate = card?
    [NSPredicate predicateWithFormat:@"(to = %@ || from = %@) && (to = %@ || from = %@)",card.doctorid,card.doctorid,user.username,user.username]:nil;
    
    NSArray *result = [self searchItemWithEntityName:name
                                           predicate:predicate
                                     sortDescriptors:nil];
    
    if (result.count)
    {
        NSManagedObjectContext *context = self.managedObjectContext;
        
        for (RWCollectMessage *messageCache in result)
        {
            [context deleteObject:messageCache];
        }
    }
    
    return [self saveContext];
}

- (NSArray *)getCollectMessageWith:(NSString *)emid
{
    NSString *name = NSStringFromClass([RWCollectMessage class]);
    
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
    
    for (RWCollectMessage *chatCache in result)
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

@end
