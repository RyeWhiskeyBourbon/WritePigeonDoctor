//
//  UMComProfileSettingController.m
//  UMCommunity
//
//  Created by luyiyuan on 14/10/27.
//  Copyright (c) 2014年 Umeng. All rights reserved.
//

#import "UMComSimpleProfileSettingController.h"
#import "UMComImageView.h"
#import "UMComShowToast.h"
#import "UMUtils.h"
#import "UMComSession.h"
#import "UIViewController+UMComAddition.h"
#import "UMComImageUrl.h"
#import "UMComUserUpdateDataController.h"
#import "UMComKit+String.h"
#import "UMComKit+Image.h"
#import "UMComUser.h"
#import "UMComTools.h"
#define INTERVAL_KEYBOARD 5
#define NoticeLabelTag 10001

@interface UMComSimpleProfileSettingController ()

@property (nonatomic, assign) NSUInteger gender;

@property (nonatomic, strong) UMComUserUpdateDataController *dataController;

@property(nonatomic,strong)RWRequsetManager * requestManager;
@end

@implementation UMComSimpleProfileSettingController
{
    UILabel *noticeLabel;
}


- (id)init
{
    self = [super initWithNibName:@"UMComSimpleProfileSettingController" bundle:nil];
    if (self) {
        _gender = 1;
        self.dataController = [[UMComUserUpdateDataController alloc] init];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
}
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification *) notif
{
    
    CGFloat offset = 50;
    
    if(offset > 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
    
}

- (void) keyboardWasHidden:(NSNotification *) notif
{
    
    //视图下沉恢复原状
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.registerError) {
        [UMComShowToast showFetchResultTipWithError:self.registerError];
    }
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    if (self.registerError) {
        [UMComShowToast showFetchResultTipWithError:self.registerError];
    }

    [self setUserProfile];

    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self setRightButtonWithTitle:UMComLocalizedString(@"um_com_save",@"保存") action:@selector(onClickSave)];
    [self setTitleViewWithTitle:UMComLocalizedString(@"um_com_profileSetting", @"设置")];
    [self.cameraIcon setImage:UMComSimpleImageWithImageName(@"camera_icon")];
    
    UITapGestureRecognizer *userImageGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickChangeUserImage)];
    [self.userPortrait addGestureRecognizer:userImageGesture];
    
    UITapGestureRecognizer *tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tapBackground];
    
    [self updateGender];
    
    _logoutButton.layer.borderColor = UMComColorWithColorValueString(@"#eeeff3").CGColor;
    _logoutButton.layer.borderWidth = 1.f;
    if (_hideLogout) {
        _logoutButton.hidden = YES;
    }
}

- (void)onClickChangeUserImage
{
    [_nameField resignFirstResponder];
    [_ageField resignFirstResponder];
    __weak typeof(self) ws = self;
    [[UMComKit sharedInstance] fetchImageFromAlbum:self completion:^(UIImagePickerController *picker, NSDictionary *info) {
        
        UIImage *selectImage = [info valueForKey:@"UIImagePickerControllerEditedImage"];
        
        if (selectImage) {
            selectImage = [UMComKit fixOrientation:selectImage];
            
            [_dataController updateAvatarWithImage:selectImage completion:^(id responseObject, NSError *error) {
                if (!error) {
                    [ws.userPortrait setImage:selectImage];
                }
            }];
        }
    }];
}

- (void)setUserProfile
{
    RWUser *user = [[RWDataBaseManager defaultManager] getDefualtUser];;
    if (user) {
        _nameField.text = user.name;
        _ageField.text = [NSString stringWithFormat:@"%@",user.age];
        _souceUidLabel.text = user.username;
        if ([user.gender isEqualToString:@"女"]) {
            _gender = 0;
        }else
        {
            _gender = 1;
        }
        if (user.header) {
            _userPortrait.image = [UIImage imageWithData:user.header];
        }else
        {
            _userPortrait.backgroundColor = [UIColor whiteColor];
            _userPortrait.image = [UIImage imageNamed:@"user_image"];
        }
        [self updateGender];
    }
}

-(void)onClickClose
{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
    if (_updateCompletion) {
        _updateCompletion(nil, nil);
    }
}

- (void)hideKeyboard
{
    [_nameField resignFirstResponder];
    [_ageField resignFirstResponder];
}

