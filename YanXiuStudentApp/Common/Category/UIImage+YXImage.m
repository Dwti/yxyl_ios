//
//  UIImage+YXImage.m
//  YXKit
//
//  Created by ChenJianjun on 15/5/12.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "UIImage+YXImage.h"

@implementation UIImage (YXImage)

+ (UIImage *)yx_createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1.f, 1.f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)yx_imageWithColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (NSData *)compressionImage:(UIImage *)originImage
                   limitSize:(NSInteger)limitSize
{
    CGFloat compression = 1.0f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(originImage, compression);
    while ([imageData length] > limitSize && compression > maxCompression) {
        @autoreleasepool {
            UIImage *image = nil;
            if (compression == 1.0f) {
                image = originImage;
                compression -= 0.8;
            } else {
                image = [UIImage imageWithData:imageData];
                image = [image scaleToSize:CGSizeMake(image.size.width/2, image.size.height/2)];
            }
            imageData = UIImageJPEGRepresentation(image, compression);
        }
    }
    return imageData;
}

- (UIImage *)scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *)nyx_grayImage {
    int bitmapInfo =kCGImageAlphaNone;
    int width = self.size.width*self.scale;
    int height = self.size.height*self.scale;
    CGColorSpaceRef colorSpace =CGColorSpaceCreateDeviceGray();
    CGContextRef context =CGBitmapContextCreate (nil,
                                                 width,
                                                 height,
                                                 8,     // bits per component
                                                 0,
                                                 colorSpace,
                                                 bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    if (context ==NULL) {
        return nil;
    }
    CGContextDrawImage(context,
                       CGRectMake(0,0, width, height), self.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    return grayImage;
}

- (UIImage *)nyx_imageWithAlpha:(CGFloat)alpha {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    CGContextDrawImage(ctx, area, self.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (CGSize)nyx_aspectFillSizeWithSize:(CGSize)size {
    CGFloat scaleW = self.size.width/size.width;
    CGFloat scaleH = self.size.height/size.height;
    CGFloat scale = MIN(scaleH, scaleW);
    CGSize scaledSize = CGSizeMake(self.size.width/scale, self.size.height/scale);
    return scaledSize;
}

- (CGSize)nyx_aspectFitSizeWithSize:(CGSize)size {
    CGFloat scaleW = self.size.width/size.width;
    CGFloat scaleH = self.size.height/size.height;
    CGFloat scale = MAX(scaleH, scaleW);
    CGSize scaledSize = CGSizeMake(self.size.width/scale, self.size.height/scale);
    return scaledSize;
}

- (UIImage *)nyx_aspectFillImageWithSize:(CGSize)size {
    CGSize scaledSize = [self nyx_aspectFillSizeWithSize:size];
    CGFloat x = -(scaledSize.width-size.width)/2;
    CGFloat y = -(scaledSize.height-size.height)/2;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [self drawInRect:CGRectMake(x, y, scaledSize.width, scaledSize.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *)nyx_aspectFitImageWithSize:(CGSize)size {
    CGSize scaledSize = [self nyx_aspectFitSizeWithSize:size];
    CGFloat x = (size.width-scaledSize.width)/2;
    CGFloat y = (size.height-scaledSize.height)/2;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [self drawInRect:CGRectMake(x, y, scaledSize.width, scaledSize.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
