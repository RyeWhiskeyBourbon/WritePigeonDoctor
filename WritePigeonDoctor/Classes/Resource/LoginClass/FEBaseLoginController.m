//
//  FEBaseLoginController.m
//  LoginTest
//
//  Created by zhongyu on 16/7/28.
//  Copyright © 2016年 zhongyu. All rights reserved.
//

#import "FEBaseLoginController.h"
#import "FELoginTableCell.h"
#import "UIColor+Wonderful.h"

@interface FEBaseLoginController ()
@property(nonatomic,strong)UIImageView * backImageView;

@end



@implementation FEBaseLoginController

@synthesize viewList;
- (void)viewDidLoad {
   
    [super viewDidLoad];
    [self createBackImageView];
    [self createHeaderView];
    _tap=[self addTapGesture];
    
    
}

-(void)warningToViewController:(__kindof UIViewController *)viewController Title:(NSString *)title Click:(void(^)(void))click{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"友情提示" message:title preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *registerAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        if (click)
        {
            click();
        }
    }];
    
    [alert addAction:registerAction];
    
    [viewController presentViewController:alert animated:YES completion:nil];
    
}


-(void)createBackImageView{
    
    _backImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1"]];
    
    
    _backImageView.frame=[UIScreen mainScreen].bounds;
    _backImageView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_backImageView];
}
-(void)createHeaderView{
    
    _backView=[[UIView alloc]init];
    
    
    [self.view addSubview:_backView];
    
    UIView *backView = [[UIView alloc]init];
    
    backView.backgroundColor = [UIColor clearColor];
    [_backView addSubview:backView];
    UIImageView * view=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gg"]];
    view.backgroundColor=[UIColor clearColor];
    
    [_backView addSubview:view];
    if ([RWSettingsManager deviceVersion]){
        
    
    UILabel *titleLabel = [[UILabel alloc]init];
    
    titleLabel.text = @"白鸽 · Doctor";
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;

    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.font=[UIFont systemFontOfSize:25];
    titleLabel.textColor = [UIColor whiteColor];
    
    [backView addSubview:titleLabel];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_backView.mas_left).offset(40);
        make.right.equalTo(_backView.mas_right).offset(-40);
        make.top.equalTo(_backView.mas_top).offset(120);
        make.bottom.equalTo(_backView.mas_bottom).offset(-10);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(backView.mas_left);
        make.right.equalTo(backView.mas_right);
        make.top.equalTo(backView.mas_top).offset(backView.frame.size.height/2);
        make.bottom.equalTo(backView.mas_bottom);
    }];
    }
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_backView);
        make.centerY.equalTo(_backView.mas_centerY);
        make.width.equalTo(@(100));
        make.height.equalTo(@(100));
        
    }];
    
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-(self.view.frame.size.height-self.view.frame.size.height/4));
        make.width.equalTo(self.view);
    }];
    
    
}
- (UITapGestureRecognizer *)addTapGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(releaseFirstResponder)];
    
    tap.numberOfTapsRequired = 1;

    return tap;
}
/**
 *  触摸时后的事件
 */
- (void)releaseFirstResponder
{
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
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
