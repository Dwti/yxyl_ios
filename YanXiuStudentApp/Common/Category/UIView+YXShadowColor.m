//
//  UIView+YXShadowColor.m
//  abc
//
//  Created by niuzhaowang on 16/1/20.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "UIView+YXShadowColor.h"

@implementation UIView (YXShadowColor)

- (void)yx_setShadowWithColor:(UIColor *)color{
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowRadius = 0;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowOpacity = 1;
}

@end
