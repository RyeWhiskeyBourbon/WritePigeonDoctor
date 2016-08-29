//
//  DatePicker.h
//  WritePigeonDoctor
//
//  Created by ZYJY on 16/8/22.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NSMutableBlock)(id data);//公用块


@interface DatePicker : UIView
{
    NSMutableBlock sureBlock;
    NSString *formatStr;
    
    __weak IBOutlet UIDatePicker *datePicker;
    __weak IBOutlet UIButton *sureBtn;
    __weak IBOutlet UIButton *cancelBtn;
    __weak IBOutlet UIView *dateView;
    __weak IBOutlet NSLayoutConstraint *buttom;
}
/*!
 *  初始化
 *
 *  @param block 点击确定之后的回调 返回的是时间
 *
 *  @return
 */
-(id)initWithBlock:(NSMutableBlock)block;
/*!
 *  格式化时间
 *
 *  @param string 格式化类型字符串
 */
-(void)setForMartString:(NSString *)string;
/*!
 *  显示时间类型
 *
 *  @param model 时间类型
 */
-(void)setDatePickerModel:(UIDatePickerMode)model;
/*!
 *  最大时间
 *
 *  @param date 最大
 */
-(void)setMaxDate:(NSDate *)date;
/*!
 *  最小时间
 *
 *  @param date 最小
 */
-(void)setMinDate:(NSDate *)date;

-(void)show;
-(void)hide;
@end
