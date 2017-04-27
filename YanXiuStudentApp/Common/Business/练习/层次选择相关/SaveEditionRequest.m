//
//  SaveEditionRequest.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/25.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "SaveEditionRequest.h"

@implementation SaveEditionRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"app/common/saveEditionInfo.do"];
    }
    return self;
}
@end
