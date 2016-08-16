//
//  RWViewsOfMacro.h
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/7/31.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#ifndef RWViewsOfMacro_h
#define RWViewsOfMacro_h

#pragma mark - chat

#ifndef __RWCHAT_FONT__
#define __RWCHAT_FONT__ [UIFont systemFontOfSize:15]
#endif

#ifndef __RWGET_SYSFONT
#define __RWGET_SYSFONT(size) [UIFont systemFontOfSize:(size)]
#endif

#ifndef __MAIN_SCREEN_WIDTH__
#define __MAIN_SCREEN_WIDTH__ [UIScreen mainScreen].bounds.size.width
#endif

#ifndef __MAIN_SCREEN_HEIGHT__
#define __MAIN_SCREEN_HEIGHT__ [UIScreen mainScreen].bounds.size.height
#endif

#ifndef __MARGINS__
#define __MARGINS__ 10.f
#endif

#ifndef __TIME_MARGINS__
#define __TIME_MARGINS__ 3.f
#endif

#ifndef __TEXT_MARGINS__
#define __TEXT_MARGINS__ 10.f
#endif

#ifndef __HEADER_SIZE__
#define __HEADER_SIZE__ 40.f
#endif

#ifndef __ARROWHEAD_SIZE__
#define __ARROWHEAD_SIZE__ 10.f
#endif

#ifndef __CELL_LENGTH__
#define __CELL_LENGTH__ 60.f
#endif

#ifdef __MAIN_SCREEN_WIDTH__
#ifdef __MARGINS__
#ifdef __HEADER_SIZE__
#ifdef __ARROWHEAD_SIZE__
#ifndef __TEXT_LENGHT__
#define __TEXT_LENGHT__ (__MAIN_SCREEN_WIDTH__ - (__MARGINS__ + __HEADER_SIZE__ +__ARROWHEAD_SIZE__ + 5.f) * 2)
#endif
#endif
#endif
#endif
#endif

#ifdef __TEXT_LENGHT__
#ifndef __PICxVID_MAX_WIDTH__
#define __PICxVID_MAX_WIDTH__ __TEXT_LENGHT__
#endif
#endif

#ifndef __PICxVID_MAX_HEIGHT__
#define __PICxVID_MAX_HEIGHT__ 180.0f
#endif

#ifdef __MAIN_SCREEN_WIDTH__
#ifdef __MAIN_SCREEN_HEIGHT__
#ifndef __VIDEO_ORIGINAL_SIZE__
#define __VIDEO_ORIGINAL_SIZE__ CGSizeMake(__MAIN_SCREEN_WIDTH__, __MAIN_SCREEN_HEIGHT__ /3)
#endif
#endif
#endif

#ifdef __TEXT_LENGHT__
#ifndef __VOICE_MAX_OFFSET__
#define __VOICE_MAX_OFFSET__ __TEXT_LENGHT__ + __MARGINS__ + __HEADER_SIZE__ + __ARROWHEAD_SIZE__ + 5.f - 60.f
#endif
#ifndef __VOICE_LENTH
#define __VOICE_LENTH(scale) __TEXT_LENGHT__ * (1.0f - scale)
#endif
#endif

#ifndef __RWGET_COLOR
#define __RWGET_COLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:(a)]
#endif


#pragma mark - bar


#ifndef __RWGET_SYSFONT
#define __RWGET_SYSFONT(size) [UIFont systemFontOfSize:(size)]
#endif

#ifndef __BORDER_COLOR__
#define __BORDER_COLOR__ [UIColor grayColor]
#endif

#ifndef __KEYBOARD_HEIGHT__
#define __KEYBOARD_HEIGHT__ 216.f
#endif

#ifndef __KEYBOARD_SIZE__
#define __KEYBOARD_SIZE__ CGSizeMake(__MAIN_SCREEN_WIDTH__, __KEYBOARD_HEIGHT__)
#endif

#ifndef __KEYBOARD_POINT__
#define __KEYBOARD_POINT__ CGPointMake(0.f,__MAIN_SCREEN_HEIGHT__)
#endif

#ifndef __RWGET_FRAME
#define __RWGET_FRAME(point,size) CGRectMake(point.x, point.y, size.width, size.height)
#endif

#ifndef __KEYBOARD_FRAME__
#define __KEYBOARD_FRAME__ __RWGET_FRAME(__KEYBOARD_POINT__,__KEYBOARD_SIZE__)
#endif

#pragma mark - description

#ifndef __MAIN_NAV_HEIGHT__
#define __MAIN_NAV_HEIGHT__ self.navigationController.navigationBar.bounds.size.height
#endif

#ifndef __DESCRIPTION_HEIGHT_CLOSE__
#define __DESCRIPTION_HEIGHT_CLOSE__ 293.f
#endif

#ifndef __DESCRIPTION_HEIGHT_OPEN__
#define __DESCRIPTION_HEIGHT_OPEN__ (__MAIN_SCREEN_HEIGHT__ - 64)
#endif

#ifndef __ANNOUNCEMENT_HEIGHT__
#define __ANNOUNCEMENT_HEIGHT__ __MAIN_SCREEN_WIDTH__ / 58 * 15
#endif

#ifndef __VISIT_HEIGHT__
#define __VISIT_HEIGHT__ __MAIN_SCREEN_WIDTH__
#endif

#endif /* RWViewsOfMacro_h */
