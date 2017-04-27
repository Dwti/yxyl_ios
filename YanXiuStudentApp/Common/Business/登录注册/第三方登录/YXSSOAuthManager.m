//
//  YXSSOAuthManager.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/9/23.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXSSOAuthManager.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "YXOauthLoginRequest.h"
#import "YXSSOAuthDefine.h"
#import "YXWeixinSSOManager.h"

@interface YXSSOAuthManager ()<WXApiDelegate, TencentSessionDelegate>

@property (nonatomic, strong) TencentOAuth *oauth;
@property (nonatomic, strong) YXOauthLoginRequest *oauthLoginRequest;
@property (nonatomic, strong) UIViewController *rootViewController;

@end

@implementation YXSSOAuthManager

+ (instancetype)sharedManager
{
    static YXSSOAuthManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[YXSSOAuthManager alloc] init];
    });
    return sharedManager;
}

- (void)registerWXApp
{
    [WXApi registerApp:[YXConfigManager sharedInstance].YXSSOAuthWeixinAppid];
}

- (void)registerQQApp
{
    self.oauth = [[TencentOAuth alloc] initWithAppId:[YXConfigManager sharedInstance].YXSSOAuthQQAppid andDelegate:self];
}

+ (BOOL)isWXAppSupport
{
    return [WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi];
}

- (void)qqLoginWithRootViewController:(UIViewController *)rootViewController {
    self.rootViewController = rootViewController;
    NSArray *permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            nil];
    [self.oauth authorize:permissions inSafari:NO];
}

- (void)weixinLoginWithRootViewController:(UIViewController *)rootViewController {
    self.rootViewController = rootViewController;
    if ([WXApi isWXAppInstalled]) {
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo,snsapi_base";
        req.state = @"com.yanxiu.account.wxapi";
        [WXApi sendReq:req];
    } else {
        [self.rootViewController yx_showToast:@"尚未安装微信客户端"];
    }
}

+ (BOOL)handleOpenURL:(NSURL *)url
{
    if ([TencentOAuth CanHandleOpenURL:url]) {
        return [TencentOAuth HandleOpenURL:url];
    }
    return [WXApi handleOpenURL:url delegate:[YXSSOAuthManager sharedManager]];
}

#pragma mark -

// 第三方登录
- (void)oauthLoginRequest:(NSDictionary *)params
{
    if (self.oauthLoginRequest) {
        [self.oauthLoginRequest stopRequest];
    }
    self.oauthLoginRequest = [[YXOauthLoginRequest alloc] init];
    self.oauthLoginRequest.openid = [params objectForKey:YXSSOAuthOpenidKey];
    self.oauthLoginRequest.platform = [params objectForKey:YXSSOAuthPltformKey];
    self.oauthLoginRequest.unionId = [params objectForKey:YXSSOAuthUnionKey];
    @weakify(self);
    [self.rootViewController yx_startLoading];
    [self.oauthLoginRequest startRequestWithRetClass:[YXOauthLoginRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        @strongify(self);
        [self.rootViewController yx_stopLoading];
        YXOauthLoginRequestItem *item = retItem;
        if (item.data.count > 0 && !error) {
            [self.rootViewController yx_showToast:@"登录成功"];
            [self.rootViewController.view endEditing:YES];
            [self saveUserDataWithUserModel:item.data[0]];
        } else {
            if ([item.status.code integerValue] == 80) {
                [self getUserInfoToRequest:params];
            } else {
                [self.rootViewController yx_showToast:error.localizedDescription];
            }
        }
    }];
}

- (void)saveUserDataWithUserModel:(YXUserModel *)model
{
    [YXUserManager sharedManager].userModel = model;
    [[YXUserManager sharedManager] setIsThirdLogin:YES];
    [[YXUserManager sharedManager] setIsRegisterByJoinClass:NO];
    [[YXUserManager sharedManager] login];
}

- (void)getUserInfoToRequest:(NSDictionary *)params
{
    if ([[params objectForKey:YXSSOAuthPltformKey] isEqualToString:YXSSOAuthPltformQQ]) {
        [self.rootViewController yx_startLoading];
        [self.oauth getUserInfo];
    } else if ([[params objectForKey:YXSSOAuthPltformKey] isEqualToString:YXSSOAuthPltformWeixin]) {
        @weakify(self);
        [self.rootViewController yx_startLoading];
        [[YXWeixinSSOManager sharedManager] requestUserInfoCompletion:^(NSDictionary *userInfo, NSError *error) {
            @strongify(self);
            [self.rootViewController yx_stopLoading];
            NSDictionary *dict = params;
            if (userInfo.count > 0 && !error) {
                dict = userInfo;
            }
            [self thirdRegisterRequest:dict];
        }];
    }
}

- (void)thirdRegisterRequest:(NSDictionary *)params
{
    if (self.thirdRegisterBlock) {
        self.thirdRegisterBlock(self.rootViewController, params);
    }
}

- (void)requestWeixinOpenIDWithCode:(NSString *)code
{
    @weakify(self);
    [self.rootViewController yx_startLoading];
    [[YXWeixinSSOManager sharedManager] requestOpenIdAndUnionIdWithCode:code completion:^(NSDictionary *dict, NSError *error) {
        @strongify(self);
        [self.rootViewController yx_stopLoading];
        if (dict && !error) {
            NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:dict];
            [result putValue:YXSSOAuthPltformWeixin forKey:YXSSOAuthPltformKey];
            [self oauthLoginRequest:result];
        } else {
            [self.rootViewController yx_showToast:@"微信登录失败"];
        }
    }];
}

#pragma mark - WXApiDelegate

- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *respAuth = (SendAuthResp *)resp;
        if (respAuth.errCode == WXSuccess) {
            [self requestWeixinOpenIDWithCode:respAuth.code];
        } else {
            [self.rootViewController yx_showToast:@"微信登录失败"];
        }
    }
}

#pragma mark - TencentSessionDelegate

- (void)tencentDidLogin
{
    [self oauthLoginRequest:@{YXSSOAuthOpenidKey:self.oauth.openId?:@"", YXSSOAuthPltformKey:YXSSOAuthPltformQQ}];
}

- (void)tencentDidNotLogin:(BOOL)cancelled
{
    [self.rootViewController yx_showToast:@"QQ登录失败"];
}

- (void)tencentDidNotNetWork
{
    [self.rootViewController yx_showToast:@"QQ登录失败"];
}

- (void)getUserInfoResponse:(APIResponse *)response
{
    [self.rootViewController yx_stopLoading];
    NSDictionary *dict = @{YXSSOAuthOpenidKey:self.oauth.openId,
                           YXSSOAuthPltformKey:YXSSOAuthPltformQQ};
    if (response.jsonResponse.count > 0) {
        dict = @{YXSSOAuthOpenidKey:self.oauth.openId,
                 YXSSOAuthPltformKey:YXSSOAuthPltformQQ,
                 YXSSOAuthNicknameKey:([response.jsonResponse objectForKey:@"nickname"]?:@""),
                 YXSSOAuthSexKey:[YXSSOAuthDefine sexWithQQSex:[response.jsonResponse objectForKey:@"gender"]],
                 YXSSOAuthHeadimgKey:([response.jsonResponse objectForKey:@"figureurl_qq_2"]?:@"")};
    }
    [self thirdRegisterRequest:dict];
}

@end
