//
//  YXQAErrorReportRequest.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/8/11.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXQAErrorReportRequest.h"

@implementation YXQAErrorReportRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"internal/feedback.do"];
    }
    return self;
}

@end
