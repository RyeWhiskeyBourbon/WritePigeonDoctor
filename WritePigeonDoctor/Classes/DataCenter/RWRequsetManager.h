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

/****************    在线咨询相关    ****************/
/**
 *  返回科室列表
 *
 *  @param officeList      科室列表
 *  @param responseMessage 成功为 nil 失败返回错误信息
 */
- (void)requsetOfficeList:(NSArray *)officeList
          responseMessage:(NSString *)responseMessage;
/**
 *  返回医生列表
 *
 *  @param officeDoctorList 医生列表
 *  @param responseMessage  成功为 nil 失败返回错误信息
 */
- (void)requsetOfficeDoctorList:(NSArray *)officeDoctorList
                responseMessage:(NSString *)responseMessage;
/**
 *  返回医生信息
 *
 *  @param doctor          医生信息
 *  @param responseMessage 成功为 nil 失败返回错误信息
 */
- (void)requsetOfficeDoctor:(RWDoctorItem *)doctor
            responseMessage:(NSString *)responseMessage;

/****************    预约相关    ****************/
/**
 *  返回服务列表
 *
 *  @param servicesList    服务列表
 *  @param responseMessage 成功为 nil 失败返回错误信息
 */
- (void)requsetServicesList:(NSArray *)servicesList
            responseMessage:(NSString *)responseMessage;
/**
 *  返回订单信息
 *
 *  @param order           订单信息
 *  @param responseMessage 成功为 nil 失败返回错误信息
 */
- (void)orderReceipt:(RWOrder *)order
     responseMessage:(NSString *)responseMessage;
/**
 *  订单搜索回调
 *
 *  @param orders          搜索到的订单
 *  @param responseMessage 成功为 nil 失败返回错误信息
 */
- (void)searchResultOrders:(NSArray *)orders
           responseMessage:(NSString *)responseMessage;

/****************    用户登录注册忘记密码    ****************/
/**
 *  用户登录回调
 *
 *  @param success         是否成功
 *  @param responseMessage 成功为 nil 失败返回错误信息
 */
- (void)userLoginSuccess:(BOOL)success
         responseMessage:(NSString *)responseMessage;
/**
 *  用户注册回调
 *
 *  @param success         是否成功
 *  @param responseMessage 成功为 nil 失败返回错误信息
 */
- (void)userRegisterSuccess:(BOOL)success
            responseMessage:(NSString *)responseMessage;
/**
 *  用户重置密码回调
 *
 *  @param success         是否成功
 *  @param responseMessage 成功为 nil 失败返回错误信息
 */
- (void)userReplacePasswordResponds:(BOOL)success
                    responseMessage:(NSString *)responseMessage;

@end

@interface RWRequsetManager : NSObject

@property (nonatomic,assign)id <RWRequsetDelegate> delegate;

@property (nonatomic,strong)AFHTTPSessionManager *requestManager;
@property (nonatomic,strong)NSDictionary *errorDescription;

/**
 *  获取科室列表
 */
- (void)obtainOfficeList;
/**
 *  获取医生列表
 *
 *  @param url  url
 *  @param page 页数
 */
- (void)obtainOfficeDoctorListWithURL:(NSString *)url page:(NSInteger)page;
/**
 *  获取医生信息
 *
 *  @param doctorID 医生id
 */
- (void)obtainDoctorWithDoctorID:(NSString *)doctorID;
/**
 *  获取服务列表
 */
- (void)obtainServicesList;
/**
 *  创建订单
 *
 *  @param order
 */
- (void)bulidOrderWith:(RWOrder *)order;
/**
 *  搜索用户的订单
 *
 *  @param username    用户名
 *  @param orderStatus 订单状态  搜索全部为 0
 */
- (void)searchOrderWithUserName:(NSString *)username
                    orderStatus:(RWOrderStatus)orderStatus;
/**
 *  搜索医生订单
 *
 *  @param doctorUserName 医生id
 *  @param orderStatus    订单状态  搜索全部为 0
 */
- (void)searchOrderWithDoctorUserName:(NSString *)doctorUserName
                          orderStatus:(RWOrderStatus)orderStatus;
/**
 *  搜索符合某种条件的全部订单
 *
 *  @param status 订单状态
 *  @param fid    服务地点
 *  @param pid    服务类型
 */
- (void)searchOrderWithOrderStatus:(RWOrderStatus)status
                               fid:(RWServiceSite)fid
                               pid:(RWServiceType)pid;

@end
