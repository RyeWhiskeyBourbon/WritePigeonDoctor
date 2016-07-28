//
//  UMengLoginHandler.m
//  UMCommunity
//
//  Created by Gavin Ye on 8/25/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import "UMComSimpleLoginHandler.h"
#import "UMComSimpleLoginViewController.h"
#import "UMComNavigationController.h"

@interface UMComSimpleLoginHandler()


@end

@implementation UMComSimpleLoginHandler

static UMComSimpleLoginHandler *_instance = nil;
+ (UMComSimpleLoginHandler *)shareInstance {
    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

- (void)presentLoginViewController:(UIViewController *)viewController finishResponse:(LoginCompletion)completion
{
    dispatch_async(dispatch_get_main_queue(), ^{
//        UMComSimpleLoginViewController *loginViewController = [[UMComSimpleLoginViewController alloc] init];
//        loginViewController.completion = completion;
//        UMComNavigationController *navigationController = [[UMComNavigationController alloc] initWithRootViewController:loginViewController];
//        [viewController presentViewController:navigationController animated:YES completion:^{
//        }];
        
        NSLog(@"跳转登录界面 ");
    });
}

@end
