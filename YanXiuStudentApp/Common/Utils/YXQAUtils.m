//
//  YXQAUtils.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/12/14.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXQAUtils.h"

@implementation YXQAUtils
+ (UIImage *)stemBgImage{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(50, 50), NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat radius = 10.f;
    CGFloat lineWidth = 2.f;
    CGFloat arcRadius = radius-lineWidth/2;
    CGFloat angleY = 17.f;
    CGFloat angleX = 7.f;
    CGFloat angleHeight = 10.f;
    
    CGContextMoveToPoint(context, angleX, angleY);
    CGContextAddLineToPoint(context, angleX, radius);
    CGContextAddArc(context, angleX+radius, radius, radius, M_PI, -M_PI_2, 0);
    CGContextAddLineToPoint(context, 50-radius, 0);
    CGContextAddArc(context, 50-radius, radius, radius, -M_PI_2, 0, 0);
    CGContextAddLineToPoint(context, 50, 50-radius);
    CGContextAddArc(context, 50-radius, 50-radius, radius, 0, M_PI_2, 0);
    CGContextAddLineToPoint(context, angleX+radius, 50);
    CGContextAddArc(context, angleX+radius, 50-radius, radius, M_PI_2, M_PI, 0);
    CGContextAddLineToPoint(context, angleX, angleY+angleHeight);
    CGContextAddLineToPoint(context, 0, angleY+angleHeight/2);
    CGContextClosePath(context);
    [[UIColor whiteColor]setFill];
    CGContextFillPath(context);
    
    CGContextMoveToPoint(context, angleX+lineWidth/2, angleY);
    CGContextAddLineToPoint(context, angleX+lineWidth/2, radius);
    CGContextAddArc(context, angleX+radius, radius, arcRadius, M_PI, -M_PI_2, 0);
    CGContextAddLineToPoint(context, 50-radius, lineWidth/2);
    CGContextAddArc(context, 50-radius, radius, arcRadius, -M_PI_2, 0, 0);
    CGContextAddLineToPoint(context, 50-lineWidth/2, 50-radius);
    CGContextAddArc(context, 50-radius, 50-radius, arcRadius, 0, M_PI_2, 0);
    CGContextAddLineToPoint(context, angleX+radius, 50-lineWidth/2);
    CGContextAddArc(context, angleX+radius, 50-radius, arcRadius, M_PI_2, M_PI, 0);
    CGContextAddLineToPoint(context, angleX+lineWidth/2, angleY+angleHeight);
    CGContextAddLineToPoint(context, lineWidth/2, angleY+angleHeight/2);
    CGContextClosePath(context);
    CGContextSetLineWidth(context, lineWidth);
    [[UIColor colorWithHexString:@"ccc4a3"]setStroke];
    CGContextStrokePath(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image stretchableImageWithLeftCapWidth:30 topCapHeight:30];
}
@end
