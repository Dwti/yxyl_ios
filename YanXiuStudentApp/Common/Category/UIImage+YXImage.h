//
//  UIImage+YXImage.h
//  YXKit
//
//  Created by ChenJianjun on 15/5/12.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YXImage)

/**
 *  UIColor 转 UIImage
 *
 *  @param color
 *
 *  @return UIImage
 */
+ (UIImage *)yx_createImageWithColor:(UIColor *)color;

/**
 *  更改图片颜色
 *
 *  @param color 图片颜色
 *
 *  @return 处理好的图片
 */
- (UIImage *)yx_imageWithColor:(UIColor *)color;

/**
 * 图片压缩
 */
+ (NSData *)compressionImage:(UIImage *)originImage
                   limitSize:(NSInteger)limitSize;

- (UIImage *)scaleToSize:(CGSize)size;

- (UIImage *)nyx_imageWithAlpha:(CGFloat)alpha;
- (CGSize)nyx_aspectFillSizeWithSize:(CGSize)size;
- (CGSize)nyx_aspectFitSizeWithSize:(CGSize)size;
- (UIImage *)nyx_aspectFillImageWithSize:(CGSize)size;
- (UIImage *)nyx_aspectFitImageWithSize:(CGSize)size;

@end
