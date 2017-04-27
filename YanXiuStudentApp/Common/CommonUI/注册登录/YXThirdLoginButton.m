//
//  YXThirdLoginButton.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/12/8.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXThirdLoginButton.h"
#import "UIButton+YXButton.h"

@implementation YXThirdLoginButton

- (instancetype)initWithFrame:(CGRect)frame
                        image:(UIImage *)image
                        title:(NSString *)title
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self setImage:image forState:UIControlStateNormal];
        [self setImage:image forState:UIControlStateHighlighted];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17.f];
        [self setBackgroundImage:[[UIImage imageNamed:@"其他账号"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
        [self setBackgroundImage:[[UIImage imageNamed:@"其他账号-按下"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateHighlighted];
    }
    return self;
}

@end
