//
//  YXSSOAuthManager.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/9/23.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXSSOAuthManager : NSObject

+ (instancetype)sharedManager;

// 第三方授权
- (void)registerWXApp;
- (void)registerQQApp;

+ (BOOL)isWXAppSupport;

// 第三方登录
- (void)qqLoginWithRootViewController:(UIViewController *)rootViewController;
- (void)weixinLoginWithRootViewController:(UIViewController *)rootViewController;
// 第三方登录时注册回调
@property (nonatomic, copy) void(^thirdRegisterBlock)(UIViewController *rootViewController, NSDictionary *params);

// 回调处理
+ (BOOL)handleOpenURL:(NSURL *)url;

@end

