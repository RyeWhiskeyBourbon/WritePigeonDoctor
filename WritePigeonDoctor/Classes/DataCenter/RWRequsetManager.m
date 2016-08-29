//
//  RWRequsetManager.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/4/26.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWRequsetManager.h"
#import "RWRequsetManager+UserLogin.h"
#import "RWDataModels.h"
#import <objc/runtime.h>

@interface RWRequsetManager ()

@end

@implementation RWRequsetManager

#pragma mark - init

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        _requestManager = [AFHTTPSessionManager manager];
        _requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        _errorDescription = @{@"200":@"操作成功",
                              @"201":@"客户端版本不对，需升级sdk",
                              @"301":@"被封禁",
                              @"302":@"用户名或密码错误",
                              @"315":@"IP限制",
                              @"403":@"非法操作或没有权限",
                              @"404":@"对象不存在",
                              @"405":@"参数长度过长",
                              @"406":@"对象只读",
                              @"408":@"客户端请求超时",
                              @"413":@"验证失败(短信服务)",
                              @"414":@"参数错误",
                              @"415":@"客户端网络问题",
                              @"416":@"频率控制",
                              @"417":@"重复操作",
                              @"418":@"通道不可用(短信服务)",
                              @"419":@"数量超过上限",
                              @"422":@"账号被禁用",
                              @"431":@"HTTP重复请求"};
    }
    
    return self;
}

