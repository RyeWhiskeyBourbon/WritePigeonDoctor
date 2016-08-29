//
//  PayTableViewCell.m
//  WritePigeonDoctor
//
//  Created by ZYJY on 16/8/17.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "PayTableViewCell.h"
#import "YYLabel.h"

@implementation PayTableViewCell

@synthesize conselWayLabel;
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
    conselWayLabel = [[UILabel alloc]init];
    conselWayLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:conselWayLabel];
    
    moneyLabel = [[UILabel alloc]init];
    moneyLabel.textColor = [UIColor orangeRed];
    moneyLabel.font = [UIFont systemFontOfSize:14];
    moneyLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:moneyLabel];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    WEAKSELF
    [conselWayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(8);
        make.bottom.equalTo(weakSelf).offset(-8);
        make.left.equalTo(weakSelf).offset(10);
        make.right.equalTo(weakSelf).offset(-100);
    }];
    
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(8);
        make.bottom.equalTo(weakSelf).offset(-8);
        make.width.equalTo(@(100));
        make.right.equalTo(weakSelf).offset(-10);
    }];

}
@end


@implementation PayMoneyCell

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
- (void)initUI
{
    self.textLabel.font = [UIFont systemFontOfSize:14];
    self.textLabel.text = @"合计:";
    
    moneyLabel = [[UILabel alloc]init];
    moneyLabel.textColor = [UIColor redColor];
    moneyLabel.font = [UIFont systemFontOfSize:14];
    moneyLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:moneyLabel];
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    WEAKSELF
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(8);
        make.bottom.equalTo(weakSelf).offset(-8);
        make.width.equalTo(@(100));
        make.right.equalTo(weakSelf).offset(-10);
    }];

}
@end

@implementation setPayWayCell

@synthesize rirImage;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    
    }
    
    return self;
}

- (void)initUI
{
    rirImage = [[UIImageView alloc]init];
    rirImage.backgroundColor = [UIColor clearColor];
    rirImage.image = [UIImage imageNamed:@"没选择"];
    [self addSubview:rirImage];
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    rirImage.frame = CGRectMake(SCREEN_WIDTH-44, 15, 30, 30);
//    [rirImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf).offset(8);
//        make.bottom.equalTo(weakSelf).offset(-8);
//        make.width.equalTo(@(34));
//        make.right.equalTo(weakSelf).offset(-10);
//    }];
    rirImage.layer.masksToBounds = YES;
    rirImage.layer.cornerRadius = 15;
    

    
}


@end
