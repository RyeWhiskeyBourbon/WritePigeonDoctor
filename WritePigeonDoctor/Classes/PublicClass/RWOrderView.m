//
//  RWOrderView.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/8/19.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWOrderView.h"

@interface RWOrderView ()

<
    UITableViewDelegate,
    UITableViewDataSource
>

@end

@implementation RWOrderView

+ (instancetype)orderViewAutoLayout:(void(^)(MASConstraintMaker *make))autoLayout order:(RWOrder *)order
{
    RWOrderView *orderView = [[self alloc] init];
    orderView.order = order;
    orderView.autoLayout = autoLayout;
    
    return orderView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!_order.orderstatus)
    {
        return 0;
    }
    
    if (_order.orderstatus < RWOrderStatusWaitUserStart)
    {
        return [self waitForServiceOrderNumberOfRowsInSection:section];
    }
    else
    {
        return [self inServiceOrderNumberOfRowsInSection:section];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_order.orderstatus < RWOrderStatusWaitUserStart)
    {
        return [self waitForServiceOrderAtTableView:tableView
                              cellForRowAtIndexPath:indexPath];
    }
    else
    {
        return [self inServiceOrderAtTableView:tableView
                         cellForRowAtIndexPath:indexPath];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    RWOrderIDView *idView = [[RWOrderIDView alloc] init];
    
    idView.orderId.text = [NSString stringWithFormat:@"订单号：%@",_order.orderid];
    idView.orderStatus.text = [NSString stringWithFormat:@"订单状态：%@",stringOrderStatus(_order.orderstatus)];
    
    return idView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 140;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_order.orderstatus < RWOrderStatusWaitUserStart)
    {
        return [self waitForServiceOrderHeightForRowAtIndexPath:indexPath];
    }
    else
    {
        return [self inServiceOrderHeightForRowAtIndexPath:indexPath];
    }
}

#pragma mark - init

- (instancetype)init
{
    self = [super initWithFrame:self.bounds style:UITableViewStyleGrouped];
    
    if (self)
    {
        self.delegate = self;
        self.dataSource = self;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.allowsSelection = NO;
        
        [self registerClass:[RWOrderViewCell class] forCellReuseIdentifier:NSStringFromClass([RWOrderViewCell class])];
    }
    
    return self;
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    
    if (_autoLayout)
    {
        [self mas_makeConstraints:_autoLayout];
        
        [self reloadData];
    }
}

- (void)setAutoLayout:(void (^)(MASConstraintMaker *))autoLayout
{
    _autoLayout = autoLayout;
    
    if (_autoLayout && self.window)
    {
        [self mas_remakeConstraints:_autoLayout];
        
        [self reloadData];
    }
}

@end

@implementation RWOrderView (OrderStatus)

- (NSInteger)waitForServiceOrderNumberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (CGFloat)waitForServiceOrderHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 4)
    {
        return 40;
    }
    
    return 120;
}

