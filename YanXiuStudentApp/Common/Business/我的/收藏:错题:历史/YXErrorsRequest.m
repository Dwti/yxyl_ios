//
//  YXErrorsRequest.m
//  YanXiuStudentApp
//
//  Created by 贾培军 on 16/6/17.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXErrorsRequest.h"

@implementation YXErrorsRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.ptype = @"2";
        self.pageSize = @"20";
        self.token = [YXUserManager sharedManager].userModel.passport.token;
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"app/q/getWrongQsV2.do"];
    }
    return self;
}

- (void)dealWithResponseJson:(NSString *)json {
    NSString *decrypt = [YXCrypt decryptForString:json];
    if (!isEmpty(decrypt)) {
        [super dealWithResponseJson:decrypt];
    } else {
        [super dealWithResponseJson:json];
    }
}

@end
