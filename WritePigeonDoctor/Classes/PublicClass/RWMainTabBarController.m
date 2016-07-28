//
//  RWMainTabBarController.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/7/25.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWMainTabBarController.h"
#import "RWMainViewController.h"
#import "RWDoctorListController.h"
#import "RWCommunityController.h"
#import "RWSettingsViewController.h"

#define LABLETAG 1000

@interface RWMainTabBarController ()

@property (nonatomic,strong)UIView *coverLayer;

@property (nonatomic,strong)NSArray *names;

@property (nonatomic,strong)NSArray *images;

@property (nonatomic,strong)NSArray *selectImages;

@end

@implementation RWMainTabBarController

@synthesize coverLayer;

- (void)toRootViewController
{
    for (int i = 0; i < _names.count; i++)
    {
        UIImageView *imageItem = (UIImageView *)[self.view viewWithTag:(i + 1) * 10];
        
        imageItem.image = _images[i];
        
        UILabel *nameX = (UILabel *)[self.view viewWithTag:(i + 1) * LABLETAG];
        
        nameX.textColor = [UIColor grayColor];
    }
    
    [self selectWithTag:1];
    
    self.selectedIndex = 0;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initResource];
    [self compositonViewControllers];
    [self compositionCoverLayer];
    [self compositionButton];
}

- (void)initResource
{
    _names = @[@"资讯",@"问诊",@"社区",@"更多"];
    
//    _images = @[[UIImage imageNamed:@"noti"],
//                [UIImage imageNamed:@"main"],
//                [UIImage imageNamed:@"media"],
//                [UIImage imageNamed:@"set"]];
//    
//    _selectImages = @[[UIImage imageNamed:@"noti_s"],
//                      [UIImage imageNamed:@"mian_s"],
//                      [UIImage imageNamed:@"media_s"],
//                      [UIImage imageNamed:@"set_s"]];
}

- (void)compositionCoverLayer
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    coverLayer = [[UIView alloc] initWithFrame:self.tabBar.bounds];
    
    [self.tabBar addSubview:coverLayer];
    
    coverLayer.backgroundColor = [UIColor whiteColor];
}

- (void)compositonViewControllers
{
    
    RWMainViewController *main = [[RWMainViewController alloc]init];

    UINavigationController *mainNav = [[UINavigationController alloc]initWithRootViewController:main];

    RWDoctorListController *doctor = [[RWDoctorListController alloc]init];
    
    UINavigationController *doctorNav = [[UINavigationController alloc]initWithRootViewController:doctor];
    
    RWCommunityController *community = [[RWCommunityController alloc]init];
    
    UINavigationController *communityNav = [[UINavigationController alloc]initWithRootViewController:community];
    
    RWSettingsViewController *settings = [[RWSettingsViewController alloc]init];
    
    UINavigationController *settingsNav = [[UINavigationController alloc]initWithRootViewController:settings];
    
    
    self.viewControllers = @[mainNav,doctorNav,communityNav,settingsNav];
}

- (void)compositionButton
{
    CGFloat w = self.tabBar.frame.size.width / _names.count;
    
    CGFloat h = self.tabBar.frame.size.height;
    
    for (int i = 0; i < _names.count; i++)
    {
        [self tabBarButtonWithFrame:CGRectMake(w * i, 0, w, h) AndTag:i+1];
    }
    
    [self selectWithTag:1];
}

- (UIView *)tabBarButtonWithFrame:(CGRect)frame AndTag:(NSInteger)tag
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    
    view.tag = tag;
    
    [coverLayer addSubview:view];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    
    imageView.tag = tag * 10;
    imageView.image = _images[tag-1];
    
    [view addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(view.mas_top).offset(2);
        make.width.equalTo(@(30));
        make.height.equalTo(@(30));
        make.centerX.equalTo(view.mas_centerX).offset(0);
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    
    nameLabel.text = _names[tag-1];
    nameLabel.tag = tag * 1000;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:10];
    nameLabel.textColor = [UIColor grayColor];
    
    [view addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(imageView.mas_bottom).offset(0);
        make.left.equalTo(view.mas_left).offset(0);
        make.right.equalTo(view.mas_right).offset(0);
        make.bottom.equalTo(view.mas_bottom).offset(-3);
    }];
    
    [self addGestureRecognizerToView:view];
    
    return view;
}

- (void)addGestureRecognizerToView:(UIView *)view
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cutViewControllerWithGesture:)];
    
    tap.numberOfTapsRequired = 1;
    
    [view addGestureRecognizer:tap];
}

- (void)cutViewControllerWithGesture:(UITapGestureRecognizer *)tapGesture
{
    for (int i = 0; i < _names.count; i++)
    {
        UIImageView *imageItem = (UIImageView *)[self.view viewWithTag:(i + 1)*10];
        
        imageItem.image = _images[i];
        
        UILabel *nameX = (UILabel *)[self.view viewWithTag:(i + 1) * LABLETAG];
        
        nameX.textColor = [UIColor grayColor];
    }
    
    [self selectWithTag:tapGesture.view.tag];
}

- (void)selectWithTag:(NSInteger)tag
{
    UIImageView *imageItem = (UIImageView *)[self.view viewWithTag:tag * 10];
    
    imageItem.image = _selectImages[tag - 1];
    
    UILabel *nameLabel = [self.view viewWithTag:tag * LABLETAG];
    
    nameLabel.textColor = __WPD_MAIN_COLOR__;
    
    self.selectedIndex = tag - 1;
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