- (UITableViewCell *)waitForServiceOrderAtTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
            
            cell = cell?cell:[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([UITableViewCell class])];
            
            cell.textLabel.text = @"订单创建时间：";
            cell.textLabel.font = __RWGET_SYSFONT(15);
            cell.detailTextLabel.text = _order.buildDate;
            cell.detailTextLabel.font = __RWGET_SYSFONT(15);
            
            return cell;
        }
        case 1:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
            
            cell = cell?cell:[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([UITableViewCell class])];
            
            cell.textLabel.text = @"支付金额：";
            cell.textLabel.font = __RWGET_SYSFONT(15);
            cell.detailTextLabel.text =
            [NSString stringWithFormat:@"￥%.2f 元",_order.money];
            cell.detailTextLabel.font = __RWGET_SYSFONT(15);
            
            return cell;
        }
        case 2:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
            
            cell = cell?cell:[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([UITableViewCell class])];
            
            cell.textLabel.text = @"支付状态：";
            cell.textLabel.font = __RWGET_SYSFONT(15);
            cell.detailTextLabel.text = _order.orderstatus > 0?@"已支付":@"未支付";
            cell.detailTextLabel.font = __RWGET_SYSFONT(15);
            
            return cell;
        }
        case 3:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
            
            cell = cell?cell:[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([UITableViewCell class])];
            
            cell.textLabel.text = @"服务用户：";
            cell.textLabel.font = __RWGET_SYSFONT(15);
            cell.detailTextLabel.text = _order.servicedescription.name;
            cell.detailTextLabel.font = __RWGET_SYSFONT(15);
            
            return cell;
        }
        case 4:
        {
            RWOrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RWOrderViewCell class]) forIndexPath:indexPath];
            
            cell.textLabel.text = @"服务内容：";
            cell.descriptionTitle = _order.servicedescription.description;
            
            return cell;
        }
        case 5:
        {
            RWOrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RWOrderViewCell class]) forIndexPath:indexPath];
            
            cell.textLabel.text = @"用户备注：";
            cell.descriptionTitle = _order.payMessage;
            
            return cell;
        }
        default:return nil;
    }
}

- (NSInteger)inServiceOrderNumberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)inServiceOrderHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 6)
    {
        return 40;
    }
    
    return 120;
}

- (UITableViewCell *)inServiceOrderAtTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
            
            cell = cell?cell:[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([UITableViewCell class])];
            
            cell.textLabel.text = @"订单创建时间：";
            cell.textLabel.font = __RWGET_SYSFONT(15);
            cell.detailTextLabel.text = _order.buildDate;
            cell.detailTextLabel.font = __RWGET_SYSFONT(15);
            
            return cell;
        }
        case 1:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
            
            cell = cell?cell:[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([UITableViewCell class])];
            
            cell.textLabel.text = @"支付方式：";
            cell.textLabel.font = __RWGET_SYSFONT(15);
            cell.detailTextLabel.text = stringPayMethot(_order.payMethot);
            cell.detailTextLabel.font = __RWGET_SYSFONT(15);
            
            return cell;
        }
        case 2:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
            
            cell = cell?cell:[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([UITableViewCell class])];
            
            cell.textLabel.text = @"支付金额：";
            cell.textLabel.font = __RWGET_SYSFONT(15);
            cell.detailTextLabel.text =
            [NSString stringWithFormat:@"￥%.2f 元",_order.money];
            cell.detailTextLabel.font = __RWGET_SYSFONT(15);
            
            return cell;
        }
        case 3:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
            
            cell = cell?cell:[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([UITableViewCell class])];
            
            cell.textLabel.text = @"支付状态：";
            cell.textLabel.font = __RWGET_SYSFONT(15);
            cell.detailTextLabel.text = _order.orderstatus?@"已支付":@"未支付";
            cell.detailTextLabel.font = __RWGET_SYSFONT(15);
            
            return cell;
        }
        case 4:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
            
            cell = cell?cell:[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([UITableViewCell class])];
            
            cell.textLabel.text = @"服务人员：";
            cell.textLabel.font = __RWGET_SYSFONT(15);
            cell.detailTextLabel.text = _order.doctorname;
            cell.detailTextLabel.font = __RWGET_SYSFONT(15);
            
            return cell;
        }
        case 5:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
            
            cell = cell?cell:[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([UITableViewCell class])];
            
            cell.textLabel.text = @"服务用户：";
            cell.textLabel.font = __RWGET_SYSFONT(15);
            cell.detailTextLabel.text = _order.servicedescription.name;
            cell.detailTextLabel.font = __RWGET_SYSFONT(15);
            
            return cell;
        }
        case 6:
        {
            RWOrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RWOrderViewCell class]) forIndexPath:indexPath];
            
            cell.textLabel.text = @"服务内容：";
            cell.descriptionTitle = _order.servicedescription.description;
            
            return cell;
        }
        case 7:
        {
            RWOrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RWOrderViewCell class]) forIndexPath:indexPath];
            
            cell.textLabel.text = @"医生备注：";
            cell.descriptionTitle = _order.serviceMessage;
            
            return cell;
        }
        case 8:
        {
            RWOrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RWOrderViewCell class]) forIndexPath:indexPath];
            
            cell.textLabel.text = @"用户备注：";
            cell.descriptionTitle = _order.payMessage;
            
            return cell;
        }
        case 9:
        {
            RWOrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RWOrderViewCell class]) forIndexPath:indexPath];
            
            cell.textLabel.text = @"评价服务：";
            cell.descriptionTitle = _order.useridea;
            
            return cell;
        }
        default:return nil;
    }
}

