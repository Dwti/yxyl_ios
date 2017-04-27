//
//  YXBottomGradientView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/12/7.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXBottomGradientView.h"

@implementation YXBottomGradientView

+ (Class)layerClass{
    return [CAGradientLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor *)gradientColor {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = NO;
        CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
        gradientLayer.colors = @[(id)[gradientColor colorWithAlphaComponent:0].CGColor,(id)gradientColor.CGColor];
        gradientLayer.startPoint = CGPointMake(0.5, 0);
        gradientLayer.endPoint = CGPointMake(0.5, 1);
    }
    return self;
}

@end
