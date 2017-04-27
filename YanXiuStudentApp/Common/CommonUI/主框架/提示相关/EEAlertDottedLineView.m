//
//  EEAlertDottedLineView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2016/12/9.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "EEAlertDottedLineView.h"

@implementation EEAlertDottedLineView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.lineColor = [UIColor colorWithHexString:@"e4b62e"];
        self.dashWidth = 3.0f;
        self.gapWidth = 2.0f;
        self.symmetrical = YES;
        [self yx_setShadowWithColor:[UIColor colorWithHexString:@"ffeb66"]];
    }
    return self;
}
@end
