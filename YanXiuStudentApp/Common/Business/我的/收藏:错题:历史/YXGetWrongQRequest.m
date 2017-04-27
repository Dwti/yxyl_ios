//
//  YXGetWrongQRequest.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/27/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "YXGetWrongQRequest.h"

@implementation YXGetWrongQRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"app/q/getWrongQs.do"];
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
