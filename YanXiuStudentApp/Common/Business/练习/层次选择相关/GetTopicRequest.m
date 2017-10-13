//
//  GetTopicRequest.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/10/18.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "GetTopicRequest.h"

@implementation GetTopicRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"app/topic/getTopic.do"];
    }
    return self;
}
@end
