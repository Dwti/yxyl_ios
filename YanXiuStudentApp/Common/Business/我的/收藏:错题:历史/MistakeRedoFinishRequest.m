//
//  MistakeRedoFinishRequest.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/3/6.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "MistakeRedoFinishRequest.h"

@implementation MistakeRedoFinishRequest
- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"app/q/finishReDoWork.do"];
    }
    return self;
}
@end
