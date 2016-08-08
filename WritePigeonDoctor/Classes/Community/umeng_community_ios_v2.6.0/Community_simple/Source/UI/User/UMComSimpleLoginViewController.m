//
//  UMComSimpleLoginViewController.m
//  UMCommunity
//
//  Created by wyq.Cloudayc on 5/11/16.
//  Copyright © 2016 Umeng. All rights reserved.
//

#import "UMComSimpleLoginViewController.h"
#import "UMComRegisterViewController.h"
#import "UMComKit+String.h"
#import "UMComTools.h"
#import "UMComDataRequestManager.h"
#import "UIViewController+UMComAddition.h"
#import "UMComShowToast.h"
#import "UMComProgressHUD.h"

@interface UMComSimpleLoginViewController ()

@property (nonatomic, weak) UITextField *currentField;

@end

@implementation UMComSimpleLoginViewController

- (instancetype)init
{
    if (self = [self initWithNibName:@"UMComSimpleLoginViewController" bundle:nil]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setForumUITitle:UMComLocalizedString(@"um_com_login", @"登录")];

    [self initViews];
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.leftBarButtonItems = nil;

    UIButton *closeButon = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButon setImage:UMComSimpleImageWithImageName(@"close") forState:UIControlStateNormal];
    [closeButon addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    closeButon.frame = CGRectMake(0.f, 0.f, 22.f, 22.f);
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithCustomView:closeButon];
    [self.navigationItem setLeftBarButtonItem:closeItem];
    
    UIView *placeHolderView = [[UIView alloc] init];
    placeHolderView.frame = CGRectMake(0.f, 0.f, 22.f, 22.f);
    UIBarButtonItem *placeHolderButton = [[UIBarButtonItem alloc] initWithCustomView:placeHolderView];
    [self.navigationItem setRightBarButtonItem:placeHolderButton];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_accountField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_currentField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews
{
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    [_accountIcon setImage:UMComSimpleImageWithImageName(@"userid")];
    [_passwordIcon setImage:UMComSimpleImageWithImageName(@"keyword")];
    
    _registerButton.layer.borderWidth = 1.f;
    _registerButton.layer.borderColor = UMComColorWithColorValueString(@"#469EF8").CGColor;
}

- (IBAction)forgotPassword:(id)sender {
    [_passwordField resignFirstResponder];
    [_accountField resignFirstResponder];
    if (_accountField.text.length == 0) {
        [UMComShowToast accountEmailEmpty];
        return;
    }
    
    if (![UMComKit checkEmailFormat:_accountField.text]) {
        [UMComShowToast accountEmailInvalid];
        return;
    }
    
    [[UMComDataRequestManager defaultManager] userPasswordForgetForUMCommunity:_accountField.text response:^(NSDictionary *responseObject, NSError *error) {
        if (error) {
            [UMComShowToast showFetchResultTipWithError:error];
        } else {
            [UMComShowToast accountFindPasswordSuccess];
        }
    }];
}


- (IBAction)login:(id)sender {
    [_passwordField resignFirstResponder];
    [_accountField resignFirstResponder];

    if (_accountField.text.length == 0) {
        [UMComShowToast accountEmailEmpty];
        return;
    }
    
    if (![UMComKit checkEmailFormat:_accountField.text]) {
        [UMComShowToast accountEmailInvalid];
        return;
    }
    
    if (_passwordField.text.length == 0) {
        [UMComShowToast accountPasswordEmpty];
        return;
    }
    
    if (_passwordField.text.length < 6 || _passwordField.text.length > 18 || ![UMComKit includeAlphabetOrDigitOnly:_passwordField.text]) {
        [UMComShowToast accountPasswordInvalid];
        return;
    }
    
    //加入等待框
    UMComProgressHUD *hud = [UMComProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.label.text = UMComLocalizedString(@"um_com_loginingContent",@"登录中...");
    hud.label.backgroundColor = [UIColor clearColor];
    
    __weak typeof(self) ws = self;
    [[UMComDataRequestManager defaultManager] userLoginInUMCommunity:_accountField.text password:_passwordField.text response:^(NSDictionary *responseObject, NSError *error) {
        [hud hideAnimated:YES];
        if (error) {
            [UMComShowToast showFetchResultTipWithError:error];
        } else {
            [UMComShowToast accountLoginSuccess];
            [ws.navigationController dismissViewControllerAnimated:YES completion:^{
                if (ws.completion) {
                    ws.completion(responseObject, error);
                }
            }];
        }
    }];
}

- (IBAction)registerAccount:(id)sender {
    __weak typeof(self) ws = self;
    UMComRegisterViewController *registerVC = [[UMComRegisterViewController alloc] init];
    registerVC.completion = ^(id responseObject, NSError *error) {
        if (ws.completion) {
            ws.completion(responseObject, error);
        }
    };
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentField = textField;
    [self refreshColorView];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self refreshColorView];
}

- (void)refreshColorView
{
    _accountColorView.hidden = [_accountField isFirstResponder];
    _pwdColorView.hidden = [_passwordField isFirstResponder];
}

- (void)close
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
