//
//  UIViewController+YXLoading.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/14.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (YXLoading)

// 开始loading，返回加载视图
- (UIView *)yx_startLoading;

// 结束loading
- (void)yx_stopLoading;

// 显示toast
- (void)yx_showToast:(NSString *)toast;

// 显示结果提示
- (void)yx_showTipsWithTitle:(NSString *)title
                        text:(NSString *)text
                  detailText:(NSString *)detailText;

@end
