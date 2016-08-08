//
//  UITabBar+badge.h
//  WritePigeonDoctor
//
//  Created by ZYJY on 16/8/4.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CustomBadgeType){
    kCustomBadgeStyleRedDot, //只有小红点
    kCustomBadgeStyleNumber, //带数字的
    kCustomBadgeStyleNone    //没有了
};

@interface UITabBar (badge)
/**
 *  设置Tabbar
 *
 *  @param type       类型
 *  @param badgeValue 数字
 *  @param index      TabbarIndex
 */
- (void)setBadgeStyle:(CustomBadgeType)type value:(NSInteger)badgeValue atIndex:(NSInteger)index;

/**
 *设置tab上icon的宽度，用于调整badge的位置
 */
- (void)setTabIconWidth:(CGFloat)width;

/**
 *设置badge的top
 */
- (void)setBadgeTop:(CGFloat)top;

@end
