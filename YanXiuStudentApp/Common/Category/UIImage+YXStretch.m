//
//  UIImage+YXStretch.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/12/24.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "UIImage+YXStretch.h"

@implementation UIImage (YXStretch)

+ (UIImage *)stretchImageNamed:(NSString *)name{
    UIImage *image = [UIImage imageNamed:name];
    image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    return image;
}

@end
