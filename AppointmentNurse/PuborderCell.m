//
//  PuborderCell.m
//  WritePigeonDoctor
//
//  Created by ZYJY on 16/8/21.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "PuborderCell.h"

@interface PuborderCell()<UITextFieldDelegate>

@property(strong,nonatomic)UILabel *keyLabel;
@property(strong,nonatomic)UITextField *valueLabel;
@property(strong,nonatomic)UIView *lineView;

@end

static const CGFloat spaceWith=15;

@implementation PuborderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //设置背影色
        self.backgroundColor=[UIColor whiteColor];
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        if (self.keyLabel==nil) {
            self.keyLabel=[[UILabel alloc]init];
            self.keyLabel.font = AdaptedFontSize(12);
            self.keyLabel.textColor=__WPD_MAIN_COLOR__;
            [self.contentView addSubview:self.keyLabel];
            [self.keyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(spaceWith);
                make.centerY.mas_equalTo(0);
                make.size.mas_equalTo(CGSizeMake(80, AdaptedHeight(15)));
            }];
        }
        
        if (self.valueLabel==nil) {
            self.valueLabel=[[UITextField alloc]init];
            self.valueLabel.textAlignment=NSTextAlignmentRight;
            self.valueLabel.font=AdaptedFontSize(12);
            self.valueLabel.delegate =self;
            self.valueLabel.textColor=[UIColor grayColor];
            [self.contentView addSubview:self.valueLabel];
            [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-80-2*spaceWith, AdaptedHeight(18)));
            }];
        }
        
        if (self.lineView==nil) {
            self.lineView = [[UIView alloc] init];
            self.lineView.hidden=YES;
            self.lineView.backgroundColor=[UIColor grayColor];
            [self.contentView addSubview:self.lineView];
            [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(spaceWith);
                make.right.mas_equalTo(self).offset(0);
                make.bottom.mas_equalTo(0);
                make.height.mas_equalTo(@0.5);
            }];
        }
    }
    return self;
}


-(void)setCellDataKey:(NSString *)curkey curValue:(NSString *)curvalue blankValue:(NSString *)blankvalue isShowLine:(BOOL)showLine cellType:(TitleAndPromptCellType)cellType keyBoardType:(UIKeyboardType )type
{
    self.keyLabel.text=curkey;
    self.lineView.hidden=!showLine;
    self.valueLabel.keyboardType = type;
    if ([curvalue length]==0) {
        self.valueLabel.placeholder=blankvalue;
    }
    else
    {
        self.valueLabel.text=curvalue;
        self.valueLabel.textColor=[UIColor blackColor];
    }
    switch (cellType) {
        case TitleAndPromptCellTypeInput: {
            self.accessoryType = UITableViewCellAccessoryNone;
            [self.valueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(0);
                make.right.mas_equalTo(-2*spaceWith);
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-80-2*spaceWith, AdaptedHeight(18)));
            }];
            [self.valueLabel layoutIfNeeded];
            break;
        }
        case TitleAndPromptCellTypeSelect: {
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            self.valueLabel.enabled = NO;
            break;
        }
    }
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (BOOL)becomeFirstResponder{
    [super becomeFirstResponder];
    [_valueLabel becomeFirstResponder];
    return YES;
}

- (BOOL)resignFirstResponder
{
    [super resignFirstResponder];
    [_valueLabel resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.textValueChangedBlock) {
        self.textValueChangedBlock(textField.text);
    }
 }
@end
