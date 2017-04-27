//
//  YXRegisterRequest.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/8.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXRegisterRequest.h"

@implementation YXRegisterRequestItem

@end

@implementation YXRegisterRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].loginServer stringByAppendingString:@"app/user/register.do"];
        self.deviceId = [YXConfigManager sharedInstance].deviceID;
    }
    return self;
}

@end
