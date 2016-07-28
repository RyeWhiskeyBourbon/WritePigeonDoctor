//
//  UMComProfileSettingController.h
//  UMCommunity
//
//  Created by luyiyuan on 14/10/27.
//  Copyright (c) 2014年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMComTools.h"
#import "UMComViewController.h"


@class UMComUser, UMComUserAccount, UMComImageView;

@interface UMComSimpleProfileSettingController : UMComViewController
<UITextFieldDelegate,UINavigationControllerDelegate>

@property (nonatomic, assign) BOOL hideLogout;

@property (nonatomic, copy) void (^updateCompletion)(id responseObject, NSError *error) ;

@property (nonatomic, strong) UMComUserAccount *userAccount;

@property (nonatomic, copy) void (^settingCompletion)(UIViewController *viewController, UMComUserAccount *userAccount);


@property (weak, nonatomic) IBOutlet UILabel *souceUidLabel;
@property (nonatomic, weak) IBOutlet UITextField * nameField;
@property (nonatomic, strong) IBOutlet UMComImageView *userPortrait;


@property (nonatomic, strong) NSError *registerError;

@property (weak, nonatomic) IBOutlet UILabel *pushStatus;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIImageView *cameraIcon;

@property (weak, nonatomic) IBOutlet UIView *maleIcon;
@property (weak, nonatomic) IBOutlet UIView *femaleIcon;

- (IBAction)choseMale:(id)sender;
- (IBAction)choseFemale:(id)sender;

- (IBAction)logout:(id)sender;

@end
