//
//  QAPhotoClipView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/15.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAPhotoClipView.h"

@implementation QAPhotoClipView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGFloat space = 23;
    CGFloat margin = 2+1/[UIScreen mainScreen].scale+space;
    CGFloat hStep = (rect.size.width-margin*2)/3.f;
    CGFloat vStep = (rect.size.height-margin*2)/3.f;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor colorWithHexString:@"89e00d"]setStroke];
    //画垂直线
    for (int i=0; i<4; i++) {
        CGContextMoveToPoint(context, margin+hStep*i, margin);
        CGContextAddLineToPoint(context, margin+hStep*i, rect.size.height-margin);
    }
    //画水平线
    for (int i=0; i<4; i++) {
        CGContextMoveToPoint(context, margin, margin+vStep*i);
        CGContextAddLineToPoint(context, rect.size.width-margin, margin+vStep*i);
    }
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
