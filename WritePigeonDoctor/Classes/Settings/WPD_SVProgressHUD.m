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
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    [SVProgressHUD setFont:[UIFont systemFontOfSize:14]];
    
    [SVProgressHUD showImage:[UIImage imageNamed:@"status"] status:@"正在加载..."];
 
}

+ (void)dissmiss
{
    [SVProgressHUD dismiss];
}



@end
