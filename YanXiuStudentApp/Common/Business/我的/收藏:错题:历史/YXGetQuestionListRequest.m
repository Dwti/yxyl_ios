//
//  YXGetQuestionListRequest.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/15.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXGetQuestionListRequest.h"

@implementation YXGetQuestionListRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"app/personalData/getQuestionList.do"];
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
