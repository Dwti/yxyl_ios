//
//  YXWordInputView.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/12/8.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXWordInputView.h"

@implementation YXWordInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setRightClearButtonImages];
        @weakify(self);
        self.rightClick = ^{
            @strongify(self);
            if (!self) {
                return;
            }
            self.text = nil;
        };
    }
    return self;
}

@end
