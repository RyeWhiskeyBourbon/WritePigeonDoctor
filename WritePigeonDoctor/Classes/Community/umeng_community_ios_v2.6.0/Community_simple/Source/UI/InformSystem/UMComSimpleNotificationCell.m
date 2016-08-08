//
//  UMComSimpleNotificationCell.m
//  UMCommunity
//
//  Created by umeng on 16/5/17.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComSimpleNotificationCell.h"
#import "UMComNotification.h"
#import "UMComUser.h"
#import "UMComLabel.h"
#import "UMComImageUrl.h"
#import "UMComTools.h"
#import "UMComAvatarImageView.h"

@interface UMComSimpleNotificationCell ()

@property (nonatomic, strong) UMComAvatarImageView *realAvatar;

@end

@implementation UMComSimpleNotificationCell

- (void)awakeFromNib {
    
    self.dateIcon.image = UMComSimpleImageWithImageName(@"um_time");
    self.realAvatar = [UMComAvatarImageView filletAvatarWithFrame:self.avatorImageView.bounds];
    [self.avatorImageView addSubview:_realAvatar];
    
    self.customBgView.layer.borderColor = UMComColorWithColorValueString(@"#dfdfdf").CGColor;
    self.customBgView.layer.borderWidth = 1.f;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.contentLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.contentLabel.frame);
    self.contentLabel.lineSpace = 2;
}

- (void)reloadCellWithNotification:(UMComNotification *)notification
{
    self.nameLabel.text = notification.creator.name;
    self.dateLabel.text = createTimeString(notification.create_time);
    [self.realAvatar resetAvatarWithUser:notification.creator];
    self.contentLabel.textForAttribute = notification.content;
    //更新约束
    [self.contentLabel updateConstraintsIfNeeded];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.customBgView setNeedsLayout];
    [self.customBgView layoutIfNeeded];
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    self.contentLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.contentLabel.frame);
}
@end
