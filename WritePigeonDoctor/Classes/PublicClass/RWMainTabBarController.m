//
//  RWMainTabBarController.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/7/25.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWMainTabBarController.h"
#import "RWMainViewController.h"
#import "RWOfficeListController.h"
#import "RWCommunityController.h"
#import "RWSettingsViewController.h"

@interface RWMainTabBarController ()

@property (nonatomic,strong)UIView *coverLayer;

@property (nonatomic,strong)NSArray *images;

@property (nonatomic,strong)NSArray *selectImages;

@end

@implementation RWMainTabBarController

@synthesize coverLayer;

- (void)toRootViewController
{
    for (int i = 0; i < _images.count; i++)
    {
        UIImageView *imageItem = (UIImageView *)[self.view viewWithTag:(i + 1)*10];
        
        imageItem.image = _images[i];
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
    _images = @[[UIImage imageNamed:@"资讯"],
                [UIImage imageNamed:@"找医生"],
                [UIImage imageNamed:@"社区"],
                [UIImage imageNamed:@"我"]];
    
    _selectImages = @[[UIImage imageNamed:@"资讯z"],
                      [UIImage imageNamed:@"找医生z"],
                      [UIImage imageNamed:@"社区z"],
                      [UIImage imageNamed:@"我z"]];
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

    RWOfficeListController *office = [[RWOfficeListController alloc]init];
    
    UINavigationController *officeNav = [[UINavigationController alloc]initWithRootViewController:office];
    
    RWCommunityController *community = [[RWCommunityController alloc]init];
    
    UINavigationController *communityNav = [[UINavigationController alloc]initWithRootViewController:community];
    
    RWSettingsViewController *settings = [[RWSettingsViewController alloc]init];
    
    UINavigationController *settingsNav = [[UINavigationController alloc]initWithRootViewController:settings];
    
    
    self.viewControllers = @[mainNav,officeNav,communityNav,settingsNav];
}

- (void)compositionButton
{
    CGFloat w = self.tabBar.frame.size.width / _images.count;
    
    CGFloat h = self.tabBar.frame.size.height;
    
    for (int i = 0; i < _images.count; i++)
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
        
        make.top.equalTo(view.mas_top).offset(0);
        make.bottom.equalTo(view.mas_bottom).offset(0);
        make.width.equalTo(@(frame.size.height));
        make.centerX.equalTo(view.mas_centerX).offset(0);
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
    for (int i = 0; i < _images.count; i++)
    {
        UIImageView *imageItem = (UIImageView *)[self.view viewWithTag:(i + 1)*10];
        
        imageItem.image = _images[i];
    }
    
    [self selectWithTag:tapGesture.view.tag];
}

- (void)selectWithTag:(NSInteger)tag
{
    UIImageView *imageItem = (UIImageView *)[self.view viewWithTag:tag * 10];
    
    imageItem.image = _selectImages[tag - 1];
    
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
