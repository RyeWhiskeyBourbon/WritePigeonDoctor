//
//  UMComStatusView.m
//  UMCommunity
//
//  Created by wyq.Cloudayc on 6/14/16.
//  Copyright © 2016 Umeng. All rights reserved.
//

#import "UMComStatusView.h"
#import "UMComTools.h"

@implementation UMComStatusView
{
    UIImage *upImage;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat defualtHeight = 50;
        CGFloat height = frame.size.height;
        CGFloat width = frame.size.width;
        CGFloat statusLableHeight = defualtHeight;
        CGFloat commonLabelOriginX = 60;
        self.statusLable = [[UILabel alloc]initWithFrame:CGRectMake(commonLabelOriginX, height-defualtHeight-5, width-commonLabelOriginX*2, statusLableHeight)];
        self.statusLable.textAlignment = NSTextAlignmentCenter;
        self.statusLable.font = UMComFontNotoSansLightWithSafeSize(15);
        self.activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityIndicatorView.frame = CGRectMake(10, height-(defualtHeight-(defualtHeight-40)/2), 40, 40);
        self.indicateImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, height-(defualtHeight-(defualtHeight-40)/2), 15, 35)];
        self.statusLable.backgroundColor = [UIColor clearColor];
        self.indicateImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        self.activityIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
        [self addSubview:self.statusLable];
        [self addSubview:self.indicateImageView];
        [self addSubview:self.activityIndicatorView];
        self.isPull = NO;
        self.loadStatus = UMComNoLoad;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setIsPull:(BOOL)isPull
{
    _isPull = isPull;
    if (isPull == NO) {
        self.statusLable.frame = CGRectMake(60, 0, self.frame.size.width-120, self.frame.size.height);
        self.activityIndicatorView.frame = CGRectMake(10, (self.frame.size.height - 40)/2, 40, 40);
        self.indicateImageView.frame= CGRectMake(20,(self.frame.size.height - 35)/2, 15, 35);
        self.lineSpace.hidden = YES;
    }
}

- (void)setLoadStatus:(UMComLoadStatus)loadStatus
{
    _loadStatus = loadStatus;
    [self setLoadStatus:loadStatus IsPull:self.isPull];
}

- (void)setLoadStatus:(UMComLoadStatus)loadStatus IsPull:(BOOL)isPull
{
    if (!upImage) {
        upImage = UMComImageWithImageName(@"grayArrow1");
        self.indicateImageView.image = upImage;
    }
    //UIImage *downImage = [self image:upImage rotation:UIImageOrientationDown];
    switch (loadStatus) {
        case UMComNoLoad:
        {
            self.indicateImageView.hidden = NO;
            self.statusLable.hidden = NO;
            if (isPull) {
                self.statusLable.text = UMComLocalizedString(@"um_com_pullDown_refresh", @"下拉刷新");
                //self.indicateImageView.image = upImage;
            }else{
                self.statusLable.text = UMComLocalizedString(@"um_com_pullUp_refresh", @"上拉可以加载更多");
                //self.indicateImageView.image = downImage;
                
            }
            
            self.indicateImageView.transform = CGAffineTransformMakeRotation(M_PI);
        }
            break;
        case UMComNeedLoginMode:
        {
            [self.activityIndicatorView stopAnimating];
            self.indicateImageView.hidden = YES;
            self.statusLable.hidden = NO;
            self.statusLable.text = UMComLocalizedString(@"um_com_login_read", @"登录后可查看更多内容");
        }
            break;
        case UMComPreLoad:
        {
            self.indicateImageView.hidden = NO;
            self.indicateImageView.transform = CGAffineTransformIdentity;
            if (isPull) {
                //[self setRotation:-2 animated:YES];
                self.statusLable.text = UMComLocalizedString(@"um_com_fingerUp_refresh", @"松手即可刷新");
            }else{
                //[self setRotation:2 animated:YES];
                self.statusLable.text = UMComLocalizedString(@"um_com_fingerUp_loadingMore", @"松手即可加载更多");
            }
        }
            break;
        case UMComLoading:
        {
            self.statusLable.text = UMComLocalizedString(@"um_com_Loading", @"正在加载");
            self.indicateImageView.hidden = YES;
            self.indicateImageView.transform = CGAffineTransformIdentity;
            [self.activityIndicatorView startAnimating];
        }
            break;
        case UMComFinish:
        {
            [self.activityIndicatorView stopAnimating];
            self.indicateImageView.hidden = YES;
            self.statusLable.hidden = NO;
            if (isPull) {
                self.statusLable.text = UMComLocalizedString(@"um_com_refreshFinish", @"刷新完成") ;
            }else if (_haveNextPage == NO){
                self.statusLable.text = UMComLocalizedString(@"um_com_login_read", @"已经是最后一页了");
                //                if (self.canReadNextPage == YES && ![UMComLoginManager isLogin]) {
                //                    self.statusLable.text = UMComLocalizedString(@"um_com_login_read", @"登录后可查看更多内容");
                //                }else{
                //                    self.statusLable.text = UMComLocalizedString(@"um_com_lastPage", @"已经是最后一页了");
                //                }
            }else{
                self.statusLable.text = UMComLocalizedString(@"um_com_loadingFinish", @"加载完成");
            }
            self.indicateImageView.transform = CGAffineTransformIdentity;
        }
            break;
        default:
            break;
    }
}

- (void)hidenVews
{
    self.statusLable.hidden = YES;
    self.indicateImageView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
}


- (void)setRotation:(NSInteger)rotation animated:(BOOL)animated
{
    if (rotation < -4)
        rotation = 4 - abs((int)rotation);
    if (rotation > 4)
        rotation = rotation - 4;
    if (animated)
    {
        [UIView animateWithDuration:0.1 animations:^{
            CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(rotation * M_PI / 2);
            self.indicateImageView.transform = rotationTransform;
        } completion:^(BOOL finished) {
        }];
    } else
    {
        CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(rotation * M_PI / 2);
        self.indicateImageView.transform = rotationTransform;
    }
}

-(UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    return newPic;
}

@end

