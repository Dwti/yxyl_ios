//
//  YXHomeworkListRequest.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/10.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXHomeworkListRequest.h"

@implementation YXHomeworkListItem

@end

@implementation YXHomeworkListRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"app/class/listGroupPaper.do"];
    }
    return self;
}

@end
