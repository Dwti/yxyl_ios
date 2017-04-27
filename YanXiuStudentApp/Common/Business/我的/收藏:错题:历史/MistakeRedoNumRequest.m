//
//  MistakeRedoNumRequest.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 3/6/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "MistakeRedoNumRequest.h"

@implementation MistakeRedoNumProterty
@end

@implementation MistakeRedoNumItem
@end

@implementation MistakeRedoNumRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"app/q/getReDoWrongQNum.do"];
    }
    return self;
}
@end
