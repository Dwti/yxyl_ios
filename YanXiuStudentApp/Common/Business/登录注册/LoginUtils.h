//
//  LoginUtils.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2016/12/26.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginUtils : NSObject
// 验证手机号位数
+ (void)verifyMobileLength:(NSString *)mobileNumber completeBlock:(void (^)(BOOL, BOOL))completeBlock;
//验证登录账号
+ (void)verifyAccountID:(NSString *)accountID completeBlock:(void (^)(BOOL, BOOL))completeBlock;
//验证手机号
+ (void)verifyMobileNumberFormat:(NSString *)mobileNumber completeBlock:(void(^)(BOOL isEmpty, BOOL formatIsCorrect))completeBlock;
//验证密码
+ (void)verifyPasswordFormat:(NSString *)password completeBlock:(void(^)(BOOL isEmpty, BOOL formatIsCorrect))completeBlock;
//验证验证码
+ (void)verifySMSCodeFormat:(NSString *)SMSCode completeBlock:(void(^)(BOOL isEmpty, BOOL formatIsCorrect))completeBlock;

@end
