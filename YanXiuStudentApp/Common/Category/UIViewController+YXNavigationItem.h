//
//  UIViewController+YXNavigationItem.h
//  YXPublish
//
//  Created by ChenJianjun on 15/5/21.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (YXNavigationItem)

// 添加左侧返回按钮
- (void)yx_setupLeftBackBarButtonItem;
- (void)yx_setupLeftBackBarButtonItemWithTitle:(NSString *)title;
// 返回按钮点击事件处理
- (void)yx_leftBackButtonPressed:(id)sender;

// 添加左侧取消按钮
- (void)yx_setupLeftCancelBarButtonItem;
// 取消按钮事件处理
- (void)yx_leftCancelButtonPressed:(id)sender;

// 添加右侧按钮
- (UIButton *)yx_setupRightButtonItemWithTitle:(NSString *)title
                                         image:(UIImage *)image
                              highLightedImage:(UIImage *)highLightedImage;
// 右侧按钮事件处理，子类实现
- (void)yx_rightButtonPressed:(id)sender;

@end