@end

@implementation RWOrderViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.textLabel.font = __RWGET_SYSFONT(15);
        
        _descriptionView = [[UITextView alloc] init];
        [self.contentView addSubview:_descriptionView];
        
        _descriptionView.editable = NO;
        _descriptionView.textColor = [UIColor grayColor];
    }
    
    return self;
}

- (void)setDescriptionTitle:(NSString *)descriptionTitle
{
    _descriptionTitle = descriptionTitle;
    
    _descriptionView.text = _descriptionTitle;
    
    [self autoLayoutViews];
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    
    [self autoLayoutViews];
}

- (void)autoLayoutViews
{
    [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.height.equalTo(@(40));
        make.width.equalTo(@(80));
    }];
    
    [_descriptionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.textLabel.mas_right).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
}


@end

@implementation RWOrderIDView

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.backgroundColor = __WPD_MAIN_COLOR__;
        
        _orderId = [[UILabel alloc] init];
        [self addSubview:_orderId];
        
        _orderId.font = __RWGET_SYSFONT(16);
        _orderId.textColor = [UIColor whiteColor];
        _orderId.textAlignment = NSTextAlignmentCenter;
        
        _orderStatus = [[UILabel alloc] init];
        [self addSubview:_orderStatus];
        
        _orderStatus.font = __RWGET_SYSFONT(18);
        _orderStatus.textColor = [UIColor whiteColor];
        _orderStatus.textAlignment = NSTextAlignmentCenter;
    }

    return self;
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    
    [_orderId mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left).offset(20);
        make.right.equalTo(self.mas_right).offset(-20);
        make.top.equalTo(self.mas_top).offset(40);
        make.height.equalTo(@(self.bounds.size.height / 10));
    }];
    
    [_orderStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(30);
        make.right.equalTo(self.mas_right).offset(-30);
        make.top.equalTo(_orderId.mas_bottom).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-20);
    }];
}

@end


@implementation RWNextStepView

+ (instancetype)nextStepTitle:(NSString *)title information:(NSString *)information autoLayout:(void(^)(MASConstraintMaker *make))autoLayout
{
    RWNextStepView *next = [[self alloc] init];
    
    [next.nextStep setTitle:title forState:UIControlStateNormal];
    next.information.text = information;
    next.autoLayout = autoLayout;
    
    return next;
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.layer.borderColor = [[UIColor colorWithWhite:0.9f alpha:1.f] CGColor];
        self.layer.borderWidth = 0.5f;
        self.backgroundColor = [UIColor whiteColor];
        
        _nextStep = [[UIButton alloc] init];
        [self addSubview:_nextStep];
        
        [_nextStep setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nextStep.backgroundColor = __WPD_MAIN_COLOR__;
        _nextStep.titleLabel.font = __RWGET_SYSFONT(14.f);
        
        [_nextStep addTarget:self action:@selector(toNextStep) forControlEvents:UIControlEventTouchUpInside];
        
        _information = [[UILabel alloc] init];
        _information.backgroundColor = [UIColor whiteColor];
        _information.userInteractionEnabled = YES;
        _information.font = __RWGET_SYSFONT(13.f);
        _information.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_information];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailsForInformationAtNextStep)];
        tapGesture.numberOfTapsRequired = 1;
        
        [_information addGestureRecognizer:tapGesture];
    }
    
    return self;
}

