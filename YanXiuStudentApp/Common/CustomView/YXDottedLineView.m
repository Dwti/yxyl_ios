//
//  YXDottedLineView.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/12/9.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXDottedLineView.h"
#import <QuartzCore/QuartzCore.h>

@interface YXDottedLineView ()

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) YXDottedLineOrientation orientation;
@property (nonatomic, strong) UIColor *color;

@end

@implementation YXDottedLineView

- (instancetype)initWithFrame:(CGRect)frame
                  orientation:(YXDottedLineOrientation)orientation
                        color:(UIColor *)color
{
    if (self = [super initWithFrame:frame]) {
        self.orientation = orientation;
        self.color = color;
        
        _lineView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:_lineView];
    }
    return self;
}

- (void)drawWithDotLength:(CGFloat)dotLength
           intervalLength:(CGFloat)intervalLength
{
    if (!self.color) {
        return;
    }
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:self.lineView.bounds];
    [shapeLayer setPosition:self.lineView.center];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    // 设置虚线衔接方式
    [shapeLayer setLineJoin:kCALineJoinRound];
    // 设置每条线的间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:dotLength], [NSNumber numberWithInt:intervalLength], nil]];
    // 设置虚线颜色
    [shapeLayer setStrokeColor:self.color.CGColor];
    // 设置虚线路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGFloat lineWidth = 1.f;
    if (self.orientation == YXDottedLineOrientationHorizontal) {
        lineWidth = CGRectGetHeight(self.lineView.bounds);
        CGPathAddLineToPoint(path, NULL, CGRectGetWidth(self.lineView.bounds), 0);
    } else {
        lineWidth = CGRectGetWidth(self.lineView.bounds);
        CGPathAddLineToPoint(path, NULL, 0, CGRectGetHeight(self.lineView.bounds));
    }
    [shapeLayer setPath:path];
    CGPathRelease(path);
    // 设置虚线的宽度
    [shapeLayer setLineWidth:lineWidth];
    
    [[self.lineView layer] addSublayer:shapeLayer];
}

//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
//    // 设置虚线衔接方式
//    CGContextSetLineJoin(context, kCGLineJoinRound);
//    // 设置每条线的长度和间距
//    CGFloat lengths[] = {self.dotLength, self.intervalLength};
//    CGContextSetLineDash(context, 0, lengths, 2);
//    // 设置虚线路径
//    CGContextMoveToPoint(context, 0, 0);
//    CGFloat lineWidth = 1.f;
//    if (self.orientation == YXDottedLineOrientationHorizontal) {
//        lineWidth = CGRectGetHeight(rect);
//        CGContextAddLineToPoint(context, CGRectGetWidth(rect), 0);
//    } else {
//        lineWidth = CGRectGetWidth(rect);
//        CGContextAddLineToPoint(context, 0, CGRectGetHeight(rect));
//    }
//    // 设置虚线的宽度
//    CGContextSetLineWidth(context, lineWidth);
//    // 设置虚线颜色
//    [self.color setStroke];
//    CGContextStrokePath(context);
//}

@end
