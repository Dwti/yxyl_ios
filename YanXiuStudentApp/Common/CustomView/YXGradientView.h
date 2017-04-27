//
//  YXGradientView.h
//  abc
//
//  Created by niuzhaowang on 16/1/20.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YXGradientOrientation) {
    YXGradientLeftToRight,
    YXGradientRightToLeft,
    YXGradientTopToBottom,
    YXGradientBottomToTop
};

@interface YXGradientView : UIView

/**
 *  渐变视图初始化，颜色从设定颜色渐变至透明
 *
 *  @param color       渐变初始颜色
 *  @param orientation 渐变方向
 *
 *  @return 返回实例
 */
- (instancetype)initWithColor:(UIColor *)color orientation:(YXGradientOrientation)orientation;

/**
 *  渐变视图初始化，颜色从起始颜色变至结束颜色
 *
 *  @param startColor  起始颜色
 *  @param endColor    结束颜色
 *  @param orientation 渐变方向
 *
 *  @return 返回实例
 */
- (instancetype)initWithStartColor:(UIColor *)startColor
                          endColor:(UIColor *)endColor
                       orientation:(YXGradientOrientation)orientation;



@end