- (void)detailsForInformationAtNextStep
{
    if (found_response(_delegate,@"detailsForInformationAtNextStep:"))
    {
        [_delegate detailsForInformationAtNextStep:self];
    }
}

- (void)toNextStep
{
    if (found_response(_delegate,@"toNextStep:"))
    {
        [_delegate toNextStep:self];
    }
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    
    [self autoLayoutViews];
}

- (void)setAutoLayout:(void (^)(MASConstraintMaker *))autoLayout
{
    _autoLayout = autoLayout;
    
    if (_autoLayout && self.window)
    {
        [self autoLayoutViews];
    }
}

- (void)autoLayoutViews
{
    [self mas_remakeConstraints:_autoLayout];
    
    [_nextStep mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(0);
        make.top.equalTo(self.mas_top).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.width.equalTo(@(100));
    }];
    
    [_information mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(20);
        make.top.equalTo(self.mas_top).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.right.equalTo(_nextStep.mas_left).offset(-20);
    }];
}

@end

@implementation RWOrder

+ (instancetype)consultOrderWithUserName:(NSString *)username
                               serviceid:(NSString *)serviceid
                      servicedescription:(RWServiceDetail *)serservicedescription
{
    RWOrder *order = [[RWOrder alloc] init];
    
    order.payid = username;
    order.serviceid = serviceid;
    order.servicedescription = serservicedescription;
    
    return order;
}

+ (instancetype)appointmentOrderWithUserName:(NSString *)username
                          servicedescription:(RWServiceDetail *)serservicedescription
{
    RWOrder *order = [[RWOrder alloc] init];
    
    order.payid = username;
    order.servicedescription = serservicedescription;
    
    return order;
}

- (NSDictionary *)body
{
    return _serviceid?[self consultBody]:[self appointmentBody];
}

- (NSDictionary *)consultBody
{
    return @{@"username":_payid,
             @"serviceid":_serviceid,
             @"fid":_servicedescription.serviceSite,
             @"pid":_servicedescription.serviceType,
             @"serviceiddescription":_servicedescription.description,
             @"udid":__TOKEN_KEY__,
             @"nickname":_servicedescription.name};
}

- (NSDictionary *)appointmentBody
{
    return @{@"username":_payid,
             @"fid":_servicedescription.serviceSite,
             @"pid":_servicedescription.serviceType,
             @"serviceiddescription":_servicedescription.description,
             @"udid":__TOKEN_KEY__,
             @"nickname":_servicedescription.name};
}

@end

NSString *stringOrderStatus(RWOrderStatus orderstatus)
{
    switch (orderstatus)
    {
        case RWOrderStatusTimeOut:              return @"订单超时";
        case RWOrderStatusServiceCancel:        return @"医生取消订单";
        case RWOrderStatusUserCancel:           return @"用户取消订单";
        case RWOrderStatusNotPay:               return @"未支付";
        case RWOrderStatusWaitService:          return @"等待医生接单";
        case RWOrderStatusWaitUserStart:        return @"等待用户确认服务开始";
        case RWOrderStatusServiceStart:         return @"服务开始";
        case RWOrderStatusServiceServiceEnd:    return @"等待用户确认完成服务";
        case RWOrderStatusUserConfirmEnd:       return @"完成服务";
        default:return @"数据出错";
    }
}

NSString *stringPayMethot(RWPayMethot payMethot)
{
    switch (payMethot)
    {
        case RWPayMethotWXPay:  return @"微信支付";
        case RWPayMethotAlipay: return @"支付宝";
        default:return @"数据出错";
    }
}

NSString *stringServiceType(RWServiceType serviceType)
{
    switch (serviceType)
    {
        case RWServiceTypeConsult:          return @"在线咨询";
        case RWServiceTypeAccompanyTreat:   return @"孕妇陪诊";
        case RWServiceTypeGetTestReport:    return @"取化验单";
        case RWServiceTypeInject:           return @"打针输液";
        default:return @"数据出错";
    }
}

