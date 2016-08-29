//
//  PubHeaderCell.m
//  WritePigeonDoctor
//
//  Created by ZYJY on 16/8/21.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "PubHeaderCell.h"

@implementation PubHeaderCell

@synthesize docNavImg;
@synthesize doctorWayLabel;
@synthesize moneyLabel;


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
        
    moneyLabel = [[UILabel alloc]init];
    moneyLabel.textColor = [UIColor blackColor];
    moneyLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:moneyLabel];

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
    
}


@end
