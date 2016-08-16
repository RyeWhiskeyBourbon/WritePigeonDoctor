//
//  WPD_SVProgressHUD.m
//  WritePigeonDoctor
//
//  Created by ZYJY on 16/8/8.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "WPD_SVProgressHUD.h"

@implementation WPD_SVProgressHUD

+ (void)showLoadingView
{
    if ([RWSettingsManager deviceVersion])
    {
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        [SVProgressHUD setMinimumDismissTimeInterval:15];
        [SVProgressHUD setFont:[UIFont systemFontOfSize:14]];
        [SVProgressHUD showImage:[UIImage imageNamed:@"status"] status:@"正在加载..."];
    }
}

+ (void)dissmiss
{
    if ([RWSettingsManager deviceVersion])
    {
        [SVProgressHUD dismiss];
    }
}



@end
