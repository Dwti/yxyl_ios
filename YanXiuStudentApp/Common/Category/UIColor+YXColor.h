//
//  UIColor+YXColor.h
//  YXKit
//
//  Created by ChenJianjun on 15/5/12.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (YXColor)

// 十六进制字符串获取色值，如：ffffff
+ (UIColor *)yx_colorWithHexString:(NSString *)hexString;

// RGB值获取颜色, 如：223.f, 160.f, 58.f
UIColor *yx_colorWithRGB(CGFloat r, CGFloat g, CGFloat b);

@end
