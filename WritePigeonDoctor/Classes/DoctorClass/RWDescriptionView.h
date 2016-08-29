//
//  RWDescriptionView.h
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/7/27.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RWDescriptionView,RWRegisterOfficeView;

@protocol RWDescriptionViewDelegate <NSObject>

- (void)isAttentionAtDescriptionView:(RWDescriptionView *)descriptionView;
- (void)isShowDoctorDescription:(RWDescriptionView *)descriptionView;

@end

@interface RWDescriptionView : UITableView

@property (nonatomic,strong)RWDoctorItem *item;

@property (nonatomic,assign)BOOL isOpenDescription;
@property (nonatomic,assign)BOOL isAttention;

@property (nonatomic,strong)id<RWDescriptionViewDelegate> eventSource;

@end

@interface RWDescriptionCell : UITableViewCell

@property (nonatomic,strong)UIButton *attention;

@property (nonatomic,assign)BOOL isAttention;
@property (nonatomic,assign)BOOL isOpen;

@property (nonatomic,weak,readonly)RWDoctorItem *item;
@property (nonatomic,strong,readonly)RWCard *card;

- (void)setItem:(RWDoctorItem *)item attentionResponce:(void(^)(BOOL isAttention))attentionResponce isAttention:(BOOL)isAttention isOpen:(void(^)(BOOL isOpen))isOpen;

- (void)setCard:(RWCard *)card attentionResponce:(void(^)(BOOL isAttention))attentionResponce isAttention:(BOOL)isAttention isOpen:(void(^)(BOOL isOpen))isOpen;

@end

@interface RWPartitionView : UIView

@property (nonatomic,copy,readonly)void(^autoLayout)(MASConstraintMaker *make);
- (void)setAutoLayout:(void (^)(MASConstraintMaker *))autoLayout;

+ (instancetype)partitionWithAutoLayout:(void(^)(MASConstraintMaker *make))autoLayout switchControl:(void(^)(BOOL isOpen))switchControl;

@end

@protocol RWRegisterOfficeViewDelegate <NSObject>

@optional

- (void)consultWayAtRegisterOffice:(RWRegisterOfficeView *)registerOffice;
- (void)startConsultAtRegisterOffice:(RWRegisterOfficeView *)registerOffice;

@end

@interface RWRegisterOfficeView : UIView

@property (nonatomic,strong)UIButton *startBtn;
@property (nonatomic,strong)UILabel *contentLabel;

@property (nonatomic,strong)id<RWRegisterOfficeViewDelegate> delegate;

@end

@interface RWAnnouncementCell : UITableViewCell

@property (nonatomic,copy)NSString *context;

@end

@interface RWVisitHomeCell : UITableViewCell

@property (nonatomic,weak)RWWeekHomeVisit *item;

@property (nonatomic,strong)NSArray *visitHomeSource;

@end

@interface RWVisitHomeItemCell : UICollectionViewCell

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIImageView *imageLabel;

@end


