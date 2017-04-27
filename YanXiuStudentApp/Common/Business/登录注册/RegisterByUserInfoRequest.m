//
//  RegisterByUserInfoRequest.m
//  YanXiuStudentApp
//
//  Created by FanYu on 11/5/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import "RegisterByUserInfoRequest.h"

@implementation RegisterByUserInfoRequest

- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].loginServer stringByAppendingString:@"app/user/registerV2.do"];
        self.deviceId = [YXConfigManager sharedInstance].deviceID;
    }
    return self;
}

@end
