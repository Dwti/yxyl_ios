//
//  YXDottedLineView+YXShadowLineMethod.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/12/15.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXDottedLineView.h"

/**
 *  带阴影虚线绘制
 */
@interface YXDottedLineView (YXShadowLineMethod)

/** 生成虚线视图
 * 默认color: e4b62e
 * 默认shadowColor: ffeb66
 */
+ (UIView *)shadowLineWithFrame:(CGRect)frame
                    orientation:(YXDottedLineOrientation)orientation;
+ (UIView *)shadowLineWithFrame:(CGRect)frame
                    orientation:(YXDottedLineOrientation)orientation
                          color:(UIColor *)color
                    shadowColor:(UIColor *)shadowColor;
// 绘制虚线
+ (void)drawShadowLine:(UIView *)shadowLine
             dotLength:(CGFloat)dotLength
        intervalLength:(CGFloat)intervalLength;

@end
