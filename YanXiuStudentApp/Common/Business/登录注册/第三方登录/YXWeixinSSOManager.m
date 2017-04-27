//
//  YXWeixinSSOManager.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/10/9.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXWeixinSSOManager.h"
#import "YXSSOAuthDefine.h"

@interface YXWeixinSSOManager ()

@property (nonatomic, strong) YXWeixinAccessTokenResp *accessTokenResp;
@property (nonatomic, strong) YXWeixinAccessTokenRequest *accessTokenRequest;
@property (nonatomic, strong) YXWeixinRefreshTokenRequest *refreshTokenRequest;
@property (nonatomic, strong) YXWeixinCheckTokenRequest *checkTokenRequest;
@property (nonatomic, strong) YXWeixinUserInfoRequest *userInfoRequest;

@end

@implementation YXWeixinSSOManager

+ (instancetype)sharedManager
{
    static YXWeixinSSOManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[YXWeixinSSOManager alloc] init];
    });
    return sharedManager;
}

- (void)requestOpenIdAndUnionIdWithCode:(NSString *)code
                    completion:(void (^)(NSDictionary *, NSError *))completion
{
    [self.accessTokenRequest stopRequest];
    self.accessTokenRequest = [[YXWeixinAccessTokenRequest alloc] init];
    self.accessTokenRequest.appid = [YXConfigManager sharedInstance].YXSSOAuthWeixinAppid;
    self.accessTokenRequest.secret = [YXConfigManager sharedInstance].YXSSOAuthWeixinAppSecret;
    self.accessTokenRequest.code = code;
    @weakify(self);
    [self.accessTokenRequest startRequestWithRetClass:[YXWeixinAccessTokenResp class] andCompleteBlock:^(id retItem, NSError *error) {
        @strongify(self);
        //在这里获取unionId
        if (retItem && !error) {
            self.accessTokenResp = retItem;
            [self.userInfoRequest stopRequest];
            self.userInfoRequest = [[YXWeixinUserInfoRequest alloc] init];
            self.userInfoRequest.access_token = self.accessTokenResp.access_token;
            self.userInfoRequest.openid = self.accessTokenResp.openid;
            [self.userInfoRequest startRequestWithRetClass:[YXWeixinUserInfoResp class] andCompleteBlock:^(id retItem, NSError *error) {
                YXWeixinUserInfoResp *resp = retItem;
                if (resp && !error) {
                    NSMutableDictionary *dict = [NSMutableDictionary new];
                    [dict putValue:resp.unionid forKey:YXSSOAuthUnionKey];
                    [dict putValue:resp.openid forKey:YXSSOAuthOpenidKey];
                    if (completion) {
                        completion(dict, error);
                    }
                }
            }];
        }
    }];
}

- (void)requestUserInfoCompletion:(void (^)(NSDictionary *, NSError *))completion
{
    [self checkAccessTokenRequest:completion];
}

#pragma mark -

- (void)checkAccessTokenRequest:(void (^)(NSDictionary *, NSError *))completion
{
    [self.checkTokenRequest stopRequest];
    self.checkTokenRequest = [[YXWeixinCheckTokenRequest alloc] init];
    self.checkTokenRequest.access_token = self.accessTokenResp.access_token;
    self.checkTokenRequest.openid = self.accessTokenResp.openid;
    @weakify(self);
    [self.checkTokenRequest startRequestWithRetClass:[YXWeixinBaseResp class] andCompleteBlock:^(id retItem, NSError *error) {
        @strongify(self);
        if (retItem && !error) {
            [self userInfoRequest:completion];
        } else {
            [self refreshTokenRequest:completion];
        }
    }];
}

