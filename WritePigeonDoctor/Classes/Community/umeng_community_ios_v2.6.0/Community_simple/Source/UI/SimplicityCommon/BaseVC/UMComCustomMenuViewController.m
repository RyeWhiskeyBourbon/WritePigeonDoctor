//
//  UMComCustomMenuViewController.m
//  UMCommunity
//
//  Created by umeng on 16/5/11.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComCustomMenuViewController.h"
#import "UIViewController+UMComAddition.h"
#import "UMComTools.h"

@interface UMComCustomMenuViewController ()

//- (UIView *)creatNoticeViewWithOriginX:(CGFloat)originX;
@end

@implementation UMComCustomMenuViewController

@synthesize showIndex = _showIndex;
@synthesize subViewControllers = _subViewControllers;

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:UMComSimpleImageWithImageName(@"user") style:UIBarButtonItemStylePlain target:self action:@selector(onTouchDiscover)];
    
    UIButton* disCoverBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    disCoverBtn.frame = CGRectMake(0, 0, 40, 44);
    [disCoverBtn setImage:UMComSimpleImageWithImageName(@"user") forState:UIControlStateNormal];
    [disCoverBtn addTarget:self action:@selector(onTouchDiscover) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:disCoverBtn];
    [rightButton setWidth:44];
    
    self.userMessageView = [self creatNoticeViewWithOriginX:25 withOriginY:10];
    
    self.userMessageView.backgroundColor = [UIColor redColor];
    [disCoverBtn addSubview:self.userMessageView];

    self.navigationItem.rightBarButtonItem = rightButton;
    
    [self createMenuView];
//    [self.navigationController.navigationBar addSubview:_menuView];
    // Do any additional setup after loading the view.
}

- (UIView *)creatNoticeViewWithOriginX:(CGFloat)originX withOriginY:(CGFloat)originY
{
    CGFloat noticeViewWidth = 7;
    UIView *itemNoticeView = [[UIView alloc]initWithFrame:CGRectMake(originX,originY, noticeViewWidth, noticeViewWidth)];
    itemNoticeView.backgroundColor = [UIColor redColor];
    itemNoticeView.layer.cornerRadius = noticeViewWidth/2;
    itemNoticeView.clipsToBounds = YES;
    itemNoticeView.hidden = YES;
    return itemNoticeView;
}

- (void)onTouchDiscover
{


}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)createMenuView
{
    CGFloat menuWidth = 120;
    self.menuView = [[UMComSimpleHorizonMenuView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-UMComWidthScaleBetweenCurentScreenAndiPhone6Screen(menuWidth/2), 0, UMComWidthScaleBetweenCurentScreenAndiPhone6Screen(menuWidth), 40) titles:self.titlesArray];
    self.menuView.cellDelegate = self;
    self.menuView.showScrollIndicator = YES;
    
    //更新menuView的位置,宽度会根据cell的宽度变化
    CGRect scrollIndicatorViewRC = self.menuView.scrollIndicatorView.frame;
    scrollIndicatorViewRC.origin.y -= 2;
    scrollIndicatorViewRC.size.height = 2;
    scrollIndicatorViewRC.size.width = 70;
    
    self.menuView.scrollIndicatorView.frame = scrollIndicatorViewRC;
    self.menuView.scrollIndicatorView.backgroundColor = UMComColorWithColorValueString(FontColorBlue);

    self.menuView.titleHightColor = UMComColorWithColorValueString(@"333333");
    self.menuView.titleColor = UMComColorWithColorValueString(@"999999");
    
    self.menuView.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = _menuView;
}

- (void)setTitlesArray:(NSArray *)titlesArray
{
    _titlesArray = titlesArray;
    self.menuView.titlesArray = titlesArray;
    [self.menuView reloadData];
}

#pragma mark - menuViewDelegate

- (void)horizonCollectionView:(UMComSimpleHorizonMenuView *)collectionView didSelectedColumn:(NSInteger)column
{
    self.showIndex = column;
}



#pragma mark - set and get
- (void)setSubViewControllers:(NSArray *)subViewControllers
{
    _subViewControllers = subViewControllers;
    for (UIViewController *viewController in _subViewControllers) {
        viewController.view.frame = self.view.bounds;
        [self addChildViewController:viewController];
    }
    if (_subViewControllers.count > 0) {
        [self transitionFromViewControllerAtIndex:_subViewControllers.count-1 toViewControllerAtIndex:self.showIndex animations:nil completion:nil];
    }
}

- (NSArray *)subViewControllers
{
    return _subViewControllers;
}


- (void)setShowIndex:(NSInteger)showIndex
{
    _showIndex = showIndex;
    [self transitionFromViewControllerAtIndex:self.menuView.lastIndex toViewControllerAtIndex:_showIndex animations:nil completion:nil];
    [self didTransitionToIndex:showIndex];
}

- (void)didTransitionToIndex:(NSInteger)index
{


}

- (NSInteger)showIndex
{
    return _showIndex;
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

@end
