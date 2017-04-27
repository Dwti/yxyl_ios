//
//  UIView+YXScale.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/12/14.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "UIView+YXScale.h"

@implementation UIView (YXScale)

+ (CGFloat)scale
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return 1.f;
    }
    return CGRectGetWidth([UIScreen mainScreen].bounds) / 375.f;
}

@end
