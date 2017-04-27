//
//  YXGetQuestionReportRequest.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/11.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXGetQuestionReportRequest.h"

@implementation YXGetQuestionReportRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"app/q/getQReport.do"];
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
