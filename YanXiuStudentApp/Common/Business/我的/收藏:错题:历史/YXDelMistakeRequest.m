//
//  YXDelMistakeRequest.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/15.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXDelMistakeRequest.h"

@implementation YXDelMistakeRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"app/personalData/delMistake.do"];
    }
    return self;
}

@end
