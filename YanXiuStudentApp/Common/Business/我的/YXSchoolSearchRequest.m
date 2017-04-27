//
//  YXSchoolSearchRequest.m
//  YanXiuApp
//
//  Created by ChenJianjun on 15/6/11.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXSchoolSearchRequest.h"

@implementation YXSchool

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"sid":@"id"}];
}

@end

@implementation YXSchoolSearchItem

@end

@implementation YXSchoolSearchRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"app/personalData/searchSchool.do"];
    }
    return self;
}

@end
