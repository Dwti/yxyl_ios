//
//  HeadImageClipView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/9/5.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "HeadImageClipView.h"

@implementation HeadImageClipView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGFloat space = 23;
    CGFloat margin = 2+1/[UIScreen mainScreen].scale+space;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor colorWithHexString:@"89e00d"]setStroke];
    //画边框
    CGContextAddRect(context, CGRectMake(margin, margin, rect.size.width-margin*2, rect.size.height-margin*2));
    CGContextSetLineWidth(context, 1);
    CGContextStrokePath(context);
    
    //左上角
    CGContextMoveToPoint(context, 1+space, 22+space);
    CGContextAddLineToPoint(context, 1+space, 1+space);
    CGContextAddLineToPoint(context, 22+space, 1+space);
    //右上角
    CGContextMoveToPoint(context, rect.size.width-22-space, 1+space);
    CGContextAddLineToPoint(context, rect.size.width-1-space, 1+space);
    CGContextAddLineToPoint(context, rect.size.width-1-space, 22+space);
    //左下角
    CGContextMoveToPoint(context, 1+space, rect.size.height-22-space);
    CGContextAddLineToPoint(context, 1+space, rect.size.height-1-space);
    CGContextAddLineToPoint(context, 22+space, rect.size.height-1-space);
    //右下角
    CGContextMoveToPoint(context, rect.size.width-22-space, rect.size.height-1-space);
    CGContextAddLineToPoint(context, rect.size.width-1-space, rect.size.height-1-space);
    CGContextAddLineToPoint(context, rect.size.width-1-space, rect.size.height-22-space);
    CGContextSetLineWidth(context, 2);
    CGContextStrokePath(context);
}

@end
