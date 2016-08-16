//
//  RWSettingsManager.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/8/10.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWSettingsManager.h"
#import "NSData+Base64.h"
#import <sys/utsname.h>

#ifndef __SETTINGS_NAME__
#define __SETTINGS_NAME__ @"Settings.plist"
#endif

#ifndef __SETTINGS_PATH__
#define __SETTINGS_PATH__ [__SANDBOX_PATH__ stringByAppendingPathComponent:__SETTINGS_NAME__]
#endif

#ifndef __SCREEN_320x480_INCH__
#define __SCREEN_320x480_INCH__ (__MAIN_SCREEN_WIDTH__ == 320 && __MAIN_SCREEN_HEIGHT__ == 480)
#endif
#ifndef __SCREEN_320x568_INCH__
#define __SCREEN_320x568_INCH__ (__MAIN_SCREEN_WIDTH__ == 320 && __MAIN_SCREEN_HEIGHT__ == 568)
#endif
#ifndef __SCREEN_375x667_INCH__
#define __SCREEN_375x667_INCH__ (__MAIN_SCREEN_WIDTH__ == 375 && __MAIN_SCREEN_HEIGHT__ == 667)
#endif
#ifndef __SCREEN_414x763_INCH__
#define __SCREEN_414x763_INCH__ (__MAIN_SCREEN_WIDTH__ == 414 && __MAIN_SCREEN_HEIGHT__ == 763)
#endif
#ifndef __SCREEN_768x1024_INCH__
#define __SCREEN_768x1024_INCH__ (__MAIN_SCREEN_WIDTH__ == 768 && __MAIN_SCREEN_HEIGHT__ == 1024)
#endif
#ifndef __SCREEN_1024x1366_INCH__
#define __SCREEN_1024x1366_INCH__ (__MAIN_SCREEN_WIDTH__ == 1024 && __MAIN_SCREEN_HEIGHT__ == 1366)
#endif


@implementation RWSettingsManager

+ (instancetype)systemSettings
{
    static RWSettingsManager *_Settings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _Settings = [super allocWithZone:NULL];
        [_Settings setDefaultSettings];
    });
    
    return _Settings;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [RWSettingsManager systemSettings];
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return [RWSettingsManager systemSettings];
}

+ (id)mutableCopyWithZone:(struct _NSZone *)zone
{
    return [RWSettingsManager systemSettings];
}

- (void)setDefaultSettings
{
    BOOL isDerectory = NO;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isFileExist = [fileManager fileExistsAtPath:__SETTINGS_PATH__ isDirectory:&isDerectory];
    
    if (!isFileExist)
    {
        NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
        
        [settings setObject:@(YES)
                     forKey:FIRST_OPEN_APPILCATION];
        [settings setObject:@(YES)
                     forKey:__AUTO_LOGIN__];
        
        if ([settings writeToFile:__SETTINGS_PATH__ atomically:YES])
        {
            MESSAGE(@"设置列表配置失败");
        }
    }
    
    NSDictionary *settings =
                        [NSDictionary dictionaryWithContentsOfFile:__SETTINGS_PATH__];
    
    _settings = [settings mutableCopy];
}

- (BOOL)setSettingsValue:(id)value forKey:(NSString *)key
{
    NSMutableDictionary *settings = [[NSMutableDictionary dictionaryWithContentsOfFile:__SETTINGS_PATH__] mutableCopy];
        
    if ([value isKindOfClass:[NSString class]])
    {
        [settings setObject:[RWSettingsManager encryptionString:value]
                         forKey:key];
    }
    else
    {
        [settings setObject:value forKey:key];
    }
    
    _settings = settings;
        
    return [settings writeToFile:__SETTINGS_PATH__ atomically:YES];
}

- (id)settingsValueForKey:(NSString *)key
{
    NSDictionary *settings =
                [NSDictionary dictionaryWithContentsOfFile:__SETTINGS_PATH__];
    
    if ([[settings objectForKey:key] isKindOfClass:[NSString class]])
    {
        return [RWSettingsManager declassifyString:[settings objectForKey:key]];
    }
    
    return [settings objectForKey:key];
}

- (BOOL)removeSettingsValueForKey:(NSString *)key
{
    NSMutableDictionary *settings = [[NSMutableDictionary dictionaryWithContentsOfFile:__SETTINGS_PATH__] mutableCopy];
    
    [settings removeObjectForKey:key];
    
    _settings = settings;
    
    return [settings writeToFile:__SETTINGS_PATH__ atomically:YES];
}

+ (NSString *)encryptionString:(NSString *)string
{
    NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    return [stringData base64EncodedString];
}

+ (NSString *)declassifyString:(NSString *)string
{
    NSData *stringData = [NSData dataFromBase64String:string];
    
    return [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];
}

