//
//  RWDoctorListCell.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/7/27.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWDoctorListCell.h"

@interface RWDoctorListCell ()

@property (nonatomic,strong)UIImageView *header;
@property (nonatomic,strong)UILabel *name;
@property (nonatomic,strong)UILabel *professionalTitle;
@property (nonatomic,strong)UILabel *office;
@property (nonatomic,strong)UILabel *expenses;

@end

@implementation RWDoctorListCell

- (void)initViews
{
    _header = [[UIImageView alloc] init];
    [self addSubview:_header];
    
    _name = [[UILabel alloc] init];
    [self addSubview:_name];
    
    _professionalTitle = [[UILabel alloc] init];
    [self addSubview:_professionalTitle];
    
    _office = [[UILabel alloc] init];
    [self addSubview:_office];
    
    _expenses = [[UILabel alloc] init];
    [self addSubview:_expenses];
}

- (void)setDefaultSettings
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _name.font = __RWGET_SYSFONT(16.f);
    _professionalTitle.font = __RWGET_SYSFONT(14.f);
    _professionalTitle.textColor = [UIColor grayColor];
    
    _office.textColor = [UIColor grayColor];
    _office.font = __RWGET_SYSFONT(13.f);
    _expenses.textColor = [UIColor grayColor];
    _expenses.font = __RWGET_SYSFONT(13.f);
}

- (void)autoLayoutViews
{
    [_header mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(55));
        make.height.equalTo(@(55));
        make.centerY.equalTo(self.mas_centerY).offset(0);
        make.left.equalTo(self.mas_left).offset(20);
    }];
    
    _header.layer.cornerRadius = 27.5f;
    _header.clipsToBounds = YES;
    
    CGFloat itemHeight = (self.frame.size.height - 40) / 3;
    
    [_name mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(60));
        make.height.equalTo(@(itemHeight));
        make.left.equalTo(_header.mas_right).offset(15);
        make.top.equalTo(self.mas_top).offset(20);
    }];
    
    [_professionalTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_name.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(_name.mas_top).offset(0);
        make.bottom.equalTo(_name.mas_bottom).offset(0);
    }];
    
    [_office mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_header.mas_right).offset(15);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(_professionalTitle.mas_bottom).offset(0);
        make.height.equalTo(@(itemHeight));
    }];
    
    [_expenses mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_header.mas_right).offset(15);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(_office.mas_bottom).offset(0);
        make.height.equalTo(@(itemHeight));
    }];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self initViews];
        [self setDefaultSettings];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self autoLayoutViews];
}

- (void)setDoctor:(RWDoctorItem *)doctor
{
    _doctor = doctor;
    
    [_header setImageWithURL:[NSURL URLWithString:_doctor.header] placeholder:[UIImage imageNamed:@"user_image"]];
    _name.text = _doctor.name;
    _professionalTitle.text = _doctor.professionalTitle;
    _office.text = _doctor.office;
    
    _expenses.text = _doctor.expenses.count?_doctor.expenses[0]:nil;
}

- (void)setHistory:(RWHistory *)history
{
    _history = history;
    
    _header.image = _history.header?[UIImage imageWithData:_history.header]:[UIImage imageNamed:@"user_image"];
    _name.text = _history.name;
    _professionalTitle.text = _history.professionTitle;
    _office.text = _history.office;
    _expenses.text = nil;
}

@end
