//
//  YXHomeworkToDoListRequest.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/10.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXHomeworkToDoListRequest.h"

@implementation YXHomeworkToDoListItem

@end

@implementation YXHomeworkToDoListRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"app/class/listUnfinishPapers.do"];
    }
    return self;
}

@end
