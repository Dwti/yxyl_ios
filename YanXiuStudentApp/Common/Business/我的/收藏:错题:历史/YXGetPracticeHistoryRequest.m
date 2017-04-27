//
//  YXGetPracticeHistoryRequest.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/15.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXGetPracticeHistoryRequest.h"

@implementation YXGetPracticeHistoryItem_Data

- (BOOL)isFinished
{
    return ([self.status integerValue] == 2);
}

@end

@implementation YXGetPracticeHistoryItem

@end

@implementation YXGetPracticeHistoryRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"app/personalData/getPracticeHistory.do"];
    }
    return self;
}

@end
