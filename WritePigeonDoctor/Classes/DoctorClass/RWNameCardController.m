//
//  RWNameCardController.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/8/14.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWNameCardController.h"
#import "RWDataBaseManager+NameCardCollectMessage.h"
#import "RWDescriptionView.h"
#import "RWCollectMessageController.h"

#ifndef __DESCRIPTION_DISTANCE__
#define __DESCRIPTION_DISTANCE__ 15
#endif

@interface RWNameCardController ()

<
    UITableViewDelegate,
    UITableViewDataSource
>

@property (nonatomic,strong)UITableView *cardList;

@property (nonatomic,strong)NSArray *cardSource;

@property (nonatomic,strong)NSIndexPath *openIndexPath;

@end

CGPoint offsetWithIndexPath(NSIndexPath *indexPath)
{
    CGFloat y = (__DESCRIPTION_HEIGHT_CLOSE__ + __DESCRIPTION_DISTANCE__) * indexPath.section;
    
    return CGPointMake(0, y);
}

@implementation RWNameCardController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _cardSource = [[RWDataBaseManager defaultManager] getNameCards];
    [_cardList reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _cardList = [[UITableView alloc] initWithFrame:self.view.bounds
                                             style:UITableViewStyleGrouped];
    [self.view addSubview:_cardList];
    
    [_cardList mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    
    _cardList.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _cardList.delegate = self;
    _cardList.dataSource = self;
    
    [_cardList registerClass:[RWDescriptionCell class]
      forCellReuseIdentifier:NSStringFromClass([RWDescriptionCell class])];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _cardSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RWDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RWDescriptionCell class]) forIndexPath:indexPath];
    
    cell.attention.hidden = YES;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    RWCard *card = _cardSource[indexPath.section];
    
    [cell setCard:card attentionResponce:^(BOOL isAttention) {
        
    } isAttention:NO isOpen:^(BOOL isOpen) {
    
        _openIndexPath = isOpen?indexPath:nil;
        tableView.scrollEnabled = !isOpen;
        [tableView reloadData];
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_openIndexPath &&  _openIndexPath.section == indexPath.section)
    {
        tableView.contentOffset = offsetWithIndexPath(indexPath);
        
        return __DESCRIPTION_HEIGHT_OPEN__;
    }
    
    return __DESCRIPTION_HEIGHT_CLOSE__;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == _cardSource.count - 1)
    {
        return 1;
    }
    
    return __DESCRIPTION_DISTANCE__;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RWCollectMessageController *collect = [[RWCollectMessageController alloc] init];
    
    collect.card = _cardSource[indexPath.section];
    
    [self.navigationController pushViewController:collect animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    RWDataBaseManager *baseManager = [RWDataBaseManager defaultManager];
    
    if ([baseManager removeCollectMessageWithCard:_cardSource[indexPath.row]])
    {
        if ([baseManager removeNameCard:_cardSource[indexPath.row]])
        {
            _cardSource = [baseManager getNameCards];
            
            [_cardList reloadData];
        }
        else
        {
            MESSAGE(@"删除收藏失败");
        }
    }
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
