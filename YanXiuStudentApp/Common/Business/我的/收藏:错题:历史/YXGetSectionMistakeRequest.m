//
//  YXGetSectionMistakeRequest.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/15.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXGetSectionMistakeRequest.h"

@implementation YXGetSectionMistakeRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"app/personalData/getSectionMistake.do"];
    }
    return self;
}

@end
