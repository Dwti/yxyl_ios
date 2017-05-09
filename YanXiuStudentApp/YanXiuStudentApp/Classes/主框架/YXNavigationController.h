//
//  YXNavigationController.h
//  YXPublish
//
//  Created by ChenJianjun on 15/5/21.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, NavigationBarTheme) {
    NavigationBarTheme_Green = 0,
    NavigationBarTheme_White
};

/**
 *  通用导航控制器
 */
@interface YXNavigationController : UINavigationController
@property (nonatomic, assign) NavigationBarTheme theme;
@end
