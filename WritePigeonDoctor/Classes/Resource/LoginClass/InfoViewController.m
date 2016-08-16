//
//  InfoViewController.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/8/3.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "InfoViewController.h"
#import "FELoginTableCell.h"
#import "RWRequsetManager+UserLogin.h"

@implementation RWHeaderView

- (void)didMoveToWindow
{
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
        
        _imageView.backgroundColor=[UIColor whiteColor];
        _imageView.layer.cornerRadius=(self.bounds.size.height - 30) / 2;
        _imageView.clipsToBounds = YES;
        _imageView.layer.borderWidth = 1.5f;
        _imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _imageView.userInteractionEnabled = YES;
        _imageView.image = _image?_image:[UIImage imageNamed:@"user_image"];
    }
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.height.equalTo(@(self.bounds.size.height-30));
        make.width.equalTo(@(self.bounds.size.height-30));
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.centerY.equalTo(self.mas_centerY).offset(0);
    }];
}

@end

@interface InfoViewController ()<UITableViewDelegate,UITableViewDataSource,FETextFiledCellDelegate,FEButtonCellDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,RWRequsetDelegate>

@property(nonatomic,strong)UIView *backview;
@property(nonatomic,strong)RWRequsetManager * requestManager;
@property (nonatomic,strong)RWUser *user;

@end

static NSString * const textFieldCell=@"textFieldCell";
static NSString *const buttonCell = @"buttonCell";

@implementation InfoViewController

@synthesize facePlaceHolder;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGRect frame=_backview.frame;
    _backview.frame=CGRectMake(frame.origin.x
                               , -frame.size.height+frame.origin.y
                               , frame.size.width
                               , frame.size.height);
    [UIView animateWithDuration:1.5 animations:^{
        _backview.frame=frame;
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    if (!_user)
    {
        _user = [[RWDataBaseManager defaultManager] getDefualtUser];
        [self.viewList reloadData];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification *) notif
{
    if ([facePlaceHolder isEqualToString:@"请输入年龄"]) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame=CGRectMake(0,-self.viewList.frame.size.height/5, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}

- (void) keyboardWasHidden:(NSNotification *) notif
{
    
    //视图下沉恢复原状
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}





- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _requestManager = [[RWRequsetManager alloc]init];
    _requestManager.delegate = self;
    
    [self registerForKeyboardNotifications];
    
    _backview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-self.view.bounds.size.height/8)];
    _backview.backgroundColor=[UIColor clearColor];
    
    [self.view addSubview:_backview];
    [_backview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self.view);
        make.left.equalTo(self.view.mas_left).offset(self.view.frame.size.height/15);
        make.top.equalTo(self.view).offset(self.view.bounds.size.height/7);
        
    }];
    
    [self initWithViewList];
    [self createBottomView];
    [self.viewList addGestureRecognizer:self.tap];
}
#pragma mark    创建整体UI设计
-(void)initWithViewList
{
    [self.backView removeFromSuperview];
    
    //  创建需要的毛玻璃特效类型
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    //  毛玻璃view 视图
    
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    effectView.alpha = .8f;
    effectView.layer.cornerRadius=12;
    effectView.layer.masksToBounds=YES;
    [_backview addSubview:effectView];
    [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_backview);
        make.size.equalTo(_backview);
        
    }];

    self.viewList=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-self.view.bounds.size.height/8) style:UITableViewStylePlain];
    self.viewList.backgroundColor=[UIColor clearColor];
    self.viewList.delegate=self;
    self.viewList.dataSource=self;
        self.viewList.scrollEnabled=NO;
    self.viewList.allowsSelection = NO;
    self.viewList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.viewList registerClass:[FETextFiledCell class] forCellReuseIdentifier:textFieldCell];
    [self.viewList registerClass:[FEButtonCell class] forCellReuseIdentifier:buttonCell];
    [_backview addSubview:self.viewList];
    [self.viewList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_backview);
        make.size.equalTo(_backview);
    }];
    

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return self.viewList.frame.size.height/4;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        RWHeaderView *view = [[RWHeaderView alloc] init];
        view.userInteractionEnabled = YES;
        
        if (_user.header)
        {
            view.image = [UIImage imageWithData:_user.header];
        }
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(alterHeadPortrait:)];
        singleTap.numberOfTapsRequired = 1;
        [view addGestureRecognizer:singleTap];
        
        return view;
    }
    return nil;
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.viewList.frame.size.height/7;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        FETextFiledCell *cell = [tableView dequeueReusableCellWithIdentifier:textFieldCell forIndexPath:indexPath];
        
        if (_user.name)
        {
            cell.textField.text = _user.name;
        }
        cell.delegate = self;
        cell.placeholder = @"请输入昵称";
        
        return cell;
    }
    else if (indexPath.section==1)
    {
        FETextFiledCell *cell = [tableView dequeueReusableCellWithIdentifier:textFieldCell forIndexPath:indexPath];
        
        if (_user.gender)
        {
            cell.textField.text = _user.gender;
        }
        cell.delegate = self;
        cell.placeholder = @"请输入性别";
        UIButton * button=[[UIButton alloc]init];
        
                button.backgroundColor=[UIColor clearColor];
                [button addTarget:self action:@selector(chickGender) forControlEvents:(UIControlEventTouchUpInside)];
        
                [cell addSubview:button];

                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(cell);
                    make.size.equalTo(cell);
                }];

        return cell;
        
    }
    else if (indexPath.section==2)
    {
        FETextFiledCell *cell = [tableView dequeueReusableCellWithIdentifier:textFieldCell forIndexPath:indexPath];
        if (_user.age)
        {
            cell.textField.text = _user.age;
        }
        cell.delegate = self;
        cell.textField.keyboardType=UIKeyboardTypeDecimalPad;
        cell.placeholder = @"请输入年龄";
        
        return cell;
    }
    else if (indexPath.section==3)
    {
        FEButtonCell *cell=[tableView dequeueReusableCellWithIdentifier:buttonCell forIndexPath:indexPath];
        cell.delegate=self;
        cell.button.tag=99999;
        [cell setTitle:@"上一步"];
        return cell;
    }
    else if(indexPath.section==4)
    {
        FEButtonCell *cell=[tableView dequeueReusableCellWithIdentifier:buttonCell forIndexPath:indexPath];
        cell.delegate=self;
        cell.tag=100000;
        [cell setTitle:@"完成"];
        return cell;
    }
    return nil;
}


