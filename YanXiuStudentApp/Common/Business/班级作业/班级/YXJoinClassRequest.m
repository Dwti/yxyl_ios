//
//  YXJoinClassRequest.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/10.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXJoinClassRequest.h"

NSString *const YXJoinClassSuccessNotification = @"kYXJoinHomeworkGroupSuccessNotification";

@implementation YXJoinClassRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"app/class/joinClass.do"];
    }
    return self;
}

@end
