//
//  YXLoadingView.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/12/28.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  加载动画视图
 */
@interface YXLoadingView : UIView

@property (nonatomic, strong) NSString *text;

// 开始加载动画
- (void)startLoading;
// 结束加载动画
- (void)stopLoading;

@end

@interface YXLoadingControl : NSObject

// 开始loading动画
+ (UIView *)startLoadingWithSuperview:(UIView *)superview;
+ (UIView *)startLoadingWithSuperview:(UIView *)superview text:(NSString *)text;
// 停止loading动画
+ (void)stopLoadingWithSuperview:(UIView *)superview;

@end
