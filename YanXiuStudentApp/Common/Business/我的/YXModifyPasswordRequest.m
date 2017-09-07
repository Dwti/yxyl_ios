//
//  YXModifyPasswordRequest.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/17.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXModifyPasswordRequest.h"

@implementation YXModifyPasswordItem

@end

@implementation YXModifyPasswordRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].loginServer stringByAppendingString:@"app/user/modifyPasswordNew.do"];
    }
    return self;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"myNewPass":@"newPass"}];
}

@end