+ (void)promptToViewController:(__kindof UIViewController *)viewController Title:(NSString *)title response:(void(^)(void))response
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"友情提示" message:title preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *registerAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        if (response) response();
    }];
    
    [alert addAction:registerAction];
    
    [viewController presentViewController:alert animated:YES completion:nil];
    
}

+ (AppleProductModels)deviceVersion
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine
                                            encoding:NSUTF8StringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return iPhone_2G__A1203;
    if ([platform isEqualToString:@"iPhone1,2"]) return iPhone_3G__A1241_A1324;
    if ([platform isEqualToString:@"iPhone2,1"]) return iPhone_3GS__A1303_A1325;
    if ([platform isEqualToString:@"iPhone3,1"]) return iPhone_4__A1332;
    if ([platform isEqualToString:@"iPhone3,2"]) return iPhone_4__A1332;
    if ([platform isEqualToString:@"iPhone3,3"]) return iPhone_4__A1349;
    if ([platform isEqualToString:@"iPhone4,1"]) return iPhone_4S__A1387_A1431;
    if ([platform isEqualToString:@"iPhone5,1"]) return iPhone_5__A1428;
    if ([platform isEqualToString:@"iPhone5,2"]) return iPhone_5__A1429_A1442;
    if ([platform isEqualToString:@"iPhone5,3"]) return iPhone_5c__A1456_A1532;
    if ([platform isEqualToString:@"iPhone5,4"])
                                        return iPhone_5c__A1507_A1516_A1526_A1529;
    if ([platform isEqualToString:@"iPhone6,1"]) return iPhone_5s__A1453_A1533;
    if ([platform isEqualToString:@"iPhone6,2"])
                                            return iPhone_5s__A1457_A1518_A1528_A1530;
    if ([platform isEqualToString:@"iPhone7,1"]) return iPhone_6_Plus__A1522_A1524;
    if ([platform isEqualToString:@"iPhone7,2"]) return iPhone_6__A1549_A1586;
    if ([platform isEqualToString:@"iPhone8,1"])
                                            return iPhone_6s__A1633_A1688_A1691_A1700;
    if ([platform isEqualToString:@"iPhone8,2"])
                                        return iPhone_6s_Plus__A1634_A1687_A1690_A1699;
    if ([platform isEqualToString:@"iPhone8,4"]) return iPhone_SE__A1662_A1723_A1724;
    if ([platform isEqualToString:@"iPod1,1"])  return iPod_Touch_1G__A1213;
    if ([platform isEqualToString:@"iPod2,1"])  return iPod_Touch_2G__A1288;
    if ([platform isEqualToString:@"iPod3,1"])  return iPod_Touch_3G__A1318;
    if ([platform isEqualToString:@"iPod4,1"])  return iPod_Touch_4G__A1367;
    if ([platform isEqualToString:@"iPod5,1"])  return iPod_Touch_5G__A1421_A1509;
    if ([platform isEqualToString:@"iPod7,1"])  return iPod_touch_6G__A1574;
    if ([platform isEqualToString:@"iPad1,1"])  return iPad_1G__A1219_A1337;
    if ([platform isEqualToString:@"iPad2,1"])  return iPad_2__A1395;
    if ([platform isEqualToString:@"iPad2,2"])  return iPad_2__A1396;
    if ([platform isEqualToString:@"iPad2,3"])  return iPad_2__A1397;
    if ([platform isEqualToString:@"iPad2,4"])  return iPad_2__A1395_New_Chip;
    if ([platform isEqualToString:@"iPad2,5"])  return iPad_Mini_1G__A1432;
    if ([platform isEqualToString:@"iPad2,6"])  return iPad_Mini_1G__A1454;
    if ([platform isEqualToString:@"iPad2,7"])  return iPad_Mini_1G__A1455;
    if ([platform isEqualToString:@"iPad3,1"])  return iPad_3__A1416;
    if ([platform isEqualToString:@"iPad3,2"])  return iPad_3__A1403;
    if ([platform isEqualToString:@"iPad3,3"])  return iPad_3__A1430;
    if ([platform isEqualToString:@"iPad3,4"])  return iPad_4__A1458;
    if ([platform isEqualToString:@"iPad3,5"])  return iPad_4__A1459;
    if ([platform isEqualToString:@"iPad3,6"])  return iPad_4__A1460;
    if ([platform isEqualToString:@"iPad4,1"])  return iPad_Air__A1474;
    if ([platform isEqualToString:@"iPad4,2"])  return iPad_Air__A1475;
    if ([platform isEqualToString:@"iPad4,3"])  return iPad_Air__A1476;
    if ([platform isEqualToString:@"iPad4,4"])  return iPad_Mini_2G__A1489;
    if ([platform isEqualToString:@"iPad4,5"])  return iPad_Mini_2G__A1490;
    if ([platform isEqualToString:@"iPad4,6"])  return iPad_Mini_2G__A1491;
    if ([platform isEqualToString:@"iPad5,3"])  return iPad_Air_2;
    if ([platform isEqualToString:@"iPad5,4"])  return iPad_Air_2;
    if ([platform isEqualToString:@"i386"])     return iPhone_Simulator;
    if ([platform isEqualToString:@"x86_64"])   return iPhone_Simulator;
    if ([platform isEqualToString:@"iPad4,4"])  return iPad_mini_2;
    if ([platform isEqualToString:@"iPad4,5"])  return iPad_mini_2;
    if ([platform isEqualToString:@"iPad4,6"])  return iPad_mini_2;
    if ([platform isEqualToString:@"iPad4,7"])  return iPad_mini_3;
    if ([platform isEqualToString:@"iPad4,8"])  return iPad_mini_3;
    if ([platform isEqualToString:@"iPad4,9"])  return iPad_mini_3;
    if ([platform isEqualToString:@"iPad5,1"])  return iPad_mini_4;
    if ([platform isEqualToString:@"iPad5,2"])  return iPad_mini_4;
    
    return 0x108943;
}

