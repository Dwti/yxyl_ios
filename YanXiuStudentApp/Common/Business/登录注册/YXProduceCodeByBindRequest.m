//
//  YXProduceCodeByBindRequest.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 17/04/2017.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "YXProduceCodeByBindRequest.h"

@implementation YXProduceCodeByBindRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].loginServer stringByAppendingString:@"app/user/produceCodeByBind.do"];
    }
    return self;
}

@end
