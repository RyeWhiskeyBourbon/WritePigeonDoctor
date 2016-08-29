//
//  AddressPickerView.h
//  WritePigeonDoctor
//
//  Created by ZYJY on 16/8/17.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  void(^AdressBlock)(NSString *province);

@interface AddressPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic,copy) AdressBlock block;

//当前弹出视图的显示状态(YES 处于弹出状态 NO 隐藏状态)
@property(nonatomic)BOOL currentPickState;

+ (id)shareInstance;

//显示
-(void)showAddressPickView;

//隐藏
-(void)hiddenAddressPickView;

//绑定默认值 省名 市名 区名
-(void)configDataProvince:(NSString *)provinceName;

@end
