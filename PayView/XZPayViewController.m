//
//  XZPayViewController.m
//  WritePigeonDoctor
//
//  Created by ZYJY on 16/8/17.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "XZPayViewController.h"
#import "PayTableViewCell.h"
@interface XZPayViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * payTableView;
@property (nonatomic,strong) NSArray *dataSource;
@property (nonatomic,strong) UIButton * payButton;
@property (nonatomic,assign) NSInteger  payInt;

@end

static NSString * const conselCell=@"conselCell";
static NSString *const payMoneyCell = @"payMoneyCell";
static NSString *const payMethodCell = @"payMethodCell";

@implementation XZPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"支付";
     _payInt = 1;
    [self initTableView];
    [self initData];
}

- (void)initTableView
{
    _payTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-44) style:UITableViewStyleGrouped];
    _payTableView.backgroundColor = Wonderful_GrayColor1;
    _payTableView.backgroundView.backgroundColor = [UIColor clearColor];
    _payTableView.showsVerticalScrollIndicator = NO;
    _payTableView.scrollEnabled = NO;
    _payTableView.delegate = self;
    _payTableView.dataSource = self;
    [self.view addSubview:_payTableView];
    [_payTableView registerClass:[PayTableViewCell class] forCellReuseIdentifier:conselCell];
    [_payTableView registerClass:[PayMoneyCell class] forCellReuseIdentifier:payMoneyCell];
    [_payTableView registerClass:[setPayWayCell class] forCellReuseIdentifier:payMethodCell];
    
    _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _payButton.frame = CGRectMake(0, SCREEN_HEIGHT-108, SCREEN_WIDTH, 44);
    _payButton.backgroundColor = __WPD_MAIN_COLOR__;
    [_payButton setTitle:@"立即支付" forState:(UIControlStateNormal)];
    [_payButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [_payButton addTarget:self action:@selector(payButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_payButton];
}

- (void)initData
{
   _dataSource = @[@{@"title"    :@"支付宝支付",
                     @"subtitle" :@"推荐安装支付宝客户端的用户使用",
                     @"icon"     :@"36x36"},
                   @{@"title"    :@"微信支付",
                     @"subtitle" :@"推荐安装微信5.0及以上版本的用户使用",
                     @"icon"     :@"icon36_appwx_logo"},
                   @{@"title"    :@"银联支付",
                     @"subtitle" :@"推荐银联信用卡持卡人使用",
                     @"icon"     :@"uPay"}];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return 1;
    }else
    {
        return 3;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 3;
    }
    else if (section == 1)
    {
        return 3;
    }else
    {
        return 15;
    }

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0)
    {
       PayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:conselCell forIndexPath:indexPath];
        
        RWServiceSite site = _order.servicedescription.serviceSite.integerValue;
        RWServiceType type = _order.servicedescription.serviceType.integerValue;
        
        NSString *expenditure = [NSString stringWithFormat:@"%@ %@",
                                                             stringServiceSite(site),
                                                             stringServiceType(type)];
        
       cell.conselWayLabel.text = expenditure;
       cell.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",_order.money];
       return cell;
    }
    else if (indexPath.section == 1)
    {
        PayMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:payMoneyCell forIndexPath:indexPath];
        cell.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",_order.money];
       
        return cell;
    }
    else
    {
        setPayWayCell * cell=[tableView dequeueReusableCellWithIdentifier:payMethodCell forIndexPath:indexPath];
        cell.imageView.image = [UIImage imageNamed:_dataSource[indexPath.row][@"icon"]];
        cell.textLabel.text = _dataSource[indexPath.row][@"title"];
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
        cell.detailTextLabel.text = _dataSource[indexPath.row][@"subtitle"];
        if (indexPath.row == 0) {
        cell.rirImage.image = [UIImage imageNamed:@"选择"];
        }
        return cell;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 2)
    {
        return @"请选择支付方式";
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
      if (indexPath.section == 2)
    {
        NSIndexPath * path1 = [NSIndexPath indexPathForRow:0 inSection:2];
        setPayWayCell * cell1 = [tableView cellForRowAtIndexPath:path1];
        NSIndexPath * path2 = [NSIndexPath indexPathForRow:1 inSection:2];
        setPayWayCell * cell2 = [tableView cellForRowAtIndexPath:path2];
        NSIndexPath * path3 = [NSIndexPath indexPathForRow:2 inSection:2];
        setPayWayCell * cell3 = [tableView cellForRowAtIndexPath:path3];

        if (indexPath.row == 0)
        {
            _payInt = 1;
            cell1.rirImage.image = [UIImage imageNamed:@"选择"];
            cell2.rirImage.image = [UIImage imageNamed:@"没选择"];
            cell3.rirImage.image = [UIImage imageNamed:@"没选择"];
        }
        if(indexPath.row == 1)
        {
            
            _payInt = 2;
            cell1.rirImage.image = [UIImage imageNamed:@"没选择"];
            cell2.rirImage.image = [UIImage imageNamed:@"选择"];
            cell3.rirImage.image = [UIImage imageNamed:@"没选择"];

        }
         if(indexPath.row == 2)
        {
            _payInt = 3;
            cell1.rirImage.image = [UIImage imageNamed:@"没选择"];
            cell2.rirImage.image = [UIImage imageNamed:@"没选择"];
            cell3.rirImage.image = [UIImage imageNamed:@"选择"];

        }
    }
}

- (void)payButtonClick
{
    if (_payInt == 1)
    {
        _order.payMethot = RWPayMethotAlipay;
    }
    if (_payInt == 2)
    {
        
        _order.payMethot = RWPayMethotWXPay;
    }
    if (_payInt == 3)
    {
//        NSLog(@"银联");
    }
    
    //支付逻辑
}
@end
