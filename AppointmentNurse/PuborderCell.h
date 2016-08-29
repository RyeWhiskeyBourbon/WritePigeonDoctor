//
//  PuborderCell.h
//  WritePigeonDoctor
//
//  Created by ZYJY on 16/8/21.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TitleAndPromptCellType)
{
    TitleAndPromptCellTypeInput = 0,
    TitleAndPromptCellTypeSelect
};


@interface PuborderCell : UITableViewCell


@property (nonatomic,copy) void(^textValueChangedBlock)(NSString* text);

-(void)setCellDataKey:(NSString *)curkey curValue:(NSString *)curvalue blankValue:(NSString *)blankvalue isShowLine:(BOOL)showLine cellType:(TitleAndPromptCellType)cellType keyBoardType:(UIKeyboardType )type;

-(BOOL)becomeFirstResponder;

-(BOOL)resignFirstResponder;


@end
