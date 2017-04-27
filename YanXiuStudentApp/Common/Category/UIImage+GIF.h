//
//  UIImage+GIF.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/1/4.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GIF)

+ (UIImage *)nyx_animatedGIFNamed:(NSString *)name;
+ (UIImage *)nyx_animatedGIFWithData:(NSData *)data;
- (UIImage *)nyx_animatedImageByScalingAndCroppingToSize:(CGSize)size;

@end
