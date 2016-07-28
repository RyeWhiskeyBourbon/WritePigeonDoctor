//
//  RWDescriptionView.h
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/7/27.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RWDescriptionView : UITableView

@end

@interface RWDescriptionCell : UITableViewCell

@property (nonatomic,assign)BOOL isAttention;

@property (nonatomic,weak,readonly)RWDoctorItem *item;

- (void)setItem:(RWDoctorItem *)item attentionResponce:(void(^)(BOOL isAttention))attentionResponce isAttention:(BOOL)isAttention;

@end

@interface RWPartitionView : UIView

+ (instancetype)partitionWithAutoLayout:(void(^)(MASConstraintMaker *make))autoLayout switchControl:(void(^)(BOOL isOpen))switchControl;

@end

@interface RWRegisterOfficeCell : UITableViewCell

@end

@interface RWAnnouncementCell : UITableViewCell

@property (nonatomic,copy)NSString *context;

@end

@interface RWVisitHomeCell : UITableViewCell

@property (nonatomic,strong)NSArray *visitHomeSource;

@end

@interface RWVisitHomeItemCell : UICollectionViewCell

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIImageView *imageLabel;

@end