- (void)obtainOfficeList
{
    [_requestManager GET:__OFFICE_LIST__ parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *JsonArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if (JsonArr)
        {
            NSMutableArray *offices = [[NSMutableArray alloc] init];
            
            for (NSDictionary *item in JsonArr)
            {
                RWOfficeItem *office = [[RWOfficeItem alloc] init];
                
                office.image = item[@"officeimage"];
                office.doctorList = item[@"doctorlist"];
                
                [offices addObject:office];
            }
            
            if (found_response(_delegate,@"requsetOfficeList:responseMessage:"))
            {
                [_delegate requsetOfficeList:offices responseMessage:nil];
            }
        }
        else
        {
            if (found_response(_delegate,@"requsetOfficeList:responseMessage:"))
            {
                [_delegate requsetOfficeList:nil responseMessage:@"服务器信息获取失败"];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (!__NET_STATUS__)
        {
            if (found_response(_delegate,@"requsetOfficeList:responseMessage:"))
            {
                [_delegate requsetOfficeList:nil responseMessage:@"网络连接失败，请检查网络"];
            }
        }
        else
        {
            if (found_response(_delegate,@"requsetOfficeList:responseMessage:"))
            {
                [_delegate requsetOfficeList:nil responseMessage:@"服务器连接失败"];
            }
        }
    }];
}

- (void)obtainOfficeDoctorListWithURL:(NSString *)url page:(NSInteger)page
{
    [_requestManager POST:url parameters:@{@"udid":__TOKEN_KEY__,@"page":@(page)} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *Json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([Json[@"resultcode"] integerValue] == 200)
        {
            NSArray *doctors = Json[@"result"];
            
            NSMutableArray *doctorItem = [[NSMutableArray alloc] init];
            
            for (NSDictionary *doctor in doctors)
            {
                [doctorItem addObject:[self doctorItemWithJson:doctor]];
            }
            
            if (found_response(_delegate,@"requsetOfficeDoctorList:responseMessage:"))
            {
                [_delegate requsetOfficeDoctorList:doctorItem responseMessage:nil];
            }
        }
        else
        {
            if (found_response(_delegate,@"requsetOfficeDoctorList:responseMessage:"))
            {
                [_delegate requsetOfficeDoctorList:nil responseMessage:Json[@"result"]];
            }
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (!__NET_STATUS__)
        {
            if (found_response(_delegate,@"requsetOfficeDoctorList:responseMessage:"))
            {
                [_delegate requsetOfficeDoctorList:nil
                                   responseMessage:@"网络连接失败，请检查网络"];
            }
        }
        else
        {
            if (found_response(_delegate,@"requsetOfficeDoctorList:responseMessage:"))
            {
                [_delegate requsetOfficeDoctorList:nil
                                   responseMessage:@"服务器连接失败"];
            }
        }

    }];
}

- (void)obtainDoctorWithDoctorID:(NSString *)doctorID
{
    [_requestManager POST:__SEARCH_DOCTOR__
               parameters:@{@"username":doctorID}
                 progress:nil
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSDictionary *Json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([Json[@"resultcode"] integerValue] == 200)
        {
            NSDictionary *doctor = Json[@"result"];
            
            if (!doctor)
            {
                if (found_response(_delegate,@"requsetOfficeDoctor:responseMessage:"))
                {
                    [_delegate requsetOfficeDoctor:nil
                                   responseMessage:@"返回数据异常，请稍后重试"];
                }
                
                return;
            }
            
            if (found_response(_delegate,@"requsetOfficeDoctor:responseMessage:"))
            {
                [_delegate requsetOfficeDoctor:[self doctorItemWithJson:doctor]
                                responseMessage:nil];
            }
        }
        else
        {
            if (found_response(_delegate,@"requsetOfficeDoctor:responseMessage:"))
            {
                [_delegate requsetOfficeDoctor:nil
                               responseMessage:Json[@"result"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (!__NET_STATUS__)
        {
            if (found_response(_delegate,@"requsetOfficeDoctor:responseMessage:"))
            {
                [_delegate requsetOfficeDoctor:nil
                               responseMessage:@"网络连接失败，请检查网络"];
            }
        }
        else
        {
            if (found_response(_delegate,@"requsetOfficeDoctor:responseMessage:"))
            {
                [_delegate requsetOfficeDoctor:nil
                               responseMessage:@"服务器连接失败"];
            }
        }
    }];
}

- (void)bulidOrderWith:(RWOrder *)order
{
    [_requestManager POST:__BULID_ORDER__
               parameters:order.body
                 progress:nil
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSDictionary *Json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([Json[@"resultcode"] integerValue] == 200)
        {
            NSDictionary *JsonOrder = Json[@"result"];
            
            RWOrder *serviceOrder = [self analysisJsonOrder:JsonOrder];
            
            if (serviceOrder)
            {
                if (found_response(_delegate,@"orderReceipt:responseMessage:"))
                {
                    [_delegate orderReceipt:serviceOrder
                            responseMessage:nil];
                }
            }
            else
            {
                if (found_response(_delegate,@"orderReceipt:responseMessage:"))
                {
                    [_delegate orderReceipt:nil
                            responseMessage:@"订单创建失败，请稍后重试"];
                }
            }
        }
        else
        {
            if (found_response(_delegate,@"orderReceipt:responseMessage:"))
            {
                [_delegate orderReceipt:nil
                        responseMessage:Json[@"result"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (!__NET_STATUS__)
        {
            if (found_response(_delegate,@"orderReceipt:responseMessage:"))
            {
                [_delegate orderReceipt:nil
                        responseMessage:@"网络连接失败，请检查网络"];
            }
        }
        else
        {
            if (found_response(_delegate,@"orderReceipt:responseMessage:"))
            {
                [_delegate orderReceipt:nil
                        responseMessage:@"服务器连接失败"];
            }
        }
    }];
}

- (void)searchOrderWithUserName:(NSString *)username
                    orderStatus:(RWOrderStatus)orderStatus
{
    NSDictionary *body = orderStatus == 0?
                         @{@"username":username,
                           @"udid":__TOKEN_KEY__}:
                         @{@"username":username,
                           @"orderStatus":@(orderStatus),
                           @"udid":__TOKEN_KEY__};
    [self searchOrderWithBody:body];
}

- (void)searchOrderWithDoctorUserName:(NSString *)doctorUserName
                          orderStatus:(RWOrderStatus)orderStatus
{
    NSDictionary *body = orderStatus == 0?
                         @{@"docotorname":doctorUserName,
                           @"udid":__TOKEN_KEY__}:
                         @{@"docotorname":doctorUserName,
                           @"orderStatus":@(orderStatus),
                           @"udid":__TOKEN_KEY__};
    [self searchOrderWithBody:body];
}

- (void)searchOrderWithOrderid:(NSString *)orderid
{
    NSDictionary *body = @{@"orderid":orderid,
                           @"udid":__TOKEN_KEY__};
    [self searchOrderWithBody:body];
}

- (void)searchOrderWithOrderStatus:(RWOrderStatus)status
                               fid:(RWServiceSite)fid
                               pid:(RWServiceType)pid
{
    NSDictionary *body = @{@"orderStatus":@(status),
                           @"fid":@(fid),
                           @"pid":@(pid),
                           @"udid":__TOKEN_KEY__};
    [self searchOrderWithBody:body];
}

- (void)searchOrderWithBody:(NSDictionary *)body
{
    [_requestManager POST:__SEARCH_ORDER__ parameters:body progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *Json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([Json[@"resultcode"] integerValue] == 200)
        {
            NSArray *JsonOrders = Json[@"result"];
            
            NSMutableArray *orders = [[NSMutableArray alloc] init];
            
            for (NSDictionary *JsonOrder in JsonOrders)
            {
                [orders addObject:[self analysisJsonOrder:JsonOrder]];
            }
            
            if (orders.count)
            {
                if (found_response(_delegate,@"searchResultOrders:responseMessage:"))
                {
                    [_delegate searchResultOrders:orders
                                  responseMessage:nil];
                }
            }
            else
            {
                if (found_response(_delegate,@"searchResultOrders:responseMessage:"))
                {
                    [_delegate searchResultOrders:nil
                                  responseMessage:@"未发现历史订单"];
                }
            }
        }
        else
        {
            if (found_response(_delegate,@"searchResultOrders:responseMessage:"))
            {
                [_delegate searchResultOrders:nil
                              responseMessage:Json[@"result"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (found_response(_delegate,@"searchResultOrders:responseMessage:"))
        {
            if (!__NET_STATUS__)
            {
                [_delegate searchResultOrders:nil
                              responseMessage:@"网络连接失败，请检查网络"];
            }
            else
            {
                [_delegate searchResultOrders:nil
                              responseMessage:@"服务器连接失败"];
            }
        }
    }];
}

- (RWDoctorItem *)doctorItemWithJson:(NSDictionary *)Json
{
    RWDoctorItem *item = [[RWDoctorItem alloc] init];
    
    item.name = Json[@"nickname"];
    item.doctorDescription = Json[@"docdp"];
    item.expenses = [Json[@"expenses"] isKindOfClass:[NSArray class]]?
    Json[@"expenses"]:@[@"￥0.00元/次"];
    item.EMID = Json[@"username"];
    item.office = Json[@"grouptitle"];
    item.umid = Json[@"umid"];
    item.professionalTitle = [NSString stringWithFormat:@"%@  %@",Json[@"hos"],Json[@"title"]];
    item.announcement = Json[@"notice"];
    
    if (Json[@"homevisitlist"] && [Json[@"homevisitlist"] length] != 0)
    {
        RWWeekHomeVisit *home = [[RWWeekHomeVisit alloc] init];
        
        NSArray *homeKeys = [RWSettingsManager obtainAllObjectsAtClass:[RWWeekHomeVisit class]];
        
        for (NSString *homeKey in homeKeys)
        {
            if (Json[@"homevisitlist"][homeKey])
            {
                RWHomeVisitItem *visitItem;
                
                NSArray *itemKeys = [RWSettingsManager obtainAllObjectsAtClass:[RWWeekHomeVisit class]];
                
                for (NSString *itemKey in itemKeys)
                {
                    if (Json[@"homevisitlist"][homeKey][itemKey])
                    {
                        visitItem = visitItem?visitItem:[[RWHomeVisitItem alloc] init];
                        
                        [visitItem setValue:Json[@"homevisitlist"][homeKey][itemKey]
                                     forKey:itemKey];
                    }
                    
                    if (visitItem)
                    {
                        [home setValue:visitItem forKey:homeKey];
                    }
                }
            }
        }
        
        item.homeVisitList = home;
    }
    
    return item;
}

- (RWOrder *)analysisJsonOrder:(NSDictionary *)JsonOrder
{
    RWOrder *serviceOrder = [[RWOrder alloc] init];
    
    serviceOrder.payid = JsonOrder[@"username"];
    serviceOrder.serviceid = JsonOrder[@"docusername"];
    serviceOrder.orderid = JsonOrder[@"id"];
    
    serviceOrder.buildDate = JsonOrder[@"builddate"];
    serviceOrder.payDate = JsonOrder[@"paydate"];
    serviceOrder.closeDate = JsonOrder[@"closedate"];
    
    serviceOrder.orderstatus = [JsonOrder[@"orderstatus"] integerValue];
    serviceOrder.fid = [JsonOrder[@"fid"] integerValue];
    serviceOrder.pid = [JsonOrder[@"pid"] integerValue];
    serviceOrder.money = [JsonOrder[@"totalmoney"] floatValue];
    serviceOrder.serviceMessage = JsonOrder[@"servicemessage"];
    serviceOrder.payMessage = JsonOrder[@"paymessage"];
    
    RWServiceDetail *detail = [RWServiceDetail serviceDetailWithDescription:JsonOrder[@"serviceiddescription"]];
    
    if (detail)
    {
        serviceOrder.servicedescription = detail;
        
        return serviceOrder;
    }
    
    return nil;
}

@end
