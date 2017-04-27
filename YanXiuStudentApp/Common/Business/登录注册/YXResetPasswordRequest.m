//
//  YXResetPasswordRequest.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/8.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXResetPasswordRequest.h"

@implementation YXResetPasswordRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].loginServer stringByAppendingString:@"app/user/resetPassword.do"];
    }
    return self;
}

@end
