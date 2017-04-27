//
//  YXUserManager.h
//  YanXiuApp
//
//  Created by ChenJianjun on 15/6/2.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXUserModel.h"

// 获取验证码类型
typedef NS_ENUM(NSInteger, YXLoginVerifyType) {
    YXLoginVerifyTypeRegister,      // 注册
    YXLoginVerifyTypeResetPassword, // 重置密码
};

// 密码操作类型
typedef NS_ENUM(NSInteger, YXPasswordOperationType) {
    YXPasswordOperationTypeFirstSet,
    YXPasswordOperationTypeReset
};

// 用户登录登出成功通知
extern NSString *const YXUserLoginSuccessNotification;
extern NSString *const YXUserLogoutSuccessNotification;

@interface YXUserManager : NSObject

@property (nonatomic, strong) YXUserModel *userModel;

+ (instancetype)sharedManager;

// 用户数据持久化存储方式
- (void)saveUserData;

// 登录成功后存储数据等操作
- (void)login;

// 登出后重置用户数据等操作
- (void)logout;

// 判断是否登录
- (BOOL)isLogin;

// 是否为第三方、游客登录
- (BOOL)isThirdLogin;
- (void)setIsThirdLogin:(BOOL)isThirdLogin;

// 是否为 加入班级进行注册的
- (BOOL)isRegisterByJoinClass;
- (void)setIsRegisterByJoinClass:(BOOL)registerByJoinClass;

@end