-(void)onClickSave
{
    [self.nameField resignFirstResponder];
    [self.ageField resignFirstResponder];
    if (self.nameField.text.length < 2) {
        [[[UIAlertView alloc]initWithTitle:UMComLocalizedString(@"um_com_sorry", @"抱歉") message:UMComLocalizedString(@"um_com_userNicknameTooShort", @"用户昵称太短了") delegate:nil cancelButtonTitle:UMComLocalizedString(@"um_com_ok", @"好的") otherButtonTitles:nil, nil] show];
        return;
    }
    if (self.nameField.text.length > 20) {
        [[[UIAlertView alloc]initWithTitle:UMComLocalizedString(@"um_com_sorry", @"抱歉")  message:UMComLocalizedString(@"um_com_userNicknameTooLong", @"用户昵称过长") delegate:nil cancelButtonTitle:UMComLocalizedString(@"um_com_ok", @"好的") otherButtonTitles:nil, nil] show];
        return;
    }
    if ([UMComKit includeSpecialCharact:self.nameField.text]) {
        [[[UIAlertView alloc]initWithTitle:UMComLocalizedString(@"um_com_sorry", @"抱歉")  message:UMComLocalizedString(@"um_com_inputCharacterDoesNotConformRequirements", @"昵称只能包含中文、中英文字母、数字和下划线") delegate:nil cancelButtonTitle:UMComLocalizedString(@"um_com_ok", @"好的") otherButtonTitles:nil, nil] show];
        return;
    }
    if (self.ageField.text) {
     if (![self verificationAge:self.ageField.text]){
         [[[UIAlertView alloc]initWithTitle:UMComLocalizedString(@"um_com_sorry", @"抱歉")  message:UMComLocalizedString(@"um_com_userNicknameTooLong", @"请输入正确的年龄") delegate:nil cancelButtonTitle:UMComLocalizedString(@"um_com_ok", @"好的") otherButtonTitles:nil, nil] show];
         return;
       }
     }
     _requestManager = [[RWRequsetManager alloc]init];
    WEAKSELF
    [_requestManager setUserHeader: _userPortrait.image name:_nameField.text age:self.ageField.text sex:[NSString stringWithFormat:@"%lu",(unsigned long)_gender] completion:^(BOOL success, NSString *errorReason)
     {
        if (success) {
            
            if ([RWSettingsManager deviceVersion])
            {
                [SVProgressHUD setMinimumDismissTimeInterval:1];
                [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            }
            else
            {
                [RWSettingsManager promptToViewController:weakSelf
                                                    Title:@"保存成功"
                                                 response:nil];
            }
        }
         else
         {
             if ([RWSettingsManager deviceVersion])
             {
                 [SVProgressHUD setMinimumDismissTimeInterval:1];
                 [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                 [SVProgressHUD showErrorWithStatus:errorReason];
             }
             else
             {
                 [RWSettingsManager promptToViewController:weakSelf
                                                     Title:@"保存失败"
                                                  response:nil];
             }
         }
     }];

}
- (BOOL)verificationAge:(NSString *)age
{
    for (int i = 0; i < age.length; i++)
    {
        unichar c = [age characterAtIndex:i];
        
        if (c > 57 || c < 48)
        {
            return NO;
        }
    }
    
    return YES;
}
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //当时删除的时候text为空,以此方法判断是否用户点击删除按键
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    NSInteger markLength = 0;//标记的长度
    UITextRange* curMarkText = textField.markedTextRange;
    if (curMarkText) {
        //http://stackoverflow.com/questions/19377299/cgcontextsavegstate-invalid-context
        //CGContextSaveGState invalid context联想输入法警告ipod5
        markLength = [textField offsetFromPosition:curMarkText.start toPosition:curMarkText.end];
    }
    
    NSInteger curLength = 0.f;
    NSInteger nextLength = 0.f;
    curLength = [UMComTools getStringLengthWithString:textField.text];//当前长度(用于判断表情)
    nextLength = [UMComTools getStringLengthWithString:string];//即将要输入的长度(用于判断表情)
    curLength -= markLength;
    if (curLength +  nextLength > 20 ){
        [self creatNoticeLabelWithView:textField];
        noticeLabel.text = UMComLocalizedString(@"um_com_userNicknameTooLong", @"用户昵称过长");
        self.nameField.hidden = YES;
        noticeLabel.hidden = NO;
        string = nil;
        [self performSelector:@selector(hiddenNoticeView) withObject:nil afterDelay:0.8f];
        return NO;
    }
    return YES;
}

- (void)creatNoticeLabelWithView:(UITextField *)textField
{
    if (!noticeLabel) {
        noticeLabel = [[UILabel alloc]initWithFrame:textField.frame];
        noticeLabel.backgroundColor = [UIColor clearColor];
        [textField.superview addSubview:noticeLabel];
        noticeLabel.textAlignment = NSTextAlignmentCenter;
        noticeLabel.textColor = [UIColor grayColor];
        noticeLabel.adjustsFontSizeToFitWidth = YES;
    }
}

- (void)hiddenNoticeView
{
    noticeLabel.hidden = YES;
    self.nameField.hidden = NO;
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

- (void)updateGender
{
    if (_gender == 0) {
        _femaleIcon.layer.contents = (id)UMComSimpleImageWithImageName(@"chosen.png").CGImage;
        _maleIcon.layer.contents = (id)UMComSimpleImageWithImageName(@"unchosen.png").CGImage;
    } else {
        _femaleIcon.layer.contents = (id)UMComSimpleImageWithImageName(@"unchosen.png").CGImage;
        _maleIcon.layer.contents = (id)UMComSimpleImageWithImageName(@"chosen.png").CGImage;
    }
}

- (IBAction)choseMale:(id)sender {
    _gender = 1;
    [self updateGender];
    [_nameField resignFirstResponder];
}

- (IBAction)choseFemale:(id)sender {
    _gender = 0;
    [self updateGender];
    [_nameField resignFirstResponder];
}

- (IBAction)logout:(id)sender {
    
    
     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"白鸽提示" message:@"是否退出登录？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
    }];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        if ([RWSettingsManager deviceVersion])
        {
            [SVProgressHUD setMinimumDismissTimeInterval:15];
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            [SVProgressHUD showWithStatus:@"正在退出。。。"];
        }
        [RWRequsetManager userLogout:^(BOOL success) {
           
            if (success)
            {
                RWDataBaseManager *dataBase = [RWDataBaseManager defaultManager];
                
                RWUser *user = [dataBase getDefualtUser];
                user.defaultUser = NO;
                
                if ([dataBase updateUesr:user] && SETTINGS(__AUTO_LOGIN__, @(NO)))
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kUserLogoutSucceedNotification object:nil];
                    
                    if (self.navigationController.viewControllers.count > 1)
                    {
                        if ([RWSettingsManager deviceVersion])
                        {
                            [SVProgressHUD dismiss];
                        }
                        
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                    else
                    {
                        if ([RWSettingsManager deviceVersion])
                        {
                            [SVProgressHUD dismiss];
                        }
                        
                        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    }
                }
            }
        }];
        
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:sureAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
