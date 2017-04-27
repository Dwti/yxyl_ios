//
//  UIButton+HighlightColor.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/1/15.
//  Copyright (c) 2015 yanxiu. All rights reserved.
//

#import "UIButton+HighlightColor.h"

@implementation UIButton (HighlightColor)
- (void)updateWithDefaultHighlightColor {
    CGFloat alpha = 0.5;
    
    UIColor *nColor = [self titleColorForState:UIControlStateNormal];
    UIColor *hColor = [nColor colorWithAlphaComponent:alpha];
    UIImage *nImage = [[self imageForState:UIControlStateNormal] imageReplaceWithColor:nColor];
    UIImage *hImage = [[self imageForState:UIControlStateNormal] imageReplaceWithColor:hColor];
    
    [self setTitleColor:nColor forState:UIControlStateNormal];
    [self setTitleColor:hColor forState:UIControlStateHighlighted];
    [self setImage:nImage forState:UIControlStateNormal];
    [self setImage:hImage forState:UIControlStateHighlighted];
}


@end
