//
//  EEAlertContentBackgroundImageView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2016/12/9.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "EEAlertContentBackgroundImageView.h"

@implementation EEAlertContentBackgroundImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.image = [[UIImage imageNamed:@"系统弹层背景"] resizableImageWithCapInsets:UIEdgeInsetsMake(40, 105, 40, 105)];
    }
    return self;
}


@end
