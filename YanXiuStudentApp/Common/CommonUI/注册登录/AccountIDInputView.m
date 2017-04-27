//
//  AccountIDInputView.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 3/28/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "AccountIDInputView.h"

@implementation AccountIDInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:YXFontMetro_Bold size:22.f],
                                     NSForegroundColorAttributeName: [UIColor whiteColor],
                                     NSShadowAttributeName: [self textShadow]};
        [self setDefaultTextAttributes:attributes];
        self.placeholder = @"请输入账号/手机号";
        self.keyboardType = UIKeyboardTypeASCIICapable;
        [self setFrontImage:[UIImage imageNamed:@"手机号"]];
        [self setRightClearButtonImages];
        WEAK_SELF
        self.rightClick = ^{
            STRONG_SELF
            self.text = nil;
        };
    }
    return self;
}

- (NSString *)text {
    NSString *text = [super text];
    return [text stringByReplacingOccurrencesOfString:@" " withString:@""];
}

@end
