//
//  YXGetPracticeHistoryByKnowRequest.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/11/3.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXGetPracticeHistoryByKnowRequest.h"

@implementation YXGetPracticeHistoryByKnowRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"app/personalData/getPracticeHistoryByKnow.do"];
    }
    return self;
}

@end
