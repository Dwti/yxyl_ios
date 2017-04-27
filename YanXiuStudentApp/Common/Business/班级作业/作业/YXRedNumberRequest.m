//
//  YXRedNumberRequest.m
//  YanXiuStudentApp
//
//  Created by 贾培军 on 16/4/7.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXRedNumberRequest.h"

@implementation YXNumberItem

@end

@implementation YXRedNumberItem

@end

@implementation YXRedNumberRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"app/class/getWaitfinishHwknum.do"];
    }
    return self;
}

@end
