//
//  RegisterAccountRequest.m
//  YanXiuStudentApp
//
//  Created by FanYu on 11/5/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import "RegisterAccountRequest.h"

@implementation RegisterAccountRequest

- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].loginServer stringByAppendingString:@"app/user/firstStepCommitV2.do"];
    }
    return self;
}

@end
