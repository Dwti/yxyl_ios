//
//  EEAlertTipImageView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2016/12/9.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "EEAlertTipImageView.h"

@implementation EEAlertTipImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.image = [UIImage imageNamed:@"tips-icon-yellow"];
    }
    return self;
}

@end