- (void)userInfoRequest:(void (^)(NSDictionary *, NSError *))completion
{
    [self.userInfoRequest stopRequest];
    self.userInfoRequest = [[YXWeixinUserInfoRequest alloc] init];
    self.userInfoRequest.access_token = self.accessTokenResp.access_token;
    self.userInfoRequest.openid = self.accessTokenResp.openid;
    @weakify(self);
    [self.userInfoRequest startRequestWithRetClass:[YXWeixinUserInfoResp class] andCompleteBlock:^(id retItem, NSError *error) {
        @strongify(self);
        NSDictionary *userInfo = @{YXSSOAuthOpenidKey:self.accessTokenResp.openid, YXSSOAuthPltformKey:YXSSOAuthPltformWeixin};
        YXWeixinUserInfoResp *resp = retItem;
        if (resp && !error) {
            userInfo = @{YXSSOAuthOpenidKey: resp.openid,
                         YXSSOAuthUnionKey:resp.unionid,
                         YXSSOAuthPltformKey: YXSSOAuthPltformWeixin,
                         YXSSOAuthNicknameKey: (resp.nickname ?:@""),
                         YXSSOAuthSexKey: [YXSSOAuthDefine sexWithWeixinSex:resp.sex],
                         YXSSOAuthHeadimgKey: (resp.headimgurl ?:@"")
                         };
        }
        if (completion) {
            completion(userInfo, error);
        }
    }];
}

- (void)refreshTokenRequest:(void (^)(NSDictionary *, NSError *))completion
{
    [self.refreshTokenRequest stopRequest];
    self.refreshTokenRequest = [[YXWeixinRefreshTokenRequest alloc] init];
    self.refreshTokenRequest.appid = [YXConfigManager sharedInstance].YXSSOAuthWeixinAppid;
    self.refreshTokenRequest.refresh_token = self.accessTokenResp.refresh_token;
    @weakify(self);
    [self.refreshTokenRequest startRequestWithRetClass:[YXWeixinAccessTokenResp class] andCompleteBlock:^(id retItem, NSError *error) {
        @strongify(self);
        if (retItem && !error) {
            self.accessTokenResp = retItem;
            [self userInfoRequest:completion];
        } else {
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

@end

@implementation YXWeixinBaseResp

@end

@implementation YXWeixinAccessTokenResp

@end

@implementation YXWeixinUserInfoResp

@end

@implementation YXWeixinBaseRequest

- (void)dealWithResponseJson:(NSString *)json
{
    // 解码对象不存在，直接返回json数据
    if (!_retClass || ![_retClass isSubclassOfClass:[JSONModel class]]) {
        _completeBlock(json, nil);
        return;
    }
    
    NSError *error = nil;
    YXWeixinBaseResp *item = [[_retClass alloc] initWithString:json error:&error];
    // json格式错误
    if (error) {
        error = [NSError errorWithDomain:error.domain code:-1 userInfo:@{NSLocalizedDescriptionKey:@"数据加载失败"}];
        _completeBlock(nil, error);
        return;
    }
    
    // 业务逻辑错误
    if (item.errcode.integerValue != 0) {
        error = [NSError errorWithDomain:@"network" code:item.errcode.integerValue userInfo:@{NSLocalizedDescriptionKey: item.errmsg ?:@"请求失败"}];
        _completeBlock(item, error);
        return;
    }
    
    // 正常数据
    _completeBlock(item, nil);
}

@end

@implementation YXWeixinAccessTokenRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = @"https://api.weixin.qq.com/sns/oauth2/access_token";
        self.grant_type = @"authorization_code";
    }
    return self;
}

@end

@implementation YXWeixinRefreshTokenRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = @"https://api.weixin.qq.com/sns/oauth2/refresh_token";
        self.grant_type = @"refresh_token";
    }
    return self;
}

@end

@implementation YXWeixinCheckTokenRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = @"https://api.weixin.qq.com/sns/auth";
    }
    return self;
}

@end

@implementation YXWeixinUserInfoRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = @"https://api.weixin.qq.com/sns/userinfo";
    }
    return self;
}

@end