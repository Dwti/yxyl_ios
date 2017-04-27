//
//  ScaleView.m
//  test
//
//  Created by 贾培军 on 2016/11/2.
//  Copyright © 2016年 DJ. All rights reserved.
//

#import "ScaleView.h"

@implementation ScaleView

#pragma mark-
- (void)setupUI{
    self.clipsToBounds = NO;
    self.layer.borderWidth = 2;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.backgroundColor = [UIColor clearColor];
}

- (void)drawRect:(CGRect)rect{
    CGFloat height = self.height / 3;
    CGFloat width = self.width / 3;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 0, height);
    CGContextAddLineToPoint(context, self.width, height);
    CGContextAddLineToPoint(context, self.width, height * 2);
    CGContextAddLineToPoint(context, 0, height * 2);
    CGContextAddLineToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, width, 0);
    CGContextAddLineToPoint(context, width, self.height);
    CGContextAddLineToPoint(context, width * 2, self.height);
    CGContextAddLineToPoint(context, width * 2, 0);
    CGContextStrokePath(context);
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

@end
