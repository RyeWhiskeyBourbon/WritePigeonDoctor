//
//  UMComSimpleLoginViewController.h
//  UMCommunity
//
//  Created by wyq.Cloudayc on 5/11/16.
//  Copyright © 2016 Umeng. All rights reserved.
//

#import "UMComViewController.h"

typedef void (^LoginCompletion)(id responseObject, NSError *error);

@interface UMComSimpleLoginViewController : UMComViewController

@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property (weak, nonatomic) IBOutlet UIImageView *accountIcon;
@property (weak, nonatomic) IBOutlet UIImageView *passwordIcon;

@property (weak, nonatomic) IBOutlet UIView *accountColorView;
@property (weak, nonatomic) IBOutlet UIView *pwdColorView;

@property (nonatomic, copy) LoginCompletion completion;

- (IBAction)forgotPassword:(id)sender;

- (IBAction)login:(id)sender;

- (IBAction)registerAccount:(id)sender;

@end