NSString *stringServiceSite(RWServiceSite serviceSite)
{
    switch (serviceSite)
    {
        case RWServiceSiteInApp:        return @"应用内咨询服务";
        case RWServiceSiteInHome:       return @"上门服务";
        case RWServiceSiteInHospital:   return @"医院内服务";
        default:return @"数据出错";
    }
}

#ifndef __ORDER_STATUS__
#define __ORDER_STATUS__ @[ @"订单超时",\
                            @"医生取消订单",\
                            @"用户取消订单",\
                            @"未支付",\
                            @"等待医生接单",\
                            @"等待用户确认服务开始",\
                            @"服务开始",\
                            @"等待用户确认完成服务",\
                            @"完成服务"]
#endif

NSNumber *OrderStatusWithString(NSString *orderstatus)
{
    for (int i = 0; i < __ORDER_STATUS__.count; i++)
    {
        if ([orderstatus isEqualToString:__ORDER_STATUS__[i]])
        {
            return @(i - 3);
        }
    }
    
    return nil;
}

NSNumber *payMethotWithString(NSString * payMethot)
{
    if ([payMethot isEqualToString:@"微信支付"])
    {
        return @(1);
    }
    else if ([payMethot isEqualToString:@"支付宝"])
    {
        return @(2);
    }
    
    return nil;
}

#ifndef __SERVICE_TYPE__
#define __SERVICE_TYPE__ @[ @"在线咨询",\
                            @"孕妇陪诊",\
                            @"取化验单",\
                            @"打针输液"]
#endif

NSNumber *serviceTypeWithString(NSString * serviceType)
{
    for (int i = 0; i < __SERVICE_TYPE__.count; i++)
    {
        if ([serviceType isEqualToString:__SERVICE_TYPE__[i]])
        {
            return @(i);
        }
    }
    
    return nil;
}

#ifndef __SERVICE_SITE__
#define __SERVICE_SITE__ @[ @"应用内咨询服务",\
                            @"上门服务",\
                            @"医院内服务"]
#endif

NSNumber *serviceSiteWithString(NSString *serviceSite)
{
    for (int i = 0; i < __SERVICE_SITE__.count; i++)
    {
        if ([serviceSite isEqualToString:__SERVICE_SITE__[i]])
        {
            return @(i + 1);
        }
    }
    
    return nil;
}

#ifndef __KEYVALUES_NAME__
#define __KEYVALUES_NAME__ @{   @"name":@"用户姓名",\
                                @"contactWay":@"联系方式",\
                                @"date":@"日期",\
                                @"time":@"时间",\
                                @"province":@"省",\
                                @"hospital":@"医院",\
                                @"office":@"科室",\
                                @"address":@"地址",\
                                @"doctor":@"医生",\
                                @"comments":@"备注",\
                                @"name":@"用户姓名",\
                                @"serviceType":@"服务类型",\
                                @"serviceSite":@"服务地点",\
                                @"用户姓名":@"name",\
                                @"联系方式":@"contactWay",\
                                @"日期":@"date",\
                                @"时间":@"time",\
                                @"省":@"province",\
                                @"医院":@"hospital",\
                                @"科室":@"office",\
                                @"地址":@"address",\
                                @"医生":@"doctor",\
                                @"备注":@"comments",\
                                @"服务类型":@"serviceType",\
                                @"服务地点":@"serviceSite"}
#endif

#ifndef SWITCH_NAME
#define SWITCH_NAME(name) [__KEYVALUES_NAME__ objectForKey:name]
#endif

@implementation RWService

+ (instancetype)serviceWithServiceImage:(NSString *)serviceImage
                            serviceName:(NSString *)serviceName
                               maxMoney:(NSString *)maxMoney
                               minMoney:(NSString *)minMoney
                              serviceId:(RWServiceType)serviceId
                     serviceDescription:(NSString *)serviceDescription
{
    RWService *service = [[RWService alloc] init];
    
    service.serviceImage = serviceImage;
    service.serviceName = serviceName;
    service.serviceId = serviceId;
    service.maxMoney = maxMoney;
    service.minMoney = minMoney;
    service.serviceDescription = serviceDescription;
    
    return service;
}

