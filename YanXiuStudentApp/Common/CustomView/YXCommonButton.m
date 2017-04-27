//
//  YXCommonButton.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/13.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXCommonButton.h"
#import "UIButton+YXButton.h"
#import "UIColor+YXColor.h"

@implementation YXCommonButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        UIImage *image = [[UIImage imageNamed:@"通用按钮背景"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 30, 20, 30)];
        UIImage *highlightedImage = [[UIImage imageNamed:@"通用按钮背景-按下"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 30, 20, 30)];
        [self setBackgroundWithImage:image highlightedImage:highlightedImage];
        [self setBackgroundImage:[[UIImage imageNamed:@"登录_单元框"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 30, 20, 30)] forState:UIControlStateDisabled];
        [self yx_setTitleColor:[UIColor yx_colorWithHexString:@"805500"]];
        self.titleLabel.layer.shadowColor = [UIColor yx_colorWithHexString:@"ffff99"].CGColor;
        self.titleLabel.layer.shadowOffset = CGSizeMake(0, 1);
        self.titleLabel.layer.shadowRadius = 0;
        self.titleLabel.layer.shadowOpacity = 1;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    }
    return self;
}

- (void)setBackgroundWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage
{
    [self setBackgroundImage:image forState:UIControlStateNormal];
    [self setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
}

@end
