//
//  YXVerifySMSCodeRequest.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/8.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXVerifySMSCodeRequest.h"

@implementation YXVerifySMSCodeRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].loginServer stringByAppendingString:@"app/user/firstStepCommit.do"];
    }
    return self;
}

@end
