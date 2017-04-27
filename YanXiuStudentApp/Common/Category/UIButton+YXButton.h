//
//  UIButton+YXButton.h
//  YXKit
//
//  Created by ChenJianjun on 15/5/12.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (YXButton)

/**
 * 按钮的文字与图片位置互换，前提是文字与图片已设置好
 */
- (void)yx_exchangeTitleAndImagePosition;

/**
 *  设置按钮的文字颜色和图片，选中时文字和图片变浅50%
 *
 *  @param color 文字颜色
 *  @param image 按钮图片
 */
- (void)yx_setTitleColor:(UIColor *)color image:(UIImage *)image;

- (void)yx_setTitleColor:(UIColor *)color;

/**
 * uniformColor: 统一边框、未选中字、选中背景的颜色
 * highlightedTextColor: 设置选中后字的颜色
 */
- (void)yx_setUniformColor:(UIColor *)uniformColor
      highlightedTextColor:(UIColor *)highlightedTextColor;

@end
