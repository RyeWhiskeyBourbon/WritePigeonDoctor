//
//  UMComStatusView.h
//  UMCommunity
//
//  Created by wyq.Cloudayc on 6/14/16.
//  Copyright © 2016 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum{
    UMComNoLoad = 0,//还未加载
    UMComPreLoad = 1,//准备加载
    UMComLoading = 2,//正在加载
    UMComFinish = 3,//完成加载
    UMComNeedLoginMode = 4 //非访客模式(需要登录)
} UMComLoadStatus;


@interface UMComStatusView : UIView

@property (nonatomic, assign) BOOL isPull;

@property (nonatomic, assign) BOOL haveNextPage;

@property (nonatomic, assign) BOOL canReadNextPage; //yes 代表访客模式，能读取下一页，no代表非访客模式不能读取下一页

@property (nonatomic,retain) UILabel *statusLable;//显示状态信息

@property (nonatomic,retain) UIImageView *indicateImageView;//显示图片箭头图片

@property (nonatomic,retain) UIActivityIndicatorView *activityIndicatorView;//透明指示器

@property (nonatomic,assign) UMComLoadStatus  loadStatus;

@property (nonatomic, strong) UIView *lineSpace;

- (void)hidenVews;

@end
