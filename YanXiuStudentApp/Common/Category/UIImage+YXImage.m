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

@end
