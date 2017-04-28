//
//  YXUploadRequest.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/8.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXUploadRequest.h"

@implementation YXUploadRequest

- (instancetype)init
{
    if (self = [super init]) {
        if ([[YXUserManager sharedManager] isLogin]) {
            _token = [YXUserManager sharedManager].userModel.passport.token;
            _trace_uid = [YXUserManager sharedManager].userModel.passport.uid;
        }
    }
    return self;
}


@end
