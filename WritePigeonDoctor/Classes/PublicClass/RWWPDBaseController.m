//
//  RWWPDBaseController.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/7/28.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWWPDBaseController.h"

@interface RWWPDBaseController ()

@end

@implementation RWWPDBaseController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    __DEFAULT_NAVIGATION_BAR__;
    __NAVIGATION_DEUAULT_SETTINGS__;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)pushNextWithViewcontroller:(UIViewController *)viewController
{
    CATransition *transition = [CATransition animation];
    transition.type = @"suckEffect";
    transition.subtype = @"fromLeft";
    transition.duration = 1;
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:viewController animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