#pragma mark  所有信息输入完成

-(void)button:(UIButton *)button ClickWithTitle:(NSString *)title{
    
    if (button.tag==99999) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self setinfo];
    }
    
}
//选择性别
-(void)chickGender
{
    FETextFiledCell * cell=[self.viewList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"性别选择" message:nil preferredStyle:  UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        cell.textField.text=@"男";
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        cell.textField.text=@"女";
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:true completion:nil];
    
}

-(void)textFiledCell:(FETextFiledCell *)cell DidBeginEditing:(NSString *)placeholder
{
    facePlaceHolder = placeholder;
}

-(void)createBottomView{
    
    UIView * bottomView=[[UIView alloc]init];
    
    bottomView.backgroundColor=[UIColor clearColor];
    
    [self.view addSubview:bottomView];
    
    UIButton * bottomButton=[[UIButton alloc]init];
    
    bottomButton.backgroundColor=[UIColor clearColor];
    
    bottomButton.titleLabel.font=[UIFont systemFontOfSize:13];
    
    [bottomButton setTitle:@"跳过完善信息" forState:(UIControlStateNormal)];
    
    [bottomButton addTarget:self action:@selector(jumpMain) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomView addSubview:bottomButton];
    
    __weak typeof (self) weakself =self;
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(weakself.view.mas_centerX);
        make.left.equalTo(weakself.view.mas_left);
        make.height.equalTo(@(30));
        make.top.equalTo(weakself.viewList.mas_bottom);
    }];
    
    [bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(bottomView);
        make.left.equalTo(bottomView.mas_left).offset(40);
        make.bottom.equalTo(bottomView.mas_bottom).offset(-10);
        
    }];
    
    
}

- (void)jumpMain
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark alterHeadPortrait

-(void)alterHeadPortrait:(UITapGestureRecognizer *)gesture
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        
        PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        PickerImage.allowsEditing = YES;
        
        PickerImage.delegate = self;
        
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        
        AVAuthorizationStatus authStatus=[AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                if (authStatus==AVAuthorizationStatusDenied||authStatus==AVAuthorizationStatusRestricted) {
                    
                    [RWSettingsManager promptToViewController:self Title:@"应用相机权限受限,请在设置中启用" response:nil];
                }
                else
                {
                UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
                
                PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
                PickerImage.allowsEditing = YES;
                PickerImage.delegate = self;
                [self presentViewController:PickerImage animated:YES completion:nil];\
                }
            }]];
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];

}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    _user.header = UIImagePNGRepresentation(newPhoto)?
                   UIImagePNGRepresentation(newPhoto):
                   UIImageJPEGRepresentation(newPhoto, 0.9);
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.viewList reloadData];
}

-(void)setinfo
{
    FETextFiledCell *name=[self.viewList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    NSString * nameStr=name.textField.text;
    FETextFiledCell *sex=[self.viewList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    NSString * sexStr=sex.textField.text;
    FETextFiledCell *age=[self.viewList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    
    NSString * ageStr=age.textField.text;
    
    if ([nameStr isEqualToString:@""]||nameStr == nil)
    {
        [RWSettingsManager promptToViewController:self
                                            Title:@"昵称不能为空"
                                         response:nil];
        
        return;
    }
    
    if (ageStr.length == 0 || [ageStr isEqualToString:@""]||ageStr == nil)
    {
        [RWSettingsManager promptToViewController:self
                                            Title:@"年龄不能为空"
                                         response:nil];
        
        return;
    }
    
    if(![_requestManager verificationAge:ageStr])
    {
        [RWSettingsManager promptToViewController:self
                                            Title:@"年龄只能为数字"
                                         response:nil];
        return;
    }
    
    __weak typeof (self) weakself =self;
    __block RWUser *weakUser = _user;
    
    UIImage *header = _user.header?[UIImage imageWithData:_user.header]:[UIImage imageNamed:@"user_image"];
    
    [_requestManager setUserHeader:header name:nameStr age:ageStr sex:sexStr completion:^(BOOL success, NSString *errorReason)
    {
        if (success)
        {
            [[RWDataBaseManager defaultManager] updateUesr:weakUser];
            
            [weakself dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            [RWSettingsManager promptToViewController:weakself
                                                Title:errorReason
                                             response:nil];
        }
    }];
    
}


@end
