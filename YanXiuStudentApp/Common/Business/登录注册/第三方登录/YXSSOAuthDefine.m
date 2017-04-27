//
//  YXSSOAuthDefine.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/10/9.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXSSOAuthDefine.h"

//NSString *const YXSSOAuthQQAppid = @"1104826608";
//NSString *const YXSSOAuthQQAppKey = @"PsLMILpDwU6QDNOk";
//NSString *const YXSSOAuthWeixinAppid = @"wxb6704ac52abcfe4c";
//NSString *const YXSSOAuthWeixinAppSecret = @"943d690bd5020ae629c20281e53bc334";

NSString *const YXSSOAuthOpenidKey = @"openid";
NSString *const YXSSOAuthPltformKey = @"pltform";
NSString *const YXSSOAuthNicknameKey = @"nickname";
NSString *const YXSSOAuthSexKey = @"sex";
NSString *const YXSSOAuthUnionKey = @"unionid";
NSString *const YXSSOAuthHeadimgKey = @"headimg";

NSString *const YXSSOAuthPltformQQ = @"qq";
NSString *const YXSSOAuthPltformWeixin = @"weixin";

NSString *const YXSSOAuthSexUnknown = @"0";
NSString *const YXSSOAuthSexWoman = @"1";
NSString *const YXSSOAuthSexMan = @"2";

@implementation YXSSOAuthDefine

// qq：男、女
+ (NSString *)sexWithQQSex:(NSString *)qqSex
{
    if ([qqSex isEqualToString:@"男"]) {
        return YXSSOAuthSexMan;
    } else if ([qqSex isEqualToString:@"女"]) {
        return YXSSOAuthSexWoman;
    } else {
        return YXSSOAuthSexUnknown;
    }
}

// 微信：1为男性，2为女性
+ (NSString *)sexWithWeixinSex:(NSString *)weixinSex
{
    if ([weixinSex isEqualToString:@"1"]) {
        return YXSSOAuthSexMan;
    } else if ([weixinSex isEqualToString:@"2"]) {
        return YXSSOAuthSexWoman;
    } else {
        return YXSSOAuthSexUnknown;
    }
}

@end
