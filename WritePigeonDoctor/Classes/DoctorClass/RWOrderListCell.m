//
//  RWOrderListCell.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/8/23.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWOrderListCell.h"

@interface RWOrderListCell ()

@property (nonatomic,strong)UIImageView *typeImage;

@property (nonatomic,strong)UILabel *orderid;
@property (nonatomic,strong)UILabel *orderStatus;
@property (nonatomic,strong)UILabel *service;
@property (nonatomic,strong)UILabel *bulidDate;
@property (nonatomic,strong)UILabel *money;

@end

@implementation RWOrderListCell

- (void)initViews
{
    _typeImage = [[UIImageView alloc] init];
    [self addSubview:_typeImage];
    
    _orderid = [[UILabel alloc] init];
    [self addSubview:_orderid];
    
    _orderStatus = [[UILabel alloc] init];
    [self addSubview:_orderStatus];
    
    _service = [[UILabel alloc] init];
    [self addSubview:_service];
    
    _bulidDate = [[UILabel alloc] init];
    [self addSubview:_bulidDate];
    
    _money = [[UILabel alloc] init];
    [self addSubview:_money];
}

- (void)setDefualtSettings
{
    _orderid.font = __RWGET_SYSFONT(12);
    
    _service.textColor = [UIColor grayColor];
    _service.font = __RWGET_SYSFONT(11);
    
    _money.textColor = [UIColor grayColor];
    _money.font = __RWGET_SYSFONT(10);
    _money.textAlignment = NSTextAlignmentRight;
    
    _bulidDate.textColor = [UIColor grayColor];
    _bulidDate.font = __RWGET_SYSFONT(10);
    
    _orderStatus.textColor = [UIColor grayColor];
    _orderStatus.font = __RWGET_SYSFONT(11);
    _orderStatus.textAlignment = NSTextAlignmentRight;
}

- (void)autoLayoutView
{
    [_typeImage mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.width.equalTo(@(self.bounds.size.height - 30));
        make.height.equalTo(@(self.bounds.size.height - 30));
        make.centerY.equalTo(self.mas_centerY).offset(0);
        make.left.equalTo(self.mas_left).offset(15);
    }];
    
    CGFloat h = ( self.bounds.size.height - 30 ) / 3;
    
    [_orderid mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(_typeImage.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-20);
        make.top.equalTo(_typeImage.mas_top).offset(0);
        make.height.equalTo(@(h));
    }];
    
    [_service mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_typeImage.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-95);
        make.top.equalTo(_orderid.mas_bottom).offset(0);
        make.height.equalTo(@(h));
    }];
    
    [_money mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_service.mas_right).offset(0);
        make.right.equalTo(self.mas_right).offset(-20);
        make.top.equalTo(_orderid.mas_bottom).offset(0);
        make.height.equalTo(@(h));
    }];
    
    CGFloat w = (self.bounds.size.width - 45 - (self.bounds.size.height - 30)) / 2;
    
    [_bulidDate mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_typeImage.mas_right).offset(10);
        make.top.equalTo(_service.mas_bottom).offset(0);
        make.width.equalTo(@(w));
        make.height.equalTo(@(h));
    }];
    
    [_orderStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_bulidDate.mas_right).offset(0);
        make.top.equalTo(_service.mas_bottom).offset(0);
        make.width.equalTo(@(w));
        make.height.equalTo(@(h));
    }];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self initViews];
        [self setDefualtSettings];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self autoLayoutView];
}

- (void)setOrder:(RWOrder *)order
{
    _order = order;
    
    _orderid.text = [NSString stringWithFormat:@"订单号：%@",_order.orderid];
    _service.text = [NSString stringWithFormat:@"%@ %@",stringServiceSite(_order.fid),
                                                        stringServiceType(_order.pid)];
    _money.text = [NSString stringWithFormat:@"￥%.2f 元",_order.money];
    _bulidDate.text = _order.buildDate;
    _orderStatus.text = stringOrderStatus(_order.orderstatus);
    
    if (order.pid == RWServiceTypeConsult)
    {
        _typeImage.image = [UIImage imageNamed:@"在线咨询"];
    }
    else if (order.pid == RWServiceTypeAccompanyTreat)
    {
        _typeImage.image = [UIImage imageNamed:@"孕妇陪诊"];
    }
    else if (order.pid == RWServiceTypeGetTestReport)
    {
        _typeImage.image = [UIImage imageNamed:@"取化验单"];
    }
    else if (order.pid == RWServiceTypeInject)
    {
        _typeImage.image = [UIImage imageNamed:@"打针输液"];
    }
}

@end
