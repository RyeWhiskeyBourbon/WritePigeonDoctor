//
//  SeeDoctorNavTableViewCell.m
//  WritePigeonDoctor
//
//  Created by ZYJY on 16/8/18.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "SeeDoctorNavTableViewCell.h"

@implementation SeeDoctorNavTableViewCell

@synthesize docNavImg;
@synthesize doctorWayLabel;
@synthesize wayDesLabel;
@synthesize moneyLabel;
@synthesize appointLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
        
    }
    
    return self;
}
-(void)initUI
{
    docNavImg = [[UIImageView alloc]init];
    [self addSubview:docNavImg];
    
    doctorWayLabel = [[UILabel alloc]init];
    doctorWayLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:doctorWayLabel];
    
    wayDesLabel = [[UILabel alloc]init];
    wayDesLabel.font = [UIFont systemFontOfSize:12];
    wayDesLabel.textColor = [UIColor grayColor];
    [self addSubview:wayDesLabel];
    
    moneyLabel = [[UILabel alloc]init];
    moneyLabel.textColor = [UIColor blackColor];
    moneyLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:moneyLabel];
    
    appointLabel = [[UILabel alloc]init];
    appointLabel.textColor = __WPD_MAIN_COLOR__;
    moneyLabel.font = [UIFont systemFontOfSize:14];
    appointLabel.text = @"预约>>";
    [self addSubview:appointLabel];

    
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    WEAKSELF
    [docNavImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(10);
        make.bottom.equalTo(weakSelf).offset(-10);
        make.left.equalTo(weakSelf).offset(10);
        make.width.equalTo(@(80));
    }];
    
    [doctorWayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(10);
        make.left.equalTo(docNavImg.mas_right).offset(10);
        make.width.equalTo(@(200));
        make.height.equalTo(@(20));
    }];
    
   
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf).offset(-10);
        make.left.equalTo(docNavImg.mas_right).offset(10);
        make.width.equalTo(@(200));
        make.height.equalTo(@(16));
    }];

    [appointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(10);
        make.bottom.equalTo(weakSelf).offset(-10);
        make.right.equalTo(weakSelf).offset(-10);
        make.width.equalTo(@(60));
    }];
    
    [wayDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(doctorWayLabel.mas_bottom).offset(10);
        make.bottom.equalTo(moneyLabel.mas_top).offset(-10);
        make.left.equalTo(docNavImg.mas_right).offset(10);
        make.right.equalTo(appointLabel.mas_left).offset(-10);
    }];


}


@end
