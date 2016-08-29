//
//  MultitextCell.m
//  WritePigeonDoctor
//
//  Created by ZYJY on 16/8/21.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "MultitextCell.h"
#import "UIPlaceHolderTextView.h"
@interface MultitextCell()

<
    UITextViewDelegate
>

@property(strong,nonatomic)UILabel *myTitleLabel;
@property (strong, nonatomic)UIPlaceHolderTextView *textContentView;
@property(strong,nonatomic)UIView *lineView;

@end



@implementation MultitextCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor=[UIColor whiteColor];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        
        
        if (self.myTitleLabel==nil) {
            self.myTitleLabel=[[UILabel alloc]init];
            self.myTitleLabel.font = AdaptedFontSize(12);
            self.myTitleLabel.textColor= __WPD_MAIN_COLOR__;
            [self.contentView addSubview:self.myTitleLabel];
            [self.myTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(10);
                make.left.mas_equalTo(15);
                make.right.mas_equalTo(-10);
                make.height.mas_equalTo(AdaptedHeight(16));
            }];
        }
        
        if(!_textContentView)
        {
            _textContentView=[[UIPlaceHolderTextView alloc]init];
            _textContentView.backgroundColor = [UIColor whiteColor];
            _textContentView.textColor=[UIColor grayColor];
            _textContentView.placeholderColor = [UIColor grayColor];
            _textContentView.font=AdaptedFontSize(12);
            _textContentView.delegate = self;
            [self.contentView addSubview:_textContentView];
            [_textContentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.myTitleLabel.mas_bottom).offset(5);
                make.left.mas_equalTo(self.myTitleLabel.mas_left).offset(-5);
                make.right.mas_equalTo(self.mas_right).offset(0);
                make.height.mas_equalTo(AdaptedHeight(80));
            }];
        }
        
        if (self.lineView==nil) {
            self.lineView = [[UIView alloc] init];
            self.lineView.hidden=YES;
            self.lineView.backgroundColor=[UIColor grayColor];
            [self.contentView addSubview:self.lineView];
            [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(15);
                make.right.mas_equalTo(self).offset(0);
                make.bottom.mas_equalTo(0);
                make.height.mas_equalTo(@0.5);
            }];
        }
    }
    return self;
}

-(void)setCellDataKey:(NSString *)cellTitle textValue:(NSString *)textValue blankValue:(NSString *)blankvalue showLine:(BOOL)isShowLine
{
    self.myTitleLabel.text=cellTitle;
    self.lineView.hidden=!isShowLine;
    if([textValue length]>0)
    {
        self.textContentView.text=textValue;
    }
    else
    {
        self.textContentView.placeholder=blankvalue;
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (BOOL)becomeFirstResponder{
    [super becomeFirstResponder];
    [_textContentView becomeFirstResponder];
    return YES;
}

- (BOOL)resignFirstResponder
{
    [super resignFirstResponder];
    [_textContentView resignFirstResponder];
    return YES;
}


#pragma mark UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView{
    if (self.textValueChangedBlock) {
        self.textValueChangedBlock(textView.text);
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


-(void)setPlaceFontSize:(CGFloat)placeFontSize
{
    _textContentView.font=AdaptedFontSize(placeFontSize);
}

+ (CGFloat)cellHeight
{
    return AdaptedHeight(120);
}



@end
