//
//  RWSettingsManager.h
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/8/10.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWSettingsIndex.h"
#import "NSDate+DateExtension.h"

#ifndef __SYS_SETTINGS__
#define __SYS_SETTINGS__ [RWSettingsManager systemSettings]
#endif

#ifndef SETTINGS
#define SETTINGS(key,value) [__SYS_SETTINGS__ setSettingsValue:value forKey:key]
#endif

#ifndef SETTINGS_VALUE
#define SETTINGS_VALUE(key) [__SYS_SETTINGS__ settingsValueForKey:key]
#endif

typedef NS_ENUM(NSInteger,AppleProductModels);

@interface RWSettingsManager : NSObject

+ (instancetype)systemSettings;

+ (AppleProductModels )deviceVersion;

@property (nonatomic,strong,readonly)NSMutableDictionary *settings;
/**
 *  添加一条设置信息
 *
 *  @param value
 *  @param key
 *
 *  @return
 */
- (BOOL)setSettingsValue:(id)value forKey:(NSString *)key;
/**
 *  取出一条设置信息
 *
 *  @param key
 *
 *  @return
 */
- (id)settingsValueForKey:(NSString *)key;
/**
 *  移除一条设置信息
 *
 *  @param key
 *
 *  @return
 */
- (BOOL)removeSettingsValueForKey:(NSString *)key;
/**
 *  提示Alert框
 *
 *  @param viewController 控制器
 *  @param title          内容
 *  @param response       点击确定后的响应
 */
+ (void)promptToViewController:(__kindof UIViewController *)viewController Title:(NSString *)title response:(void(^)(void))response;
/**
 *  获取全部对象
 
 *
 *  @param objectClass
 *
 *  @return
 */
+ (NSArray *)obtainAllKeysWithObjectClass:(Class)objectClass;
/**
 *  AddLocalNotification
 *
 *  @param clockString time string
 *  @param name NotificationName
 *  @param content Notification content
 */
- (void)addLocalNotificationWithClockString:(NSString *)clockString
                                    AndName:(NSString *)name
                                    content:(NSString *)content;
/**
 *  cancelLocalNotification
 *
 *  @param name NotificationName
 */
- (void)cancelLocalNotificationWithName:(NSString *)name;
/**
 *  AddLocalNotification
 *
 *  @param date    Notification date
 *  @param cycle   Notification cycle
 *  @param name    Notification name
 *  @param content Notification content
 */
- (void)addAlarmClockWithTime:(NSDate *)date
                        Cycle:(RWClockCycle)cycle
                    ClockName:(NSString *)name
                      Content:(NSString *)content;

@end

typedef NS_ENUM(NSInteger,AppleProductModels)
{
    iPhone_2G__A1203,
    iPhone_3G__A1241_A1324,
    iPhone_3GS__A1303_A1325,
    iPhone_4__A1332 = - 2,
    iPhone_4__A1349 = - 1,
    iPhone_4S__A1387_A1431 = 0,
    iPhone_5__A1428,
    iPhone_5__A1429_A1442,
    iPhone_5c__A1456_A1532,
    iPhone_5c__A1507_A1516_A1526_A1529,
    iPhone_5s__A1453_A1533,
    iPhone_5s__A1457_A1518_A1528_A1530,
    iPhone_6_Plus__A1522_A1524,
    iPhone_6__A1549_A1586,
    iPhone_6s__A1633_A1688_A1691_A1700,
    iPhone_6s_Plus__A1634_A1687_A1690_A1699,
    iPhone_SE__A1662_A1723_A1724,
    iPhone_Simulator,
    
    iPod_Touch_1G__A1213,
    iPod_Touch_2G__A1288,
    iPod_Touch_3G__A1318,
    iPod_Touch_4G__A1367,
    iPod_Touch_5G__A1421_A1509,
    iPod_touch_6G__A1574,
    
    iPad_1G__A1219_A1337,
    iPad_2__A1395,
    iPad_2__A1396,
    iPad_2__A1397,
    iPad_2__A1395_New_Chip,
    iPad_Mini_1G__A1432,
    iPad_Mini_1G__A1454,
    iPad_Mini_1G__A1455,
    iPad_3__A1416,
    iPad_3__A1403,
    iPad_3__A1430,
    iPad_4__A1458,
    iPad_4__A1459,
    iPad_4__A1460,
    iPad_Air__A1474,
    iPad_Air__A1475,
    iPad_Air__A1476,
    iPad_Mini_2G__A1489,
    iPad_Mini_2G__A1490,
    iPad_Mini_2G__A1491,
    iPad_Air_2,
    iPad_mini_2,
    iPad_mini_3,
    iPad_mini_4
};
