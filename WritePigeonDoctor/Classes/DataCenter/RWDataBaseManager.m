//
//  RWDataBaseManager.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/8/7.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWDataBaseManager.h"

#define __BASE_NAME__ @"PigeonDoctorDatabase.sqlite"

@implementation RWDataBaseManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize storeCoordinator = _storeCoordinator;

+ (instancetype)defaultManager
{
    static RWDataBaseManager *_defaultManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _defaultManager = [super allocWithZone:NULL];
    });
    
    return _defaultManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [RWDataBaseManager defaultManager];
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return [RWDataBaseManager defaultManager];
}

+ (id)mutableCopyWithZone:(struct _NSZone *)zone
{
    return [RWDataBaseManager defaultManager];
}

- (NSManagedObjectContext *)managedObjectContext
{
    if(_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    [_managedObjectContext setPersistentStoreCoordinator:self.storeCoordinator];
    
    return _managedObjectContext;
}

-(NSManagedObjectModel *)managedObjectModel
{
    if(_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    
    NSURL *baseModel = [[NSBundle mainBundle] URLForResource:@"PigeonDoctorDatabase" withExtension:@"momd"];
    
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:baseModel];
    
    return _managedObjectModel;
}

-(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if(_storeCoordinator!=nil)
    {
        return _storeCoordinator;
    }
    
    _storeCoordinator = [[NSPersistentStoreCoordinator alloc]
                                initWithManagedObjectModel: self.managedObjectModel];
    NSString *basePath = [__SANDBOX_PATH__ stringByAppendingPathComponent:__BASE_NAME__];
    NSURL *storeURL= [NSURL URLWithString:basePath];
    NSError *error = nil;
    
    [_storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                    configuration:nil
                                              URL:storeURL
                                          options:nil
                                            error:&error];
    
    if (_storeCoordinator.persistentStores.count != 1 ||
        ![_storeCoordinator.persistentStores lastObject])
    {
        NSLog(@"create Base Fail reason : %@",error.description);
        abort();
    }
    
    return _storeCoordinator;
}

@end
