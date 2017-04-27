//
//  YXMockRequest.m
//  StatisticDemo
//
//  Created by niuzhaowang on 16/5/31.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXStatisticFileRequest.h"
#import "YXGetRequest.h"

@interface YXStatisticFileRequest()


@end

@implementation YXStatisticFileRequest

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"mId":@"id"}];
}

#pragma mark-
- (instancetype)init
{
    if (self = [super init]) {
        self.osType = nil;
        self.version = nil;
        self.token = nil;
        self.urlHead = @"http://boss.shangruitong.com/upfile";
    }
    return self;
}

@end
