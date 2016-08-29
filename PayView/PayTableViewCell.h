//
//  PayTableViewCell.h
//  WritePigeonDoctor
//
//  Created by ZYJY on 16/8/17.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayTableViewCell : UITableViewCell


@property(nonatomic,strong)UILabel * conselWayLabel;
@property(nonatomic,strong)UILabel * moneyLabel;

@end

@interface PayMoneyCell : UITableViewCell

@property(nonatomic,strong)UILabel * moneyLabel;

@end

@interface setPayWayCell : UITableViewCell

@property(nonatomic,strong)UIImageView * rirImage;

@end