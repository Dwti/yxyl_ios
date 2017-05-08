//
//  UIButton+HighlightColor.h
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/1/15.
//  Copyright (c) 2015 yanxiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (HighlightColor)
- (void)updateWithDefaultHighlightColor;
- (void)nyx_setBackgroundImage:(UIImage *)image forState:(UIControlState)state;
- (void)nyx_setImage:(UIImage *)image forState:(UIControlState)state;
@end
