//
//  AppConfig.h
//  Monkey
//
//  Created by coderyi on 15/7/11.
//  Copyright (c) 2015年 www.coderyi.com. All rights reserved.
//

#ifndef Monkey_AppConfig_h
#define Monkey_AppConfig_h

/**
 *   define
 */

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define iOS7GE [[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0
#define ApplicationDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

//我喜欢的蓝色
#define YiBlue [UIColor colorWithRed:0.24f green:0.51f blue:0.78f alpha:1.00f]
//灰色
#define YiGray [UIColor colorWithRed:0.80f green:0.80f blue:0.80f alpha:1.00f]
#define YiTextGray [UIColor colorWithRed:0.54f green:0.54f blue:0.54f alpha:1.00f]
#define YiRed [UIColor colorWithRed:0.93 green:0.41 blue:0.36 alpha:1]

// block self
#define WEAKSELF typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;

#define YKClientId @"bf5803ceb7daf89c"

#endif



