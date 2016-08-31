//
//  PuborderViewController.m
//  WritePigeonDoctor
//
//  Created by ZYJY on 16/8/21.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "PuborderViewController.h"
#import "AddressPickerView.h"
#import "DatePicker.h"
#import "PubHeaderCell.h"
#import "PuborderCell.h"
#import "MultitextCell.h"
#import "RWOrderController.h"
@interface PuborderViewController()<UITableViewDataSource, UITableViewDelegate,RWNextStepViewDelegate>

@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic,strong) UILabel * orderLabel;
@property (nonatomic,strong) UIButton * orderButton;
@property(nonatomic,strong)RWServiceDetail *serviceDetail;
@property(nonatomic,strong)AddressPickerView *myAddressPickerView;
@property(nonatomic,strong)UIPickerView * currencyPicker;
@end


@implementation PuborderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"发布订单";
    _serviceDetail = [[RWServiceDetail alloc]init];
    [self layoutPageView];
    [self initOrderView];
}

-(void)layoutPageView
{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-108) style:UITableViewStylePlain];
        UIEdgeInsets insets = UIEdgeInsetsZero;
        _myTableView.contentInset = insets;
        _myTableView.showsVerticalScrollIndicator   = NO;
        _myTableView.showsHorizontalScrollIndicator = NO;
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.tableFooterView = [UIView new];
        
        [_myTableView registerClass:[PubHeaderCell class] forCellReuseIdentifier:NSStringFromClass([PubHeaderCell class])];
        [_myTableView registerClass:[PuborderCell class] forCellReuseIdentifier:NSStringFromClass([PuborderCell class])];
        [_myTableView registerClass:[MultitextCell class] forCellReuseIdentifier:NSStringFromClass([MultitextCell class])];
        [self.view addSubview:_myTableView];
        
    }
}

