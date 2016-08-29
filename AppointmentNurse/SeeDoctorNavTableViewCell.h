//
//  SeeDoctorNavTableViewCell.h
//  WritePigeonDoctor
//
//  Created by ZYJY on 16/8/18.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILabel+Wonderful.h"

@interface SeeDoctorNavTableViewCell : UITableViewCell


@property(nonatomic,strong)UIImageView * docNavImg;
@property(nonatomic,strong)UILabel * doctorWayLabel;
@property(nonatomic,strong)UILabel * wayDesLabel;
@property(nonatomic,strong)UILabel * moneyLabel;
@property(nonatomic,strong)UILabel * appointLabel;

@end
