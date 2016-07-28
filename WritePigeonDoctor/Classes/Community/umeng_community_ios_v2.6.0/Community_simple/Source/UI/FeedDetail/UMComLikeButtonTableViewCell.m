//
//  UMComLikeButtonTableViewCell.m
//  UMCommunity
//
//  Created by umeng on 16/6/2.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComLikeButtonTableViewCell.h"
#import "UMComTools.h"
@implementation UMComLikeButtonTableViewCell

- (void)awakeFromNib {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.likeButton.clipsToBounds = YES;
    self.likeButton.layer.cornerRadius = self.likeButton.frame.size.height/2;
    self.likeButton.layer.borderWidth = 1;
    self.likeButton.layer.borderColor = UMComColorWithColorValueString(@"#469EF8").CGColor;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onClikOnLikeButton:(UIButton *)sender {
    
    if (self.clickOnLikeButton) {
        self.clickOnLikeButton(sender);
    }
}
@end
