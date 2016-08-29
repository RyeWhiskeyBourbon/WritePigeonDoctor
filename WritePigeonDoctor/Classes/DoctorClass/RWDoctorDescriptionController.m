//
//  RWDoctorDescriptionController.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/7/27.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWDoctorDescriptionController.h"
#import "RWConsultViewController.h"
#import "RWDescriptionView.h"
#import "RWDataModels.h"
#import "RWDataBaseManager+ChatCache.h"
#import "XZUMComPullRequest.h"
#import "RWOrderController.h"

@interface RWDoctorDescriptionController ()

<
    RWDescriptionViewDelegate,
    RWRegisterOfficeViewDelegate
>

@property (nonatomic,strong)RWDescriptionView *descriptionView;
@property (nonatomic,strong)RWRegisterOfficeView *officeView;

@end

@implementation RWDoctorDescriptionController

+ (instancetype)doctorDescroptionWith:(RWDoctorItem *)doctorItem
{
    RWDoctorDescriptionController *doctordes =
                                        [[RWDoctorDescriptionController alloc] init];
    
    doctordes.doctorItem = doctorItem;
    
    return doctordes;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect frame = self.view.bounds;
    
    frame.size.height -= self.navigationController.navigationBar.bounds.size.height + 20;
    
    _descriptionView = [[RWDescriptionView alloc] initWithFrame:frame];
    [self.view addSubview:_descriptionView];

    _descriptionView.eventSource = self;
    _descriptionView.item = _doctorItem;
    
    frame.origin.y = frame.size.height - 40;
    frame.size.height = 40;
    
    _officeView = [[RWRegisterOfficeView alloc] initWithFrame:frame];
    [self.view addSubview:_officeView];
    
    _officeView.delegate = self;
    
    _officeView.contentLabel.text = _descriptionView.item.expenses.count?_descriptionView.item.expenses[0]:nil;
    
    self.navigationItem.title = _descriptionView.item.name;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_descriptionView.item)
    {
        [_descriptionView reloadData];
    }
}

- (void)setDoctorItem:(RWDoctorItem *)doctorItem
{
    _doctorItem = doctorItem;
    
    _descriptionView.item = _doctorItem;
    
    if (_descriptionView.item)
    {
        [_descriptionView reloadData];
    }
}

#pragma mark - delegate

- (void)startConsultAtRegisterOffice:(RWRegisterOfficeView *)registerOffice
{
    RWChatManager *chatManager = [RWChatManager defaultManager];
    
    if (chatManager.connectionState)
    {
        [self.tabBarController toLoginViewController];
        
        return;
    }
    
    RWServiceDetail *serviceDetial = [[RWServiceDetail alloc] init];
    
    serviceDetial.serviceSite = @(RWServiceSiteInApp);
    serviceDetial.serviceType = @(RWServiceTypeConsult);
    
    RWUser *user = [[RWDataBaseManager defaultManager] getDefualtUser];
    
    serviceDetial.name = user.name;
    serviceDetial.office = _doctorItem.office;
    serviceDetial.doctor = _doctorItem.name;
    
    RWOrderController *orderController = [[RWOrderController alloc]init];
    
    orderController.order = [RWOrder consultOrderWithUserName:user.username
                                                    serviceid:_doctorItem.EMID
                                           servicedescription:serviceDetial];
    
    [self.navigationController pushViewController:orderController animated:YES];
    
//    RWConsultViewController *chatView = [[RWConsultViewController alloc] init];
//    
//    chatView.item = _doctorItem;
//    
//    [[RWDataBaseManager defaultManager] addConsultHistoryWithItem:chatView.item
//                                                       completion:^(BOOL success)
//     {
//         [self pushNextWithViewcontroller:chatView];
//         
//         if (!success)
//         {
//             MESSAGE(@"缓存失败");
//         }
//     }];
}

#pragma mark - event

- (void)isAttentionAtDescriptionView:(RWDescriptionView *)descriptionView
{
    if ([RWChatManager defaultManager].connectionState)
    {
        [self.tabBarController toLoginViewController];
        
        return;
    }
    
    if (_doctorItem.relation)
    {
        [XZUMComPullRequest userFollowWithUserID:_doctorItem.umid isFollow:NO completion:^(NSDictionary *responseObject, NSError *error) {
            
            if (!error)
            {
                _doctorItem.relation = NO;
                _descriptionView.item = _doctorItem;
                [_descriptionView reloadData];
            }
        }];
    }
    else
    {
        [XZUMComPullRequest userFollowWithUserID:_doctorItem.umid isFollow:YES completion:^(NSDictionary *responseObject, NSError *error) {
            
            if (!error || error.code == 10007)
            {
                _doctorItem.relation = YES;
                _descriptionView.item = _doctorItem;
                [_descriptionView reloadData];
            }
        }];
    }
}

- (void)isShowDoctorDescription:(RWDescriptionView *)descriptionView
{
    if (descriptionView.isOpenDescription)
    {
        _officeView.hidden = YES;
    }
    else
    {
        _officeView.hidden = NO;
    }
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
