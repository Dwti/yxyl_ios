//
//  YXFeedbackRequest.m
//  YanXiuStudentApp
//
//  Created by wd on 15/11/9.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXFeedbackRequest.h"

@implementation YXFeedbackRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"app/common/feedback.do"];
        self.os = [YXConfigManager sharedInstance].osType;
        self.osversion = [YXConfigManager sharedInstance].osVersion;
        self.version = [YXConfigManager sharedInstance].clientVersion;
        self.brand = [YXConfigManager sharedInstance].deviceType;
    }
    return self;
}

@end
