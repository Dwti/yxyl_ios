//
//  YXWeixinSSOManager.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/10/9.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GetRequest.h"

@interface YXWeixinSSOManager : NSObject

+ (instancetype)sharedManager;

- (void)requestOpenIdAndUnionIdWithCode:(NSString *)code
                             completion:(void (^)(NSDictionary *, NSError *))completion;

- (void)requestUserInfoCompletion:(void(^)(NSDictionary *userInfo, NSError *error))completion;

@end

// 返回json
@interface YXWeixinBaseResp : JSONModel

@property (nonatomic, copy) NSString<Optional> *errcode;
@property (nonatomic, copy) NSString<Optional> *errmsg;

@end

@interface YXWeixinAccessTokenResp : YXWeixinBaseResp

@property (nonatomic, copy) NSString<Optional> *access_token;
@property (nonatomic, copy) NSString<Optional> *expires_in;
@property (nonatomic, copy) NSString<Optional> *refresh_token;
@property (nonatomic, copy) NSString<Optional> *openid;
@property (nonatomic, copy) NSString<Optional> *scope;

@end

@interface YXWeixinUserInfoResp : YXWeixinBaseResp

@property (nonatomic, copy) NSString<Optional> *openid;
@property (nonatomic, copy) NSString<Optional> *nickname;
@property (nonatomic, copy) NSString<Optional> *sex;
@property (nonatomic, copy) NSString<Optional> *province;
@property (nonatomic, copy) NSString<Optional> *city;
@property (nonatomic, copy) NSString<Optional> *country;
@property (nonatomic, copy) NSString<Optional> *headimgurl;
@property (nonatomic, copy) NSArray<Optional> *privilege;
@property (nonatomic, copy) NSString<Optional> *unionid;

@end

@interface YXWeixinBaseRequest : GetRequest

@end

// 通过code获取access_token
@interface YXWeixinAccessTokenRequest : YXWeixinBaseRequest

@property (nonatomic, strong) NSString *appid;
@property (nonatomic, strong) NSString *secret;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *grant_type;

@end

// 使用refresh_token刷新access_token
@interface YXWeixinRefreshTokenRequest : YXWeixinBaseRequest

@property (nonatomic, strong) NSString *appid;
@property (nonatomic, strong) NSString *grant_type;
@property (nonatomic, strong) NSString *refresh_token;

@end

// 检验授权凭证（access_token）是否有效
@interface YXWeixinCheckTokenRequest : YXWeixinBaseRequest

@property (nonatomic, strong) NSString *access_token;
@property (nonatomic, strong) NSString *openid;

@end

// 获取用户个人信息
@interface YXWeixinUserInfoRequest : YXWeixinBaseRequest

@property (nonatomic, strong) NSString *access_token;
@property (nonatomic, strong) NSString *openid;

@end