-(void)initOrderView
{
    RWNextStepView *nextStep = [RWNextStepView nextStepTitle:@"立即预约"
                                                 information:nil autoLayout:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(_myTableView.mas_bottom).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    
    nextStep.delegate = self;
    [self.view addSubview:nextStep];
}
-(void)toNextStep:(RWNextStepView *)nextStep
{
    
    RWUser *user = [[RWDataBaseManager defaultManager] getDefualtUser];
   
    _serviceDetail.serviceType = @(_orderService.serviceId);
    
    if (![_serviceDetail verificationResource])
    {
        RWOrderController *orderController = [[RWOrderController alloc]init];
        
        orderController.order = [RWOrder appointmentOrderWithUserName:user.username
                                                   servicedescription:_serviceDetail];
        
        [self.navigationController pushViewController:orderController animated:YES];
    }
    else
    {
        [RWSettingsManager promptToViewController:self
                                            Title:[_serviceDetail verificationResource]
                                         response:nil];
    }
}

- (BOOL) isBlankString:(NSString *)string
{
    if (string == nil || string == NULL)
    {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

#pragma mark --- UITableViewDataSource, UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
        {
            return 1;
        }
        case 1:
        {
            return 9;
        }
        case 2:
        {
            return 1;
        }
        default:return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            return 100;
        }
            break;
        case 1:
        {
            return 44;
        }
            break;
        case 2:
        {
            return 120;
        }
            break;
        default:
            break;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            PubHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PubHeaderCell class]) forIndexPath:indexPath];
            
            [cell.docNavImg setImageWithURL:[NSURL URLWithString:_orderService.serviceImage] placeholder:nil];
            cell.doctorWayLabel.text = _orderService.serviceName;
            
            if (!_serviceDetail.serviceSite || _orderService.serviceId == 2)
            {
                [cell.moneyLabel setColorFontText:
                        [NSString stringWithFormat:@"<[%@]>  元",_orderService.money]];
            }
            else if (_serviceDetail.serviceSite.integerValue == 2)
            {
                [cell.moneyLabel setColorFontText:
                    [NSString stringWithFormat:@"<[%@]>  元",_orderService.maxMoney]];
            }
            else if (_serviceDetail.serviceSite.integerValue == 3)
            {
                [cell.moneyLabel setColorFontText:
                 [NSString stringWithFormat:@"<[%@]>  元",_orderService.minMoney]];
            }
            
            return cell;
        }
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    PuborderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PuborderCell class]) forIndexPath:indexPath];
                    UIKeyboardType type =  UIKeyboardTypeDefault;
                    [cell setCellDataKey:@"姓名:" curValue:_serviceDetail.name blankValue:@"请填写你的姓名" isShowLine:YES cellType:TitleAndPromptCellTypeInput keyBoardType:type];
                    cell.textValueChangedBlock=^(NSString* text)
                    {
                        _serviceDetail.name =text;
                    };

                    return cell;

                }
                    break;
                case 1:
                {
                    PuborderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PuborderCell class]) forIndexPath:indexPath];
                    UIKeyboardType type =  UIKeyboardTypeNumberPad;
                    [cell setCellDataKey:@"电话:" curValue:_serviceDetail.contactWay blankValue:@"请填写你的电话" isShowLine:YES cellType:TitleAndPromptCellTypeInput keyBoardType:type];
                    cell.textValueChangedBlock=^(NSString* text)
                    {
                        _serviceDetail.contactWay = text;
                    };

                    return cell;

                }
                    break;
                case 2:
                {
                    PuborderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PuborderCell class]) forIndexPath:indexPath];
                    UIKeyboardType type = UIKeyboardTypeNumberPad;
                    [cell setCellDataKey:@"日期:" curValue:_serviceDetail.date blankValue:@"请选择日期" isShowLine:YES cellType:TitleAndPromptCellTypeSelect keyBoardType:type];
                    return cell;

                }
                    break;
                case 3:
                {
                    PuborderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PuborderCell class]) forIndexPath:indexPath];
                    UIKeyboardType type =  UIKeyboardTypeDefault;
                    [cell setCellDataKey:@"省份:" curValue:_serviceDetail.province blankValue:@"请选择省份" isShowLine:YES cellType:TitleAndPromptCellTypeSelect keyBoardType:type];
                    return cell;
                }
                    break;
                case 4:
                {
                    PuborderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PuborderCell class]) forIndexPath:indexPath];
                    UIKeyboardType type =  UIKeyboardTypeDefault;
                    [cell setCellDataKey:@"医院:" curValue:_serviceDetail.hospital blankValue:@"请填写你的医院" isShowLine:YES cellType:TitleAndPromptCellTypeInput keyBoardType:type];
                    cell.textValueChangedBlock=^(NSString* text)
                    {
                        _serviceDetail.hospital = text;
                    };

                    return cell;
                }
                    break;
                case 5:
                {
                    PuborderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PuborderCell class]) forIndexPath:indexPath];
                    UIKeyboardType type =  UIKeyboardTypeDefault;
                    [cell setCellDataKey:@"科室:" curValue:_serviceDetail.office blankValue:@"请填写你的科室(选填)" isShowLine:YES cellType:TitleAndPromptCellTypeInput keyBoardType:type];
                    cell.textValueChangedBlock=^(NSString* text)
                    {
                        _serviceDetail.office = text;
                    };
                    return cell;

                }
                    break;
                case 6:
                {
                    PuborderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PuborderCell class]) forIndexPath:indexPath];
                    UIKeyboardType type =  UIKeyboardTypeDefault;
                    [cell setCellDataKey:@"指定医生:" curValue:_serviceDetail.doctor blankValue:@"请填写指定医生(选填)" isShowLine:YES cellType:TitleAndPromptCellTypeInput keyBoardType:type];
                    cell.textValueChangedBlock=^(NSString* text)
                    {
                        _serviceDetail.doctor = text;
                    };

                    return cell;
                }
                    break;
                case 7:
                {
                    PuborderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PuborderCell class]) forIndexPath:indexPath];
                    UIKeyboardType type =  UIKeyboardTypeDefault;
                    [cell setCellDataKey:@"地址:" curValue:_serviceDetail.address blankValue:@"请填你的详细地址" isShowLine:YES cellType:TitleAndPromptCellTypeInput keyBoardType:type];
                    cell.textValueChangedBlock=^(NSString* text)
                    {
                         _serviceDetail.address = text;
                    };

                    return cell;
                }
                case 8:
                {
                    NSString *curValue = _serviceDetail.serviceSite?
                        stringServiceSite(_serviceDetail.serviceSite.integerValue):nil;
                    
                    PuborderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PuborderCell class]) forIndexPath:indexPath];
                    UIKeyboardType type =  UIKeyboardTypeDefault;
                    [cell setCellDataKey:@"服务地点:"
                                curValue:curValue
                              blankValue:@"请选择服务地点"
                              isShowLine:YES
                                cellType:TitleAndPromptCellTypeSelect
                            keyBoardType:type];
                    
                    cell.textValueChangedBlock=^(NSString* text)
                    {
                        _serviceDetail.serviceSite = serviceSiteWithString(text);
                    };
                    
                    return cell;
                }

                default:
                    break;
            }
            
        }
            break;
        case 2:
        {
            MultitextCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MultitextCell   class]) forIndexPath:indexPath];
            [cell setCellDataKey:@"备注:" textValue:_serviceDetail.comments blankValue:@"病人病情的详细描述" showLine:NO];
            cell.placeFontSize=14;
            cell.textValueChangedBlock=^(NSString* text)
            {
                _serviceDetail.comments = text;
            };
            return cell;

        }
            break;
        default:
            break;
    }
    
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSIndexPath * path1 = [NSIndexPath indexPathForRow:0 inSection:1];
    PuborderCell * cell1 = [tableView cellForRowAtIndexPath:path1];
    NSIndexPath * path2 = [NSIndexPath indexPathForRow:1 inSection:1];
    PuborderCell * cell2 = [tableView cellForRowAtIndexPath:path2];
    NSIndexPath * path3 = [NSIndexPath indexPathForRow:6 inSection:1];
    PuborderCell * cell3 = [tableView cellForRowAtIndexPath:path3];
    __weak typeof(self)weakSelf = self;
     if (indexPath.section == 1) {
            switch (indexPath.row) {
                case 0:
                {
                    
                }
                    break;
                case 1:
                {
                    
                    
                }
                    break;
                case 2:
                {
                    [cell1 resignFirstResponder];
                    [cell2 resignFirstResponder];
                    [cell3 resignFirstResponder];
                    
                    [[[DatePicker alloc]initWithBlock:^(id data) {
                        
                        _serviceDetail.date = data;
                        [weakSelf.myTableView reloadData];
                        
                    }]show];

 
                }
                    break;
                case 3:
                {
                    [cell1 resignFirstResponder];
                    [cell2 resignFirstResponder];
                    [cell3 resignFirstResponder];
                    
                    _myAddressPickerView = [AddressPickerView shareInstance];
                    [_myAddressPickerView showAddressPickView];
                    [self.view addSubview:_myAddressPickerView];
                    _myAddressPickerView.block = ^(NSString *province)
                    {
                          weakSelf.serviceDetail.province = province;
                          [weakSelf.myTableView reloadData];
                    };
                }
                    break;
                case 4:
                {
                    
                }
                    break;
                case 8:
                {
                    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"请选择服务地点" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
                    
                    if (_orderService.serviceId != RWServiceTypeGetTestReport)
                    {
                        UIAlertAction * hosAction = [UIAlertAction actionWithTitle:@"上门服务" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                            
                            weakSelf.serviceDetail.serviceSite = serviceSiteWithString(@"上门服务");
                            
                            [_myTableView reloadData];
                        }];
                        
                        [alert addAction:hosAction];
                    }
                    
                    UIAlertAction * goAction = [UIAlertAction actionWithTitle:@"医院内服务" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                        
                       weakSelf.serviceDetail.serviceSite = serviceSiteWithString(@"医院内服务");
                        
                        
                        
                        [_myTableView reloadData];
                    }];
                    
                    UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    
                    [alert addAction:goAction];
                    [alert addAction:cancleAction];
                    [self presentViewController:alert animated:YES completion:nil];
                 }
                    break;
                default:
                    break;
             }
       }
}
    
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12;
}

#pragma mark 自定义代码

-(NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle];
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, title.length)];
    [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, title.length)];
    return title;
}


- (NSInteger)indexOfFirst:(NSString *)firstLevelName firstLevelArray:(NSArray *)firstLevelArray
{
    NSInteger index = [firstLevelArray indexOfObject:firstLevelName];
    if (index == NSNotFound) {
        return 0;
    }
    return index;
}

@end
