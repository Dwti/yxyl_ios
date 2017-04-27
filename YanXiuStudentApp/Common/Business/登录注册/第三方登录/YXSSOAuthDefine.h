//
//  YXSSOAuthDefine.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/10/9.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 第三方登录

//extern NSString *const YXSSOAuthQQAppid;
//extern NSString *const YXSSOAuthQQAppKey;
//extern NSString *const YXSSOAuthWeixinAppid;
//extern NSString *const YXSSOAuthWeixinAppSecret;

#pragma mark - key

extern NSString *const YXSSOAuthOpenidKey;
extern NSString *const YXSSOAuthPltformKey;
extern NSString *const YXSSOAuthNicknameKey;
extern NSString *const YXSSOAuthSexKey;
extern NSString *const YXSSOAuthHeadimgKey;
extern NSString *const YXSSOAuthUnionKey;

#pragma mark - value

// 平台
extern NSString *const YXSSOAuthPltformQQ;
extern NSString *const YXSSOAuthPltformWeixin;

// 性别
extern NSString *const YXSSOAuthSexUnknown;
extern NSString *const YXSSOAuthSexWoman;
extern NSString *const YXSSOAuthSexMan;

@interface YXSSOAuthDefine : NSObject

// 性别类型匹配
+ (NSString *)sexWithQQSex:(NSString *)qqSex;
+ (NSString *)sexWithWeixinSex:(NSString *)weixinSex;

@end
