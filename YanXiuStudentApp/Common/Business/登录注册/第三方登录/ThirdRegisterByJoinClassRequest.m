//
//  ThirdRegisterByJoinClassRequest.m
//  YanXiuStudentApp
//
//  Created by FanYu on 11/5/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import "ThirdRegisterByJoinClassRequest.h"


@implementation ThirdRegisterRequestItem

@end


@implementation ThirdRegisterByJoinClassRequest

- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].loginServer stringByAppendingString:@"app/user/thirdRegisterByJoinClass.do"];
        self.deviceId = [YXConfigManager sharedInstance].deviceID;
    }
    return self;
}

@end
