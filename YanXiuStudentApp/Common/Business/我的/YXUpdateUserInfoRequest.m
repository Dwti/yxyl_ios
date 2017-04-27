//
//  YXUpdateUserInfoRequest.m
//  YanXiuApp
//
//  Created by ChenJianjun on 15/6/11.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXUpdateUserInfoRequest.h"

@implementation YXUpdateUserInfoRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"app/personalData/updateUserInfo.do"];
    }
    return self;
}

@end
