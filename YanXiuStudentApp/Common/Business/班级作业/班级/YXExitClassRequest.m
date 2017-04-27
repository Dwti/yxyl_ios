//
//  YXExitClassRequest.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/10.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXExitClassRequest.h"

NSString *const YXExitClassSuccessNotification = @"kYXExitClassSuccessNotification";

@implementation YXExitClassRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"app/class/exitClass.do"];
    }
    return self;
}

@end
