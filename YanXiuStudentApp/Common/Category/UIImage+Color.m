//
//  UIImage+Color.m
//  Le123PhoneClient
//
//  Created by CaiLei on 1/7/14.
//  Copyright (c) 2014 Ying Shi Da Quan. All rights reserved.
//

#import "UIImage+Color.h"

@implementation UIImage (Color)

+ (UIImage *)imageWithColor:(UIColor *)color {
    return [UIImage imageWithColor:color rect:CGRectMake(0, 0, 1, 1)];
}

+ (UIImage *)imageWithColor:(UIColor *)color rect:(CGRect)aRect {
    UIGraphicsBeginImageContextWithOptions(aRect.size, NO, 0);
    [color setFill];
    UIRectFill(aRect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)imageReplaceWithColor:(UIColor *)color {
    UIImage *output = nil;
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    UIGraphicsBeginImageContextWithOptions(self.size,
                                           NO,
                                           self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);

    // mask color
    CGContextClipToMask(context, rect, self.CGImage);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return output;
    
}

- (UIImage *)imageAddMaskWithTintColor:(UIColor *)tintColor {
    UIImage *output = nil;
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    UIGraphicsBeginImageContextWithOptions(self.size,
                                           NO,
                                           self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    

    CGContextSetBlendMode(context, kCGBlendModeNormal);
    // 原image
    CGContextDrawImage(context, rect, self.CGImage);
    // mask color
    CGContextClipToMask(context, rect, self.CGImage);
    CGContextSetFillColorWithColor(context, tintColor.CGColor);
    CGContextFillRect(context, rect);
    
    output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return output;
}
@end
