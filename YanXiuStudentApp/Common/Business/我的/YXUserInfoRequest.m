//
//  YXUserInfoRequest.m
//  YanXiuApp
//
//  Created by ChenJianjun on 15/6/5.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXUserInfoRequest.h"

NSString *const YXUserInfoGetSuccessNotification = @"kYXUserInfoGetSuccessNotification";

@implementation YXUserInfoItem

@end

@implementation YXUserInfoRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"app/personalData/getUser.do"];
    }
    return self;
}

@end

@interface YXUserInfoHelper ()

@property (nonatomic, strong) YXUserInfoRequest *request;

@end

@implementation YXUserInfoHelper

- (void)dealloc
{
    [self.request stopRequest];
}

+ (instancetype)sharedHelper
{
    static YXUserInfoHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[self alloc] init];
    });
    return helper;
}

- (void)requestCompeletion:(void(^)())completion
{
    if (self.request) {
        [self.request stopRequest];
    }
    self.request = [[YXUserInfoRequest alloc] init];
    [self.request startRequestWithRetClass:[YXUserInfoItem class] andCompleteBlock:^(id responseObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
            YXUserInfoItem *item = responseObject;
            if (item && item.data.count > 0) {
                YXUserModel *userModel = item.data[0];
                userModel.passport = [YXUserManager sharedManager].userModel.passport;
                [YXUserManager sharedManager].userModel = userModel;
                [[YXUserManager sharedManager] saveUserData];
                [[NSNotificationCenter defaultCenter] postNotificationName:YXUserInfoGetSuccessNotification object:nil];
            }
        });
    }];
}

@end