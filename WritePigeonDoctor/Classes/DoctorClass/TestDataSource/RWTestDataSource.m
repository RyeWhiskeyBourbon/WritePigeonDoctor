//
//  RWTestDataSource.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/7/31.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWTestDataSource.h"
#import "RWDataModels.h"

@implementation RWTestDataSource

+ (NSArray *)images
{
    return @[[UIImage imageNamed:@"中医儿科.jpg"],
             [UIImage imageNamed:@"中医内科.jpg"],
             [UIImage imageNamed:@"中医外科.jpg"],
             [UIImage imageNamed:@"中医妇科.jpg"],
             [UIImage imageNamed:@"中医男科.jpg"],
             [UIImage imageNamed:@"中医眼科.jpg"],
             [UIImage imageNamed:@"中医美容.jpg"],
             [UIImage imageNamed:@"中医肾科.jpg"],
             [UIImage imageNamed:@"中医骨科.jpg"],
             [UIImage imageNamed:@"内分泌科.jpg"],
             [UIImage imageNamed:@"呼吸内科.jpg"],
             [UIImage imageNamed:@"心血管科.jpg"],
             [UIImage imageNamed:@"治未病科.jpg"],
             [UIImage imageNamed:@"消化内科.jpg"],
             [UIImage imageNamed:@"疑难杂症.jpg"],
             [UIImage imageNamed:@"皮肤病科.jpg"],
             [UIImage imageNamed:@"神经内科.jpg"],
             [UIImage imageNamed:@"耳鼻喉科.jpg"],
             [UIImage imageNamed:@"肿瘤内科.jpg"],
             [UIImage imageNamed:@"血液病科.jpg"],
             [UIImage imageNamed:@"针灸推拿.jpg"],
             [UIImage imageNamed:@"风湿免疫.jpg"]];
}

+ (NSArray *)getResource
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    NSArray *images = [RWTestDataSource images];
    
    for (int i = 0; i < images.count; i++)
    {
        RWOfficeItem *item = [[RWOfficeItem alloc] init];
        
        item.image = images[i];
        item.doctorList = [RWTestDataSource getDoctorList];
        
        
        [arr addObject:item];
        
    }
    
    return arr;
}

+ (NSArray *)getDoctorList
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 30; i++)
    {
        RWDoctorItem *item = [[RWDoctorItem alloc] init];
        
        item.header = [UIImage imageNamed:@"MY"];
        item.name = @"路人甲";
        item.professionalTitle = @"青岛市 XXX医院 著名医师";
        item.office = @"测试科室";
        item.announcement = @"这是一个测试公告";
        item.homeVisitList = [RWTestDataSource getHomeVisitList];
        item.expenses = @[@"￥50.00元 / 2小时"];
        item.EMID = @"iOSTest003";
        item.doctorDescription = @"测试医生简介！！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！";
        
        [arr addObject:item];
    }
    
    return arr;
}

+ (RWWeekHomeVisit *)getHomeVisitList
{
    RWWeekHomeVisit *visit = [[RWWeekHomeVisit alloc] init];
    
    RWHomeVisitItem *item = [[RWHomeVisitItem alloc] init];
    
    item.morning = @"在 XXXX 路 XX 号 XXXXXX 坐诊";
    item.afternoon = @"在 XXXX 路 XX 号 XXXXXX 坐诊";
    item.night = @"在 XXXX 路 XX 号 XXXXXX 坐诊";
    
    visit.Monday = item;
    visit.Tuesday = item;
    visit.Wednesday = nil;
    visit.Thursday = nil;
    visit.Friday = nil;
    visit.Saturday = item;
    visit.Sunday = item;
    
    return visit;
}

@end
