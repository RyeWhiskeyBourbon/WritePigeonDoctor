//
//  UMComLoginManager.m
//  UMCommunity
//
//  Created by Gavin Ye on 8/25/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import "UMComLoginManager.h"
#import "UMComSession.h"
#import "UMUtils.h"
#import "UMComErrorCode.h"
#import "UMComSimpleLoginViewController.h"
#import "UMComMacroConfig.h"
#import "UMComNavigationController.h"
#import "UMComSimpleProfileSettingController.h"
#import "UMComDataBaseManager.h"

@interface UMComLoginManager ()

@property (nonatomic, strong) id<UMComLoginDelegate> loginHandler;

@property (nonatomic, copy) NSString *appKey;

@property (nonatomic, strong) UIViewController *currentViewController;

@property (nonatomic, copy) void (^loginCompletion)(id responseObject, NSError *error);//登录回调
@property (nonatomic, strong) UMComUser *loginUser;


@property (nonatomic, assign) BOOL didUpdateFinish;


@end

@implementation UMComLoginManager

static UMComLoginManager *_instance = nil;
+ (UMComLoginManager *)shareInstance {
    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[UMComLoginManager alloc] init];
        }
    }
    return _instance;
}

- (void)loginWhenReceivedLoginError
{
    [UMComLoginManager performLogin:[UIApplication sharedApplication].keyWindow.rootViewController completion:^(id responseObject, NSError *error) {
        
    }];
}

- (id)init
{
    self = [super init];
    if (self) {
        
        Class delegateClass = NSClassFromString(@"UMComSimpleLoginHandler");
        self.loginHandler = [[delegateClass alloc] init];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginWhenReceivedLoginError) name:kUMComUserDidNotLoginErrorNotification object:nil];
    }
    return self;
}

+ (id<UMComLoginDelegate>)getLoginHandler
{
    return [self shareInstance].loginHandler;
}

+ (void)setLoginHandler:(id <UMComLoginDelegate>)loginHandler
{
    [self shareInstance].loginHandler = loginHandler;
}

+ (void)performLogin:(UIViewController *)viewController completion:(void (^)(id responseObject, NSError *error))completion
{
    if ([UMComSession sharedInstance].isLogin) {
        if (completion) {
            completion([UMComSession sharedInstance].uid,nil);
        }
    } else if (([self shareInstance].loginHandler)){
        if ([[self shareInstance].loginHandler respondsToSelector:@selector(presentLoginViewController:finishResponse:)]) {
            [[self shareInstance].loginHandler presentLoginViewController:viewController finishResponse:^(id responseObject, NSError *error) {
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    UMComUser *user = responseObject[UMComModelDataKey];
                    if (user) {
                        [UMComSession sharedInstance].loginUser = user;
                        [[UMComDataBaseManager shareManager] saveRelatedIDTableWithType:UMComRelatedRegisterUserID withUsers:@[user]];
                        
                        [UMComSession sharedInstance].token = responseObject[UMComTokenKey];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginSucceedNotification object:nil];
                    }
                    
                    BOOL newUser = [responseObject[@"new_user"] boolValue];
                    if (newUser)
                    {
                        [self switchToSettingWithVC:viewController completion:^(id responseObject, NSError *error) {
                            if (completion) {
                                completion([UMComSession sharedInstance].uid,nil);
                            }
                        }];
                    } else {
                        if (completion) {
                            completion([UMComSession sharedInstance].uid,nil);
                        }
                    }
                }
            }];
        }
    } else {
        UMLog(@"There is no login view base controller");
    }
}

+ (void)switchToSettingWithVC:(UIViewController *)viewController completion:(void (^)(id responseObject, NSError *error))completion
{
    UMComSimpleProfileSettingController *VC = [[UMComSimpleProfileSettingController alloc] init];
    VC.hideLogout = YES;
    __weak typeof(VC) weakVC = VC;
    VC.updateCompletion = ^(id responseObject, NSError *error) {
        if (completion) {
            completion(responseObject, nil);
        }
        [weakVC dismissViewControllerAnimated:YES completion:nil];
    };
    UMComNavigationController *rootLoginNav = [[UMComNavigationController alloc] initWithRootViewController:VC];
    [viewController.navigationController presentViewController:rootLoginNav animated:YES completion:nil];
}

+ (void)userLogout
{
    [[UMComSession sharedInstance] userLogout];
}

@end
