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
#import "RWConsultHistoryController.h"
#import "RWCustomNavigationController.h"
#import "RWDataBaseManager+ChatCache.h"
#import "UITabBar+badge.h"

@interface RWMainTabBarController ()

@property (nonatomic,strong)UIView *coverLayer;

@property (nonatomic,strong)NSArray *images;

@property (nonatomic,strong)NSArray *selectImages;

@property (nonatomic,strong)NSArray *views;

@end

@implementation RWMainTabBarController

@synthesize coverLayer;

- (void)toRootViewController
{
    for (int i = 0; i < _images.count; i++)
    {
        UIImageView *imageItem = _views[i];
        
        imageItem.image = _images[i];
    }
    
    [self selectWithIndex:0];
}

- (void)addMessageObserver
{
    notification_observe(RWNewMessageNotification,^(NSNotification * _Nonnull note) {
        
        [self updateUnreadNumber];
    });
}

- (void)updateUnreadNumber
{
    NSInteger number = [[RWDataBaseManager defaultManager] getUnreadNumber];
    
    if (number)
    {
        [self.tabBar setBadgeStyle:kCustomBadgeStyleNumber value:number atIndex:1];
    }
    else
    {
        [self.tabBar setBadgeStyle:kCustomBadgeStyleNone value:number atIndex:1];
    }
    
    
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initResource];
    [self compositonViewControllers];
    [self compositionCoverLayer];
    [self compositionButton];
    [self addMessageObserver];
}

- (void)initResource
{
    _images = @[[UIImage imageNamed:@"资讯"],
                [UIImage imageNamed:@"记录"],
                [UIImage imageNamed:@"社区"],
                [UIImage imageNamed:@"我"]];
    
    _selectImages = @[[UIImage imageNamed:@"资讯z"],
                      [UIImage imageNamed:@"记录z"],
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

    RWCustomNavigationController *mainNav = [[RWCustomNavigationController alloc]initWithRootViewController:main];

    RWConsultHistoryController *history = [[RWConsultHistoryController alloc]init];
    
    RWCustomNavigationController *officeNav = [[RWCustomNavigationController alloc]initWithRootViewController:history];
    
    RWCommunityController *community = [[RWCommunityController alloc]init];
    
    RWCustomNavigationController *communityNav = [[RWCustomNavigationController alloc]initWithRootViewController:community];
    
    RWSettingsViewController *settings = [[RWSettingsViewController alloc]init];
    
    RWCustomNavigationController *settingsNav = [[RWCustomNavigationController alloc]initWithRootViewController:settings];
    
    
    self.viewControllers = @[mainNav,officeNav,communityNav,settingsNav];
}

- (void)compositionButton
{
    CGFloat w = self.tabBar.frame.size.width / _images.count;
    
    CGFloat h = self.tabBar.frame.size.height;
    
    NSMutableArray *views = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < _images.count; i++)
    {
        [views addObject:
        
                [self tabBarButtonWithFrame:CGRectMake(w * i, 0, w, h) AndTag:i+1]];
    }
    
    _views = [views copy];
    
    [self selectWithIndex:0];
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
        
        make.top.equalTo(view.mas_top).offset(1);
        make.bottom.equalTo(view.mas_bottom).offset(-1);
        make.width.equalTo(@(frame.size.height - 2));
        make.centerX.equalTo(view.mas_centerX).offset(0);
    }];
    
    [self addGestureRecognizerToView:view];
    
    return imageView;
}

- (void)addGestureRecognizerToView:(UIView *)view
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cutViewControllerWithGesture:)];
    
    tap.numberOfTapsRequired = 1;
    
    [view addGestureRecognizer:tap];
}

- (void)cutViewControllerWithGesture:(UITapGestureRecognizer *)tapGesture
{
    for (int i = 0; i < _views.count; i++)
    {
        UIImageView *imageItem = _views[i];
        
        imageItem.image = _images[i];
    }
    
    [self selectWithIndex:tapGesture.view.tag - 1];
}

- (void)selectWithIndex:(NSInteger)index
{
    UIImageView *imageItem = _views[index];
    
    imageItem.image = _selectImages[index];
    
    self.selectedIndex = index;
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
