//
//  YXGenKnpointQBlockRequest.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/11/2.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXGenKnpointQBlockRequest.h"

@implementation YXGenKnpointQBlockRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"app/q/genKnpointQBlockNew.do"];
    }
    return self;
}

- (void)dealWithResponseJson:(NSString *)json
{
    NSString *decrypt = [YXCrypt decryptForString:json];
    if (!isEmpty(decrypt)) {
        [super dealWithResponseJson:decrypt];
    } else {
        [super dealWithResponseJson:json];
    }
}

@end
