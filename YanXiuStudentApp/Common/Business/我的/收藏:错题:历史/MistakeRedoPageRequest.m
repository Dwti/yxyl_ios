//
//  MistakeRedoPageRequest.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/3/6.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "MistakeRedoPageRequest.h"

@implementation MistakeRedoPageRequest
- (instancetype)init
{
    if (self = [super init]) {
        self.pageSize = @"10";
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"app/q/getReDoWrongQs.do"];
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
