//
//  YXCancelReplyClassRequest.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/9/25.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXCancelReplyClassRequest.h"

NSString *const YXCancelReplyClassSuccessNotification = @"kYXCancelReplyClassSuccessNotification";

@implementation YXCancelReplyClassRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"app/class/cancelReply.do"];
    }
    return self;
}

@end
