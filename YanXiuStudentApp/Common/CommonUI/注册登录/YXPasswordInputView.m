//
//  YXPasswordInputView.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/12/8.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXPasswordInputView.h"

@implementation YXPasswordInputView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.keyboardType = UIKeyboardTypeASCIICapable;
        self.secureTextEntry = YES;
    }
    return self;
}

- (void)setShowPassword:(BOOL)showPassword {
    if (showPassword) {
        __block UIImage *rightImage = [UIImage imageNamed:@"闭眼"];
        [self setRightButtonImage:rightImage];
        @weakify(self);
        self.rightClick = ^{
            @strongify(self);
            if (!self) {
                return;
            }
            BOOL secureTextEntry = self.secureTextEntry;
            if (secureTextEntry) {
                rightImage = [UIImage imageNamed:@"睁眼"];
            } else {
                rightImage = [UIImage imageNamed:@"闭眼"];
            }
            self.secureTextEntry = !secureTextEntry;
            [self setRightButtonImage:rightImage];
            //重置textField样式和内容
            [self setText:self.text];
            [self setDefaultTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.f],
                                             NSForegroundColorAttributeName: [UIColor whiteColor],
                                             NSShadowAttributeName: [self textShadow]}];
            self.placeholder = @"密码";
        };
    } else {
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
}


@end