- (void)addLocalNotificationWithClockString:(NSString *)clockString AndName:(NSString *)name content:(NSString *)content
{
    RWClockAttribute attribute = [NSDate clockAttributeWithString:clockString];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    NSString *week = [dateFormatter stringFromDate:[NSDate date]];
    
    NSInteger afterDays;
    
    if (attribute.week == RWClockWeekOfNone)
    {
        BOOL isPast = [NSDate isPastTime:attribute.hours minute:attribute.minute];
        
        if (isPast)
        {
            afterDays = 1;
        }
        else
        {
            afterDays = 0;
        }
    }
    else
    {
        afterDays = [NSDate daysFromClockTimeWithClockWeek:attribute.week
                                             AndWeekString:week];
    }
    
    NSDate *clockDate = [NSDate buildClockDateWithAfterDays:afterDays
                                                      Hours:attribute.hours
                                                  AndMinute:attribute.minute];
    
    [self addAlarmClockWithTime:clockDate
                          Cycle:attribute.cycleType
                      ClockName:name
                        Content:content];
}

- (void)addAlarmClockWithTime:(NSDate *)date Cycle:(RWClockCycle)cycle ClockName:(NSString *)name Content:(NSString *)content
{
    UIUserNotificationType types =  UIUserNotificationTypeBadge |
    UIUserNotificationTypeSound |
    UIUserNotificationTypeAlert;
    
    UIUserNotificationSettings *mySettings =
    [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    
    if (notification!=nil) {
        
        notification.fireDate = date;
        
        switch (cycle) {
                
            case RWClockCycleOnce:
                
                notification.repeatInterval = kCFCalendarUnitEra;
                
                break;
                
            case RWClockCycleEveryDay:
                
                notification.repeatInterval = kCFCalendarUnitDay;
                
                break;
                
            case RWClockCycleEveryWeek:
                
                notification.repeatInterval = kCFCalendarUnitWeekday;
                
                break;
                
            default:
                break;
        }
        
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.alertBody = content;
        notification.applicationIconBadgeNumber = 0;
        //        notification.userInfo = @{CLOCK_NAMES:name};
        notification.soundName = @"ClockSound2.mp3";
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

- (void)cancelLocalNotificationWithName:(NSString *)name
{
    NSArray *notifications =
    [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    for (int i = 0; i < notifications.count; i++)
    {
        //        if ([[[notifications[i] valueForKey:@"userInfo"]
        //                                objectForKey:CLOCK_NAMES] isEqualToString:name])
        //        {
        //            [[UIApplication sharedApplication]
        //                                        cancelLocalNotification:notifications[i]];
        //        }
    }
}

#pragma mark - runtime

+ (NSArray *)obtainAllKeysWithObjectClass:(Class)objectClass
{
    unsigned int ivarCut = 0;
    
    Ivar *ivars = class_copyIvarList(objectClass, &ivarCut);
    
    NSMutableArray *nameArr = [[NSMutableArray alloc]init];
    
    for (const Ivar *p = ivars; p < ivars + ivarCut; p++) {
        
        Ivar const ivar = *p;
        
        NSString *name = [NSString stringWithUTF8String:ivar_getName(ivar)];
        
        [nameArr addObject:name];
    }
    
    return [RWSettingsManager clearFirstString:nameArr];
}

+ (NSArray *)clearFirstString:(NSArray *)arr {
    
    NSMutableArray *mArr = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < arr.count; i++) {
        NSMutableString *str = [[NSMutableString alloc]initWithString:arr[i]];
        
        [str deleteCharactersInRange:NSMakeRange(0, 1)];
        
        [mArr addObject:str];
    }
    
    return mArr;
}

@end
