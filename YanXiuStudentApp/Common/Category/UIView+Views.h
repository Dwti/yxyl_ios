//
//  UIView+Views.h
//  Record
//
//  Created by 贾培军 on 16/3/17.
//  Copyright © 2016年 贾培军. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Views)

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;

- (void)removeAllSubviews;

@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, weak) UINavigationController *navigationController;

+ (UILabel *)copyLabel:(UILabel *)label;
+ (UIButton *)copyButton:(UIButton *)button;
+ (UITextField *)copyTextField:(UITextField *)label;

/**
 *  收起键盘
 */
- (void)packUpKeyboard;

@end
