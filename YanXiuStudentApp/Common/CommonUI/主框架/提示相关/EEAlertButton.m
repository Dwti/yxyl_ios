//
//  EEAlertButton.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2016/12/9.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "EEAlertButton.h"

@implementation EEAlertButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundImage:[[UIImage imageNamed:@"弹框按钮背景"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
        [self setBackgroundImage:[[UIImage imageNamed:@"弹框按钮背景-按下"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateHighlighted];
        [self setTitleColor:[UIColor colorWithHexString:@"805500"] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithHexString:@"CBA94C"] forState:UIControlStateDisabled];
        [self setTitleShadowColor:[UIColor colorWithHexString:@"ffff99"] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17.f];
        self.titleLabel.shadowOffset = CGSizeMake(0, 1);
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    _title = [title copy];
    [self setTitle:title forState:UIControlStateNormal];
}

@end
