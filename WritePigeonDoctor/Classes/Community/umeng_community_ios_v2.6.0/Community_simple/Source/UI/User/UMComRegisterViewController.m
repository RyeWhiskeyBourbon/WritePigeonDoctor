//
//  UMComRegisterViewController.m
//  UMCommunity
//
//  Created by wyq.Cloudayc on 5/11/16.
//  Copyright © 2016 Umeng. All rights reserved.
//

#import "UMComRegisterViewController.h"

#import "UMComKit+Image.h"
#import "UMComKit+String.h"
#import "UMComDataRequestManager.h"
#import "UIViewController+UMComAddition.h"
#import "UMComShowToast.h"
#import "UMComErrorCode.h"
#import "UMComProgressHUD.h"

@interface UMComRegisterViewController ()

@property (nonatomic, weak) UITextField *currentField;

@end

@implementation UMComRegisterViewController

- (instancetype)init
{
    if (self = [self initWithNibName:@"UMComRegisterViewController" bundle:nil]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViews];
    
    [self setForumUITitle:UMComLocalizedString(@"um_com_register", @"注册")];
    
    UIView *placeHolderView = [[UIView alloc] init];
    placeHolderView.frame = CGRectMake(0.f, 0.f, 22.f, 22.f);
    UIBarButtonItem *placeHolderButton = [[UIBarButtonItem alloc] initWithCustomView:placeHolderView];
    [self.navigationItem setRightBarButtonItem:placeHolderButton];
    
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
    
    [_avatarImageView setPlaceholderImage:UMComSimpleImageWithImageName(@"camera-large")];
    
    [_passwordHiddenButton setBackgroundImage:UMComSimpleImageWithImageName(@"showpassword") forState:UIControlStateNormal];
    [_passwordHiddenButton setBackgroundImage:UMComSimpleImageWithImageName(@"hidepassword") forState:UIControlStateSelected];
    _passwordHiddenButton.selected = YES;
    
    _passwordField.placeholder = UMComLocalizedString(@"um_com_password_rule", @"6-18个字母或数字");
    _nicknameField.placeholder = UMComLocalizedString(@"um_com_nickname_rule", @"2-20个中英文字符");
}

- (IBAction)changePassworkHidden:(id)sender {
    _passwordField.secureTextEntry = !_passwordField.secureTextEntry;
    _passwordHiddenButton.selected = _passwordField.secureTextEntry;
}

- (IBAction)registerAccount:(id)sender {
    [_currentField resignFirstResponder];
    
    if (![self checkRegisterValid])
        return;
    
    
    //加入等待框
    UMComProgressHUD *hud = [UMComProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.label.text = UMComLocalizedString(@"um_com_registeringContent",@"注册中...");
    hud.label.backgroundColor = [UIColor clearColor];
    
    typeof(self) ws = self;
    [[UMComDataRequestManager defaultManager] userSignUpUMCommunity:_accountField.text password:_passwordField.text nickName:_nicknameField.text response:^(NSDictionary *responseObject, NSError *error) {
        [hud hideAnimated:YES];
        if (error) {
            [UMComShowToast showFetchResultTipWithError:error];
        } else {
            [UMComShowToast accountRegisterSuccess];
            [ws.navigationController dismissViewControllerAnimated:YES completion:^{
                if (ws.completion) {
                    NSMutableDictionary *dict = [responseObject mutableCopy];
                    dict[@"new_user"] = @YES;
                    ws.completion(dict, error);
                }
            }];
        }
    }];
    
}


- (BOOL)checkRegisterValid
{
    if (_accountField.text.length == 0) {
        [UMComShowToast accountEmailEmpty];
        return NO;
    }
    
    if (![UMComKit checkEmailFormat:_accountField.text]) {
        [UMComShowToast accountEmailInvalid];
        return NO;
    }
    
    if (_passwordField.text.length == 0) {
        [UMComShowToast accountPasswordEmpty];
        return NO;
    }
    
    if (_passwordField.text.length < 6 || _passwordField.text.length > 18 || ![UMComKit includeAlphabetOrDigitOnly:_passwordField.text]) {
        [UMComShowToast accountPasswordInvalid];
        return NO;
    }
    
    // 中文或英文
    if (_nicknameField.text.length < 2 || _nicknameField.text.length > 20 || [UMComKit includeSpecialCharact:_nicknameField.text]) {
        [UMComShowToast accountNicknameInvalid];
        return NO;
    }
    return YES;
}


#pragma mark - FieldDelegate

- (void)clearBarsColor
{
    UIColor *normalColor = UMComColorWithColorValueString(@"#F1F6F7");
    
    for (UIView *v in _bars) {
        v.backgroundColor = normalColor;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentField = textField;
    [self clearBarsColor];
    textField.superview.backgroundColor = [UIColor whiteColor];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self clearBarsColor];
}

@end
