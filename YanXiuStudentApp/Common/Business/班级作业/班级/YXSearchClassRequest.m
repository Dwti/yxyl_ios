//
//  YXSearchClassRequest.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/10.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXSearchClassRequest.h"

@implementation YXSearchClassItem_Data
- (BOOL)needToVerify {
    if (self.status.integerValue == 0) {
        return  NO;
    }else {
        return YES;
    }
}
- (BOOL)memberIsFull {
    if (self.isMemeberFull.integerValue == 1) {
        return YES;
    }else {
        return NO;
    }
}
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"gid":@"id"}];
}

@end

@implementation YXSearchClassItem

@end

@implementation YXSearchClassRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"app/class/searchClass.do"];
    }
    return self;
}

@end
