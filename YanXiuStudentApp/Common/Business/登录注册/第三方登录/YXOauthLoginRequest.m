//
//  YXOauthLoginRequest.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/9/24.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXOauthLoginRequest.h"

@implementation YXOauthLoginRequestItem

@end

@implementation YXOauthLoginRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].loginServer stringByAppendingString:@"app/user/oauthLogin.do"];
        self.deviceId = [YXConfigManager sharedInstance].deviceID;
    }
    return self;
}

@end
