//
//  DatePicker.m
//  WritePigeonDoctor
//
//  Created by ZYJY on 16/8/22.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "DatePicker.h"

#define showButtom 5
#define hideButtom 302



@implementation DatePicker
-(id)initWithBlock:(NSMutableBlock)block{
    
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
    if (self) {
        sureBlock=block;
        self.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.8);
        cancelBtn.layer.cornerRadius=10;
        cancelBtn.layer.masksToBounds=YES;
        cancelBtn.layer.borderColor=[UIColor grayColor].CGColor;
        cancelBtn.layer.borderWidth=.3;
        
        
        sureBtn.layer.cornerRadius=10;
        sureBtn.layer.masksToBounds=YES;
        sureBtn.layer.borderColor=[UIColor grayColor].CGColor;
        sureBtn.layer.borderWidth=.3;
        
        dateView.layer.cornerRadius=10;
        dateView.layer.masksToBounds=YES;
        dateView.layer.borderColor=[UIColor grayColor].CGColor;
        dateView.layer.borderWidth=.3;
        
        datePicker.minimumDate = [NSDate date];
        
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        [self addGestureRecognizer:tap];
        
        buttom.constant=-hideButtom;
        
         [self layoutIfNeeded];
        
       
        
    }
    return self;
    
    

}
-(void)setForMartString:(NSString *)string{
    
    formatStr=string;
    
    
    
}

-(void)setMaxDate:(NSDate *)date{

    [datePicker setMaximumDate:date];
}

-(void)setMinDate:(NSDate *)date{
    
    [datePicker setMinimumDate:date];
}
-(void)setDatePickerModel:(UIDatePickerMode)model{

    datePicker.datePickerMode=model;
}

-(IBAction)closeBtnClick:(id)sender{
    
    [self hide];
}
-(IBAction)btnClick:(UIButton *)sender{
    
    if(!formatStr||[formatStr isEqualToString:@""]||[formatStr isEqualToString:@"(null)"]){
        
        formatStr=@"yyyy-MM-dd HH:mm";
        
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatStr];
    NSString *currentOlderOneDateStr = [dateFormatter stringFromDate:datePicker.date];
    
    if (sureBlock) {
        sureBlock(currentOlderOneDateStr);
    }
    [self hide];
}

- (IBAction)dateChange:(id)sender {
    
    if(!formatStr||[formatStr isEqualToString:@""]||[formatStr isEqualToString:@"(null)"]){
    
        formatStr=@"yyyy-MM-dd HH:mm";
    
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatStr];
    NSString *currentOlderOneDateStr = [dateFormatter stringFromDate:datePicker.date];
    [sureBtn setTitle:[NSString stringWithFormat:@"(%@)确定",currentOlderOneDateStr] forState:0];
    
}

-(void)show{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
        buttom.constant=showButtom;
        [self layoutIfNeeded];
    }completion:^(BOOL finished) {
        
        
    }];
}
-(void)hide{
    [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
        buttom.constant=-hideButtom;
        [self layoutIfNeeded];
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
