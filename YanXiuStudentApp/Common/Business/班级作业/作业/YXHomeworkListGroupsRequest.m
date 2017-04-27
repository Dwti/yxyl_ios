//
//  YXHomeworkListGroupsRequest.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/15.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXHomeworkListGroupsRequest.h"

@implementation YXHomeworkListGroupsItem_Data

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"groupId": @"id"}];
}

@end

@implementation YXHomeworkListGroupsItem_Property
@end

@implementation YXHomeworkListGroupsItem
@end



@implementation YXHomeworkListGroupsRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"app/class/listGroups.do"];
    }
    return self;
}

@end
