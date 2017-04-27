//
//  YXConfigManager.h
//  YanXiuApp
//
//  Created by Lei Cai on 5/15/15.
//  Copyright (c) 2015 yanxiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>

@interface YXConfigManager : JSONModel

+ (YXConfigManager *)sharedInstance;

@property (nonatomic, strong) NSString<Optional> *server;      // 切换正式、测试环境 Url Header
@property (nonatomic, strong) NSString<Optional> *loginServer; // 登录接口url header
@property (nonatomic, strong) NSString<Optional> *channel;     // 渠道
@property (nonatomic, strong) NSString<Optional> *uploadServer;
@property (nonatomic, strong) NSString<Optional> *phonepad; // 区分是iphone还是ipad
@property (nonatomic, strong) NSString<Optional> *initializeUrl;
@property (nonatomic, strong) NSString<Optional> *mode;

#pragma mark - network

@property (nonatomic, strong) NSString<Ignore> *appName;
@property (nonatomic, strong) NSString<Ignore> *clientVersion;

@property (nonatomic, strong) NSString<Ignore> *deviceID;
@property (nonatomic, strong) NSString<Ignore> *deviceType;

@property (nonatomic, strong) NSString<Ignore> *osType;
@property (nonatomic, strong) NSString<Ignore> *osVersion;
@property (nonatomic, strong) NSString<Ignore> *deviceName;

#pragma mark - 腾讯云 & 信鸽
@property (nonatomic, strong) NSString<Optional> *MTAKey;

@property (nonatomic, strong) NSNumber<Optional> *XGPushID;
@property (nonatomic, strong) NSString<Optional> *XGPushKey;

#pragma mark - 三方登录
@property (nonatomic, strong) NSString<Optional> *YXSSOAuthQQAppid;
@property (nonatomic, strong) NSString<Optional> *YXSSOAuthQQAppKey;
@property (nonatomic, strong) NSString<Optional> *YXSSOAuthWeixinAppid;
@property (nonatomic, strong) NSString<Optional> *YXSSOAuthWeixinAppSecret;

#pragma mark - TalkingData
@property (nonatomic, strong) NSString<Optional> *TalkingDataAppID;

#pragma mark - 个推
@property (nonatomic, strong) NSString<Optional> *GeTuiAppId_Dev;
@property (nonatomic, strong) NSString<Optional> *GeTuiAppKey_Dev;
@property (nonatomic, strong) NSString<Optional> *GeTuiAppSecret_Dev;

@property (nonatomic, strong) NSString<Optional> *GeTuiAppId_Rel;
@property (nonatomic, strong) NSString<Optional> *GeTuiAppKey_Rel;
@property (nonatomic, strong) NSString<Optional> *GeTuiAppSecret_Rel;


@end
