//
//  MultitextCell.h
//  WritePigeonDoctor
//
//  Created by ZYJY on 16/8/21.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MultitextCell : UITableViewCell

@property(nonatomic,assign)CGFloat placeFontSize;

@property (nonatomic,copy) void(^textValueChangedBlock)(NSString* text);

+ (CGFloat)cellHeight;

-(void)setCellDataKey:(NSString *)cellTitle textValue:(NSString *)textValue blankValue:(NSString *)blankvalue showLine:(BOOL)isShowLine;

-(BOOL)becomeFirstResponder;

-(BOOL)resignFirstResponder;

@end
