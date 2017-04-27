//
//  YXRankRequest.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/9/23.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXRankRequest.h"

@implementation YXRankRequestItem_property

@end

@implementation YXRankRequestItem_data

@end

@implementation YXRankRequestItem

@end

@implementation YXRankRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"app/q/weekRank.do"];
    }
    return self;
}

@end
