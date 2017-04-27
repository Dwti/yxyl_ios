//
//  RegisterByJoinClassRequest.m
//  YanXiuStudentApp
//
//  Created by FanYu on 11/5/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import "RegisterByJoinClassRequest.h"


@implementation RegisterRequestItem

@end


@implementation RegisterByJoinClassRequest

- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].loginServer stringByAppendingString:@"app/user/registerByJoinClass.do"];
        self.deviceId = [YXConfigManager sharedInstance].deviceID;
    }
    return self;
}

@end
