//
//  YXGetSectionQBlockRequest.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/7/21.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXGetSectionQBlockRequest.h"

@implementation YXGetSectionQBlockRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"app/q/genSectionQBlock.do"];
//        self.type_id = @"5";
//        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"internal/testQuestion.do"];
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
