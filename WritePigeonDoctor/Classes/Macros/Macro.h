//
//  Macro.h
//  WritePigeonDoctor
//
//  Created by ZYJY on 16/7/13.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

/************************系统公共************************/
//---------------------颜色-------------------
 // rgb颜色转换（16进制->10进制）
#define UIColorFromHEX(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

//---------------------Size-------------------

//屏幕尺寸
#define SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
//屏幕适配系数比(以iPhone6的屏幕宽度为基准)
#define UIScaleBetweenCurentScreenAndiPhone6Screen [UIScreen mainScreen].bounds.size.width/375
//字体
#define FONTWITHSIZE(FontSize) [UIFont systemFontOfSize:FontSize]
//一级标题
#define FIRSTFONTWITHSIZE [UIFont systemFontOfSize:18]
//二级标题
#define SECONDFONTWITHSIZE [UIFont systemFontOfSize:15]
//三级标题
#define THIEDFONTWITHSIZE [UIFont systemFontOfSize:12]

#define FontNotoSansLightWithSafeSize(FontSize) [UIFont fontWithName:@"" size:FontSize*UIScaleBetweenCurentScreenAndiPhone6Screen]?[UIFont fontWithName:@"" size:FontSize*UIScaleBetweenCurentScreenAndiPhone6Screen]:[UIFont systemFontOfSize:FontSize]

//---------------------block self-------------

#define WEAKSELF typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;

#define CHINESE_SYSTEM(x) [UIFont systemFontOfSize:x]

#define kScreenWidthRatio  (SCREEN_WIDTH / 320.0)
#define kScreenHeightRatio (SCREEN_HEIGHT / 568.0)
#define AdaptedWidth(x)  ceilf((x) * kScreenWidthRatio)
#define AdaptedHeight(x) ceilf((x) * kScreenHeightRatio)
#define AdaptedFontSize(R)     CHINESE_SYSTEM(AdaptedWidth(R))


#endif /* Macro_h */
