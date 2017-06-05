//
//  QABlankItemInfo.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/2.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QABlankItemInfo.h"

@implementation QABlankItemInfo

- (instancetype)init {
    if (self = [super init]) {
        self.viewArray = [NSMutableArray array];
        self.blankRange = NSMakeRange(0, 0);
        self.prefixLetter = @"";
    }
    return self;
}

- (NSString *)displayedString {
    if (isEmpty(self.answer)) {
        return self.placeholder;
    }
    return [NSString stringWithFormat:@"%@%@",self.prefixLetter,self.answer];
}
@end
