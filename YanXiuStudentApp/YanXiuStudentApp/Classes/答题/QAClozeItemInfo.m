//
//  QAClozeItemInfo.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/6.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAClozeItemInfo.h"

@implementation QAClozeItemInfo
- (instancetype)init {
    if (self = [super init]) {
        self.blankRange = NSMakeRange(0, 0);
        self.placeholder = @"";
    }
    return self;
}
@end
