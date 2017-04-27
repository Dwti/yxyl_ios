//
//  YXDottedLineView.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/12/9.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YXDottedLineOrientation) {
    YXDottedLineOrientationHorizontal, //水平线
    YXDottedLineOrientationVertical,   //垂直线
};

/**
 *  虚线绘制
 */
@interface YXDottedLineView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                  orientation:(YXDottedLineOrientation)orientation
                        color:(UIColor *)color;

- (void)drawWithDotLength:(CGFloat)dotLength
           intervalLength:(CGFloat)intervalLength;

@end
