//
//  AddressPickerView.m
//  WritePigeonDoctor
//
//  Created by ZYJY on 16/8/17.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "AddressPickerView.h"

@interface AddressPickerView()
@property (nonatomic) UIWindow *rootWindow;
@end

//定义弹出高度
static const CGFloat kPickerViewHeight=250;
static const CGFloat kTopViewHeight=40;

@implementation AddressPickerView
{
    NSArray   *_provinces;
    NSArray   *_citys;
    NSArray   *_areas;
    
    NSString  *_currentProvince;
    NSString  *_currentCity;
    NSString  *_currentDistrict;
    
    UIView        *_wholeView;
    UIView        *_topView;
    UIPickerView  *_pickerView;
}

+ (id)shareInstance
{
    static AddressPickerView *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[AddressPickerView alloc] init];
    });
    
    return shareInstance;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.userInteractionEnabled = YES;
        self.currentPickState=NO;
        
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor=RGBACOLOR(0, 0, 0, 0.8);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenAddressPickView)];
        [self addGestureRecognizer:tap];
        
        [self createData];
        [self createView];
    }
    return self;
}


- (void)createData
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"addressData" ofType:@"plist"];
    NSArray *data = [[NSArray alloc]initWithContentsOfFile:plistPath];
    
    _provinces = data;
    
//    _citys = [[_provinces objectAtIndex:0] objectForKey:@"cities"];
    _currentProvince = [[_provinces objectAtIndex:0] objectForKey:@"state"];
//    _currentCity = [[_citys objectAtIndex:0] objectForKey:@"city"];
//    _areas = [[_citys objectAtIndex:0] objectForKey:@"areas"];
//    if (_areas.count > 0) {
//        _currentDistrict = [_areas objectAtIndex:0];
//    } else {
//        _currentDistrict = @"";
//    }
}

- (void)createView
{
    _wholeView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kPickerViewHeight)];
    _wholeView.backgroundColor=[UIColor whiteColor];
    [self addSubview:_wholeView];
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kTopViewHeight)];
    _topView.backgroundColor = RGBACOLOR(0.1, 0.1, 0.1, 1);
    [_wholeView addSubview:_topView];
    
    // 防止点击事件触发
    UITapGestureRecognizer *topTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
    [_topView addGestureRecognizer:topTap];
    
    NSArray *buttonTitleArray = @[@"取消",@"确定"];
    for (int i = 0; i <buttonTitleArray.count ; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*(SCREEN_WIDTH-50), 0, 50, kTopViewHeight);
        [button setTitle:buttonTitleArray[i] forState:UIControlStateNormal];
        [_topView addSubview:button];
        
        button.tag = i;
        [button addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // 初始化pickerView
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, kTopViewHeight, SCREEN_WIDTH, kPickerViewHeight-kTopViewHeight)];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    [_wholeView addSubview:_pickerView];
}

- (void)buttonEvent:(UIButton *)button
{
    // 点击确定回调block
    if (button.tag == 1)
    {
        if (_block) {
            _block(_currentProvince);
        }
    }
    
    [self hiddenAddressPickView];
}


- (void)showAddressPickView
{
    [UIView animateWithDuration:0.3 animations:^
     {
         _wholeView.frame = CGRectMake(0, SCREEN_HEIGHT-kPickerViewHeight, SCREEN_WIDTH, kPickerViewHeight);
         
     } completion:^(BOOL finished) {
         self.currentPickState=YES;
         self.rootWindow = [UIApplication sharedApplication].keyWindow;
         [self.rootWindow addSubview:self];
     }];
}

- (void)hiddenAddressPickView
{
    [UIView animateWithDuration:0.3 animations:^
     {
         _wholeView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kPickerViewHeight);
     } completion:^(BOOL finished) {
         self.currentPickState=NO;
         [self removeFromSuperview];
     }];
}


#pragma mark - UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_provinces count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[_provinces objectAtIndex:row] objectForKey:@"state"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [pickerView selectRow:row inComponent:component animated:YES];
    _currentProvince = [[_provinces objectAtIndex:row] objectForKey:@"state"];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *pickerLabel = (UILabel *)view;
    if (!pickerLabel)
    {
        pickerLabel = [[UILabel alloc] init];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setFont:[UIFont systemFontOfSize:18]];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    
    return pickerLabel;
}


-(void)configDataProvince:(NSString *)provinceName
{
    NSString *provinceStr = provinceName;
    int oneColumn=0;
    
    for (int i=0; i<_provinces.count; i++)
    {
        if ([provinceStr isEqualToString:[_provinces[i] objectForKey:@"state"]]) {
            oneColumn = i;
        }
    }
    
    [self pickerView:_pickerView didSelectRow:oneColumn inComponent:0];
}

@end

