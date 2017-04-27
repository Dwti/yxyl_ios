//
//  YXUserModel.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/16.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXUserModel.h"

@implementation YXUserPassport

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"pid":@"id"}];
}

@end

@implementation YXUserModel

- (void)setUid:(NSString<Optional> *)uid
{
    _uid = uid;
    //[[YXAppStartupManager sharedInstance] resetAPNSWithAccount:uid];
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"uid":@"id"}];
}

@end