- (NSString *)money
{
    return !_minMoney?_maxMoney:
                            [NSString stringWithFormat:@"%@ ~ %@",_minMoney,_maxMoney];
}

@end

@implementation RWServiceDetail

+ (instancetype)serviceDetailWithDescription:(NSString *)description
{
    RWServiceDetail *detail = [[RWServiceDetail alloc] init];
    
    NSArray *items = [description componentsSeparatedByString:@"\n"];
    
    NSMutableArray *copyItems = [items mutableCopy];
    [copyItems removeObject:@""];
    items = [copyItems copy];
    
    for (NSString *item in items)
    {
        NSArray *keyValue = [item componentsSeparatedByString:@":"];
        
        if (keyValue.count != 2)
        {
            NSString *key = SWITCH_NAME(keyValue[0]);
            
            ///* test temp use
            if ([key isEqualToString:@"time"])
            {
                continue;
            }
            //*/
            if (key)
            {
                NSMutableArray *valueArray = [keyValue mutableCopy];
                
                [valueArray removeFirstObject];
                
                NSString *value = [valueArray componentsJoinedByString:@":"];
                
                [detail setValue:value forKey:key];
            }
            else
            {
                MESSAGE(@"解析服务信息数据异常:%@",item);
            }
            
            continue;
        }
        
        if ([SWITCH_NAME(keyValue[0]) isEqualToString:@"serviceType"])
        {
            [detail setValue:serviceTypeWithString(keyValue[1])
                      forKey:SWITCH_NAME(keyValue[0])];
        }
        else if ([SWITCH_NAME(keyValue[0]) isEqualToString:@"serviceSite"])
        {
            [detail setValue:serviceSiteWithString(keyValue[1])
                      forKey:SWITCH_NAME(keyValue[0])];
        }
        else
        {
            [detail setValue:keyValue[1]
                      forKey:SWITCH_NAME(keyValue[0])];
        }
    }
    
    return detail;
}

- (NSString *)verificationResource
{
    NSArray *objNames = [RWSettingsManager obtainAllObjectsAtClass:[self class]];
    
    for (NSString *objName in objNames)
    {
        @autoreleasepool
        {
            if ([objName isEqualToString:@"comments"] ||
                [objName isEqualToString:@"doctor"])
            {
                continue;
            }
            
            id obj = [self valueForKey:objName];
            
            if (!obj)
            {
                return [NSString stringWithFormat:@"“%@”不能为空",SWITCH_NAME(objName)];
            }
        }
    }
    
    return nil;
}

- (NSString *)description
{
    NSMutableArray *descriptionArray = [[NSMutableArray alloc] init];
    
    NSArray *objNames = [RWSettingsManager obtainAllObjectsAtClass:[self class]];
    
    for (NSString *objName in objNames)
    {
        @autoreleasepool
        {
            id obj = [self valueForKey:objName];
            
            if (obj)
            {
                NSString *objDes;
                
                if ([obj isKindOfClass:[NSString class]])
                {
                    objDes = [NSString stringWithFormat:
                                            @"%@:%@",SWITCH_NAME(objName),obj];
                }
                else
                {
                    if ([objName isEqualToString:@"serviceType"])
                    {
                        objDes = [NSString stringWithFormat:@"%@:%@",SWITCH_NAME(objName),stringServiceType([obj integerValue])];
                    }
                    else if ([objName isEqualToString:@"serviceSite"])
                    {
                        objDes = [NSString stringWithFormat:@"%@:%@",SWITCH_NAME(objName),stringServiceSite([obj integerValue])];
                    }
                }
                
                [descriptionArray addObject:objDes];
            }
        }
    }
    
    return [descriptionArray componentsJoinedByString:@"\n"];
}

@end
