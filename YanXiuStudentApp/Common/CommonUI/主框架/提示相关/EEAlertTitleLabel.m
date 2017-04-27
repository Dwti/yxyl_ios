//
//  EEAlertTitleLabel.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2016/12/9.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "EEAlertTitleLabel.h"

@implementation EEAlertTitleLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.textColor = [UIColor colorWithHexString:@"805500"];
        self.shadowColor = [UIColor colorWithHexString:@"ffff99"];
        self.shadowOffset = CGSizeMake(0, 1);
        self.font = [UIFont boldSystemFontOfSize:12.f];
        self.numberOfLines = 0;
    }
    return self;
}


@end
