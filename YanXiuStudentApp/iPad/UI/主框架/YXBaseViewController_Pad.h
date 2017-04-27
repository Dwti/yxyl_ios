//
//  YXBaseViewController_Pad.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/25.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXBaseViewController_Pad : UIViewController

/**
 *  设置导航右端图片
 *
 *  @param imageName          普通状态图片
 *  @param highlightImageName 高亮状态图片
 */
- (void)setupRightWithImageNamed:(NSString *)imageName highlightImageNamed:(NSString *)highlightImageName;

/**
 *  点击右端图片的事件响应，子类需要自己实现
 */
- (void)naviRightAction;

/**
 *  设置导航右端为自定义view
 *
 *  @param view 自定义view
 */
- (void)setupRightWithCustomView:(UIView *)view;

/**
 *  设置导航左端图片
 *
 *  @param imageName          普通状态图片
 *  @param highlightImageName 高亮状态图片
 */
- (void)setupLeftWithImageNamed:(NSString *)imageName highlightImageNamed:(NSString *)highlightImageName;

- (void)naviLeftAction;

- (void)startLoading;
- (void)stopLoading;
@end
