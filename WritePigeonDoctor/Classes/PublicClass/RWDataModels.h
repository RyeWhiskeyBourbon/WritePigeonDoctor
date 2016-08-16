//
//  RWDataModels.h
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/7/27.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class RWWeekHomeVisit,RWHomeVisitItem,RWDoctorItem;

@interface RWOfficeItem : NSObject

@property (nonatomic,strong)NSString *image;
@property (nonatomic,strong)NSString *doctorList;

@end

@interface RWDoctorItem : NSObject

@property (nonatomic,strong,readonly)NSString *header;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *professionalTitle;
@property (nonatomic,strong)NSString *office;
@property (nonatomic,strong)NSString *announcement;
@property (nonatomic,strong)RWWeekHomeVisit *homeVisitList;
@property (nonatomic,strong)NSArray *expenses;
@property (nonatomic,strong)NSString *EMID;
@property (nonatomic,strong)NSString *umid;
@property (nonatomic,strong)NSString *doctorDescription;
@property (nonatomic,assign)BOOL relation;

@end

@interface RWWeekHomeVisit : NSObject

@property (nonatomic,strong)RWHomeVisitItem *Monday;
@property (nonatomic,strong)RWHomeVisitItem *Tuesday;
@property (nonatomic,strong)RWHomeVisitItem *Wednesday;
@property (nonatomic,strong)RWHomeVisitItem *Thursday;
@property (nonatomic,strong)RWHomeVisitItem *Friday;
@property (nonatomic,strong)RWHomeVisitItem *Saturday;
@property (nonatomic,strong)RWHomeVisitItem *Sunday;

@end

@interface RWHomeVisitItem : NSObject

@property (nonatomic,strong)NSString *morning;
@property (nonatomic,strong)NSString *afternoon;
@property (nonatomic,strong)NSString *night;

@end