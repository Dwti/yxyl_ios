//
//  LoginDataManager.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2016/12/22.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXLoginRequest.h"
#import "YXResetPasswordRequest.h"
#import "RegisterByUserInfoRequest.h"
#import "YXRegisterRequest.h"
#import "RegisterModel.h"
#import "YXThirdRegisterRequest.h"
#import "ThirdRegisterModel.h"
#import "YXProduceCodeRequest.h"
#import "YXVerifySMSCodeRequest.h"
#import "RegisterAccountRequest.h"
#import "AccountRegisterModel.h"
#import "RegisterByJoinClassRequest.h"
#import "RegisterByJoinClassModel.h"
#import "ThirdRegisterByJoinClassRequest.h"
#import "ThirdRegisterByJoinClassModel.h"
#import "YXModifyPasswordRequest.h"
#import "BindNewMobileRequest.h"
#import "VerifyBindedMobileRequest.h"
#import "YXProduceCodeByBindRequest.h"

extern NSString *const kBindPhoneSuccessNotification;

@interface LoginDataManager : NSObject

// 请求登陆
+ (void)loginWithMobileNumber:(NSString *)mobileNumber
                     password:(NSString *)password
                 isThirdLogin:(BOOL)isThirdLogin
                completeBlock:(void(^)(YXLoginRequestItem *item, NSError *error, BOOL isBind))completeBlock;
//游客登录
+ (void)touristLoginWithCompleteBlock:(void(^)(YXLoginRequestItem *item, NSError *error, BOOL isBind))completeBlock;
//重置密码
+ (void)resetPasswordWithMobileNumber:(NSString *)mobileNumber
                             password:(NSString *)password
                        completeBlock:(void(^)(HttpBaseRequestItem *item, NSError *error))completeBlock;
//注册
+ (void)registerWithModel:(RegisterModel *)registerModel completeBlock:(void(^)(YXRegisterRequestItem *item, NSError *error))completeBlock;
//第三方注册
+ (void)thirdRegisterWithModel:(ThirdRegisterModel *)thirdRegisterModel completeBlock:(void(^)(YXThirdRegisterRequestItem *item, NSError *error))completeBlock;
//发送验证码
+ (void)getVerifyCodeWithMobileNumber:(NSString *)mobileNumber
                           verifyType:(NSString *)verifyType
                        completeBlock:(void(^)(HttpBaseRequestItem *item, NSError *error))completeBlock;
+ (void)getVerifyCodeByBindWithMobileNumber:(NSString *)mobileNumber
                                  verifyType:(NSString *)verifyType
                               completeBlock:(void (^)(HttpBaseRequestItem *, NSError *))completeBlock;
//验证短信验证码
+ (void)verifySMSCodeWithMobileNumber:(NSString *)mobileNumber
                           verifyCode:(NSString *)verifyCode
                             codeType:(NSString *)codeType
                        completeBlock:(void(^)(HttpBaseRequestItem *item, NSError *error))completeBlock;
//注册账号
+ (void)registerAccountWithModel:(AccountRegisterModel *)accountRegisterModel completeBlock:(void(^)(HttpBaseRequestItem *item, NSError *error))completeBlock;
//通过加入班级注册
+ (void)registerByJoinClassWithModel:(RegisterByJoinClassModel *)registerByJoinClassModel completeBlock:(void(^)(RegisterRequestItem *item, NSError *error))completeBlock;
//第三方加入班级注册
+ (void)thirdRegisterByJoinClassWithModel:(ThirdRegisterByJoinClassModel *)thirdRegisterByJoinClassModel completeBlock:(void(^)(ThirdRegisterRequestItem *item, NSError *error))completeBlock;
//修改密码
+ (void)modifyPasswordWithOldPassword:(NSString *)oldPassword
                           newPassword:(NSString *)newPassword
                         completeBlock:(void(^)(YXModifyPasswordItem *item, NSError *error))completeBlock;
// 绑定新的手机号
+ (void)bindNewMobileWithNumber:(NSString *)mobileNumber verifyCode:(NSString *)verifyCode completeBlock:(void (^)(HttpBaseRequestItem *, NSError *))completeBlock;

// 验证已绑定的手机号
+ (void)verifyBindedMobileNumber:(NSString *)mobileNumber verifyCode:(NSString *)verifyCode completeBlock:(void (^)(HttpBaseRequestItem *, NSError *))completeBlock;

@end
