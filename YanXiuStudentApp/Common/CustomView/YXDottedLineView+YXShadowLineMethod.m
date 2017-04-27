//
//  YXDottedLineView+YXShadowLineMethod.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/12/15.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXDottedLineView+YXShadowLineMethod.h"
#import "UIColor+YXColor.h"

@implementation YXDottedLineView (YXShadowLineMethod)

+ (UIView *)shadowLineWithFrame:(CGRect)frame orientation:(YXDottedLineOrientation)orientation
{
    return [self shadowLineWithFrame:frame
                         orientation:orientation
                               color:[UIColor yx_colorWithHexString:@"e4b62e"]
                         shadowColor:[UIColor yx_colorWithHexString:@"ffeb66"]];
}

+ (UIView *)shadowLineWithFrame:(CGRect)frame
                    orientation:(YXDottedLineOrientation)orientation
                          color:(UIColor *)color
                    shadowColor:(UIColor *)shadowColor
{
    UIView *containerView = [[UIView alloc] initWithFrame:frame];
    CGRect lineFrame = containerView.bounds;
    CGRect shadowLineFrame = CGRectZero;
    if (orientation == YXDottedLineOrientationHorizontal) {
        lineFrame.size.height /= 2.f;
        shadowLineFrame = lineFrame;
        shadowLineFrame.origin.y = CGRectGetMaxY(lineFrame);
    } else {
        lineFrame.size.width /= 2.f;
        shadowLineFrame = lineFrame;
        shadowLineFrame.origin.x = CGRectGetMaxX(lineFrame);
    }
    YXDottedLineView *lineView = [[YXDottedLineView alloc] initWithFrame:lineFrame orientation:orientation color:color];
    [containerView addSubview:lineView];
    YXDottedLineView *shadowLineView = [[YXDottedLineView alloc] initWithFrame:shadowLineFrame orientation:orientation color:shadowColor];
    [containerView addSubview:shadowLineView];
    return containerView;
}

+ (void)drawShadowLine:(UIView *)shadowLine
             dotLength:(CGFloat)dotLength
        intervalLength:(CGFloat)intervalLength
{
    for (UIView *subView in shadowLine.subviews) {
        if ([subView isKindOfClass:[YXDottedLineView class]]) {
            YXDottedLineView *line = (YXDottedLineView *)subView;
            [line drawWithDotLength:dotLength intervalLength:intervalLength];
        }
    }
}

@end
