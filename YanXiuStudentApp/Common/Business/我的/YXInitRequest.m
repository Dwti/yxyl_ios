//
//  YXInitRequest.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/8/10.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXInitRequest.h"
#import "NSString+YXString.h"
#import "UpdateAppPromptView.h"

NSString *const YXInitSuccessNotification = @"kYXInitSuccessNotification";

@implementation YXInitRequestItem_Property

@end

@implementation YXInitRequestItem_Body

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"iid":@"id"}];
}

- (BOOL)isTest
{
    if ([self.targetenv isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}

- (BOOL)isForce
{
    if ([self.upgradetype isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}

@end

@implementation YXInitRequestItem

@end

@implementation YXInitRequest

- (id)init
{
    self = [super init];
    if (self) {
        self.token = nil;
        _productLine = @"1";
        _did = [YXConfigManager sharedInstance].deviceID;
        _brand = [YXConfigManager sharedInstance].deviceType;
        [self setCurrentNetType];
        
        _osModel = @"ios";
        _osVer = [UIDevice currentDevice].systemVersion;
        _appVersion = [YXConfigManager sharedInstance].clientVersion;
        _content = @"";
        _operType = @"app.upload.log";
        _phone = [YXUserManager sharedManager].userModel.mobile? :@"";
        _remoteIp = @"";
        _mode = [YXConfigManager sharedInstance].mode;
        _debugtoken = @"";
        self.urlHead = [YXConfigManager sharedInstance].initializeUrl;
    }

    return self;
}

- (void)setCurrentNetType
{
    Reachability *r = [Reachability reachabilityForInternetConnection];
    switch ([r currentReachabilityStatus]) {
        case ReachableViaWiFi:
            _nettype = @"1";
            break;
        case ReachableViaWWAN:
            _nettype = @"0";
            break;
        case NotReachable:
        default:
            break;
    }
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"osModel":@"os"}];
}

@end


@interface YXInitHelper ()

@property (nonatomic, strong) YXInitRequest *request;
@property (nonatomic, strong) YXInitRequestItem *item;

@end

@interface YXInitHelper()
@property (nonatomic, strong) AlertView *alertView;
@property (nonatomic, strong) UpdateAppPromptView *promptView;
@property (nonatomic, strong) YXInitRequestItem_Body *body;
@end

@implementation YXInitHelper

- (void)dealloc
{
    [self.request stopRequest];
}

+ (instancetype)sharedHelper
{
    static YXInitHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[self alloc] init];
        [helper registerNotifications];
    });
    return helper;
}

- (void)requestCompeletion:(void(^)())completion
{
    if (self.request) {
        [self.request stopRequest];
    }
    self.request = [[YXInitRequest alloc] init];
    [self.request startRequestWithRetClass:[YXInitRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
            self.item = retItem;
            [self saveAppleCheckingStatusToLocal];
            [self showUpgradeForInit:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:YXInitSuccessNotification object:nil];
        });
    }];
}

// 审核状态，默认返回YES
- (BOOL)isAppleChecking
{
    id isChecking = [[NSUserDefaults standardUserDefaults] objectForKey:@"isAppleChecking"];
    if (isChecking) {
        return [isChecking boolValue];
    }
    return YES;
}

#pragma mark -

- (void)registerNotifications
{
    [self removeNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)willEnterForeground:(NSNotification *)notification
{
    [self showUpgradeForInit:NO];
}

- (void)showUpgradeForInit:(BOOL)isInit
{
    if (!self.item || self.item.data.count <= 0) {
        return;
    }
    
    self.body = self.item.data[0];
    
    if ([self.body isTest]) { //测试环境
#ifndef DEBUG
        return;
#endif
    }
    if (![self.body isForce] && !isInit) { //非强制升级只在初始化弹出一次
        return;
    }
    if (![self.body.fileURL yx_isHttpLink]) { //http链接
        return;
    }
    
    self.alertView = [[AlertView alloc] init];
    
    self.promptView = [[UpdateAppPromptView alloc] init];
    self.promptView.body = self.body;
    
    WEAK_SELF
    [self.promptView setCancelAction:^{
        STRONG_SELF
        [self.alertView hide];
        if ([self.body isForce]) {
            exit(0);
        }
    }];
    
    [self.promptView setUpdateAction:^{
        STRONG_SELF
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.body.fileURL]];

    }];
    
    self.alertView.contentView = self.promptView;
    [self.alertView showWithLayout:^(AlertView *view) {
        [view.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(85*kPhoneHeightRatio);
            make.centerX.mas_equalTo(0);
        }];
        [view layoutIfNeeded];
    }];
}

#pragma mark -
- (void)saveAppleCheckingStatusToLocal
{
    // 网络请求返回成功，isAppleChecking存在时保存到本地
    NSString *isAppleChecking = self.item.property.isAppleChecking;
    if ([isAppleChecking yx_isValidString]) {
        [[NSUserDefaults standardUserDefaults] setObject:isAppleChecking forKey:@"isAppleChecking"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
