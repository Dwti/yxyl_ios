//
//  AppDelegateHelper.h
//  AppDelegateTest
//
//  Created by niuzhaowang on 2016/9/26.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YXApnsContentModel.h"

@interface AppDelegateHelper : NSObject

- (instancetype)initWithWindow:(UIWindow *)window;
@property (nonatomic, strong, readonly) UIWindow *window;

// 启动的根视图控制器
- (UIViewController *)rootViewController;

// 登录成功/失败的UI处理
- (void)handleLoginSuccess;
- (void)handleLogoutSuccess;

// 推送消息的UI处理
- (void)apnsGoHomeworkList:(YXApnsContentModel *)model;
- (void)apnsGoHomework:(YXApnsContentModel *)model;

// 学段改变的UI处理
- (void)handleStageChange;

@end
