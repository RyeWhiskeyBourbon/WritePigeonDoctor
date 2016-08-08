//
//  RWDataBaseManager.h
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/8/7.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface RWDataBaseManager : NSObject

+ (instancetype)defaultManager;

@property (nonatomic,strong,readonly)NSManagedObjectContext *managedObjectContext;

@property (nonatomic,strong,readonly)NSManagedObjectModel *managedObjectModel;

@property (nonatomic,strong,readonly)NSPersistentStoreCoordinator *storeCoordinator;

@end
