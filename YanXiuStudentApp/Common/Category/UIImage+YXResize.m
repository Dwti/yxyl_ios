//
//  UIImage+YXResize.m
//  abc
//
//  Created by niuzhaowang on 16/1/20.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "UIImage+YXResize.h"

@implementation UIImage (YXResize)

+ (UIImage *)yx_resizableImageNamed:(NSString *)name{
    UIImage *image = [UIImage imageNamed:name];
    CGSize size = image.size;
    CGFloat top = size.height/2;
    CGFloat bottom = size.height-top-1;
    CGFloat left = size.width/2;
    CGFloat right = size.width-left-1;
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, bottom, right)];
    return image;
}

@end
