//
//  UIImage+Color.h
//  Le123PhoneClient
//
//  Created by CaiLei on 1/7/14.
//  Copyright (c) 2014 Ying Shi Da Quan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)
+ (UIImage *)imageWithColor:(UIColor *)aColor;
+ (UIImage *)imageWithColor:(UIColor *)color rect:(CGRect)aRect;

- (UIImage *)imageReplaceWithColor:(UIColor *)color;
- (UIImage *)imageAddMaskWithTintColor:(UIColor *)tintColor;
@end
