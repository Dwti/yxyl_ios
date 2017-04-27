//
//  MistakeListByQIDsRequest.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 3/31/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "MistakeListByQIDsRequest.h"

@implementation MistakeListByQIDsRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"app/q/getWrongQByQids.do"];
    }
    return self;
}
@end
