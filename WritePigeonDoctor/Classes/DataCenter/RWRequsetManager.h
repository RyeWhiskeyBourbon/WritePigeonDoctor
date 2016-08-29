//
//  RWRequsetManager.h
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/4/26.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "RWRequestIndex.h"
#import "RWDataModels.h"
#import "RWOrderView.h"

@protocol RWRequsetDelegate <NSObject>

@optional

- (void)requsetOfficeList:(NSArray *)officeList
          responseMessage:(NSString *)responseMessage;

- (void)requsetOfficeDoctorList:(NSArray *)officeDoctorList
                responseMessage:(NSString *)responseMessage;

- (void)requsetOfficeDoctor:(RWDoctorItem *)doctor
            responseMessage:(NSString *)responseMessage;


- (void)orderReceipt:(RWOrder *)order
     responseMessage:(NSString *)responseMessage;

- (void)searchResultOrders:(NSArray *)orders
           responseMessage:(NSString *)responseMessage;


- (void)userLoginSuccess:(BOOL)success
         responseMessage:(NSString *)responseMessage;

- (void)userRegisterSuccess:(BOOL)success
            responseMessage:(NSString *)responseMessage;

- (void)userReplacePasswordResponds:(BOOL)success
                    responseMessage:(NSString *)responseMessage;

@end

@interface RWRequsetManager : NSObject

@property (nonatomic,assign)id <RWRequsetDelegate> delegate;

@property (nonatomic,strong)AFHTTPSessionManager *requestManager;

@property (nonatomic,strong)NSDictionary *errorDescription;


- (void)obtainOfficeList;
- (void)obtainOfficeDoctorListWithURL:(NSString *)url page:(NSInteger)page;
- (void)obtainDoctorWithDoctorID:(NSString *)doctorID;

- (void)bulidOrderWith:(RWOrder *)order;

- (void)searchOrderWithUserName:(NSString *)username
                    orderStatus:(RWOrderStatus)orderStatus;
- (void)searchOrderWithDoctorUserName:(NSString *)doctorUserName
                          orderStatus:(RWOrderStatus)orderStatus;
- (void)searchOrderWithOrderStatus:(RWOrderStatus)status
                               fid:(RWServiceSite)fid
                               pid:(RWServiceType)pid;

@end
