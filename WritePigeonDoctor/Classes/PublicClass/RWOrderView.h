//
//  RWOrderView.h
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/8/19.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>

@class RWOrder,RWServiceDetail;

@interface RWOrderView : UITableView

+ (instancetype)orderViewAutoLayout:(void(^)(MASConstraintMaker *make))autoLayout
                              order:(RWOrder *)order;

@property (nonatomic,strong)RWOrder *order;

@property (nonatomic,copy)void(^autoLayout)(MASConstraintMaker *make);

@end

@interface RWOrderView (OrderStatus)

- (NSInteger)waitForServiceOrderNumberOfRowsInSection:(NSInteger)section;

- (CGFloat)waitForServiceOrderHeightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (UITableViewCell *)waitForServiceOrderAtTableView:(UITableView *)tableView
                              cellForRowAtIndexPath:(NSIndexPath *)indexPath;


- (NSInteger)inServiceOrderNumberOfRowsInSection:(NSInteger)section;

- (CGFloat)inServiceOrderHeightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (UITableViewCell *)inServiceOrderAtTableView:(UITableView *)tableView
                         cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface RWOrderViewCell : UITableViewCell

@property (nonatomic,strong,readonly)UITextView *descriptionView;
@property (nonatomic,strong)NSString *descriptionTitle;

@end

@interface RWOrderIDView : UIView

@property (nonatomic,strong)UILabel *orderId;

@property (nonatomic,strong)UILabel *orderStatus;

@end

@class RWNextStepView;

@protocol RWNextStepViewDelegate <NSObject>
@optional

- (void)toNextStep:(RWNextStepView *)nextStep;
- (void)detailsForInformationAtNextStep:(RWNextStepView *)nextStep;

@end

@interface RWNextStepView : UIView

+ (instancetype)nextStepTitle:(NSString *)title information:(NSString *)information autoLayout:(void(^)(MASConstraintMaker *make))autoLayout;

@property (nonatomic,strong)UIButton *nextStep;
@property (nonatomic,strong)UILabel *information;

@property (nonatomic,copy)void(^autoLayout)(MASConstraintMaker *make);

@property (nonatomic,strong)id<RWNextStepViewDelegate> delegate;

@end


typedef NS_ENUM(NSInteger,RWPayMethot)
{
    RWPayMethotWXPay = 1,
    RWPayMethotAlipay
};

typedef NS_ENUM(NSInteger,RWOrderStatus)
{
    RWOrderStatusTimeOut            = -4,
    RWOrderStatusServiceCancel      = -3,
    RWOrderStatusUserCancel         = -2,
    RWOrderStatusNotPay             = -1,
    RWOrderStatusWaitService        = 1,
    RWOrderStatusWaitUserStart,
    RWOrderStatusServiceStart,
    RWOrderStatusServiceServiceEnd,
    RWOrderStatusUserConfirmEnd,
};

typedef NS_ENUM(NSInteger,RWServiceType)
{
    RWServiceTypeConsult = 0,
    RWServiceTypeAccompanyTreat,
    RWServiceTypeGetTestReport,
    RWServiceTypeInject
};

typedef NS_ENUM(NSInteger,RWServiceSite)
{
    RWServiceSiteInApp = 1,
    RWServiceSiteInHome,
    RWServiceSiteInHospital
};

NSString *stringOrderStatus(RWOrderStatus orderstatus);
NSString *stringPayMethot(RWPayMethot payMethot);
NSString *stringServiceType(RWServiceType serviceType);
NSString *stringServiceSite(RWServiceSite serviceSite);

NSNumber *OrderStatusWithString(NSString *orderstatus);
NSNumber *payMethotWithString(NSString * payMethot);
NSNumber *serviceTypeWithString(NSString * serviceType);
NSNumber *serviceSiteWithString(NSString * serviceSite);

@interface RWOrder : NSObject

+ (instancetype)consultOrderWithUserName:(NSString *)username
                               serviceid:(NSString *)serviceid
                      servicedescription:(RWServiceDetail *)serservicedescription;

+ (instancetype)appointmentOrderWithUserName:(NSString *)username
                          servicedescription:(RWServiceDetail *)serservicedescription;

@property (nonatomic,strong,readonly)NSDictionary *body;

@property (nonatomic,strong)NSString *orderid;
@property (nonatomic,strong)NSString *payid;
@property (nonatomic,strong)NSString *serviceid;
@property (nonatomic,strong)RWServiceDetail *servicedescription;
@property (nonatomic,strong)NSString *buildDate;
@property (nonatomic,strong)NSString *payDate;
@property (nonatomic,strong)NSString *closeDate;
@property (nonatomic,assign)RWOrderStatus orderstatus;
@property (nonatomic,assign)RWPayMethot payMethot;
@property (nonatomic,strong)NSString *payMessage;
@property (nonatomic,strong)NSString *serviceMessage;
@property (nonatomic,strong)NSString *doctorname;
@property (nonatomic,assign)float money;

@property (nonatomic,strong)id payOrder;

@property (nonatomic,assign)RWServiceSite fid;
@property (nonatomic,assign)RWServiceType pid;

#pragma mark - extern

@property (nonatomic,assign)BOOL isComplaint;
@property (nonatomic,strong)NSString *useridea;
@property (nonatomic,strong)NSNumber *star;

@end

@interface RWService : NSObject

+ (instancetype)serviceWithServiceImage:(NSString *)serviceImage
                            serviceName:(NSString *)serviceName
                               maxMoney:(NSString *)maxMoney
                               minMoney:(NSString *)minMoney
                              serviceId:(RWServiceType)serviceId
                     serviceDescription:(NSString *)serviceDescription;

@property (nonatomic,copy)NSString *serviceImage;
@property (nonatomic,copy)NSString *serviceName;
@property (nonatomic,copy)NSString *maxMoney;
@property (nonatomic,copy)NSString *minMoney;
@property (nonatomic,assign)RWServiceType serviceId;
@property (nonatomic,copy)NSString *serviceDescription;

@property (nonatomic,strong,readonly)NSString *money;

@end

@interface RWServiceDetail : NSObject

+ (instancetype)serviceDetailWithDescription:(NSString *)description;

- (NSString *)verificationResource;

@property (nonatomic,strong)NSNumber *serviceType;
@property (nonatomic,strong)NSNumber *serviceSite;
@property (nonatomic,copy)NSString *date;
@property (nonatomic,copy)NSString *province;
@property (nonatomic,copy)NSString *hospital;
@property (nonatomic,copy)NSString *address;
@property (nonatomic,copy)NSString *office;
@property (nonatomic,copy)NSString *doctor;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *contactWay;
@property (nonatomic,copy)NSString *comments;

@end

