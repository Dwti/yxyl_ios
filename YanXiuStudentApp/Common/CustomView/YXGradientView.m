//
//  YXGradientView.m
//  abc
//
//  Created by niuzhaowang on 16/1/20.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGradientView.h"

@implementation YXGradientView

+ (Class)layerClass{
    return [CAGradientLayer class];
}

- (instancetype)initWithColor:(UIColor *)color orientation:(YXGradientOrientation)orientation{
    return [self initWithStartColor:color endColor:[color colorWithAlphaComponent:0] orientation:orientation];
}

- (instancetype)initWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor orientation:(YXGradientOrientation)orientation{
    if (self = [super init]) {
        self.userInteractionEnabled = NO;
        CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
        gradientLayer.colors = @[(id)startColor.CGColor,(id)endColor.CGColor];
        if (orientation == YXGradientLeftToRight) {
            gradientLayer.startPoint = CGPointMake(0, 0.5);
            gradientLayer.endPoint = CGPointMake(1, 0.5);
        }else if (orientation == YXGradientRightToLeft){
            gradientLayer.startPoint = CGPointMake(1, 0.5);
            gradientLayer.endPoint = CGPointMake(0, 0.5);
        }else if (orientation == YXGradientTopToBottom){
            gradientLayer.startPoint = CGPointMake(0.5, 0);
            gradientLayer.endPoint = CGPointMake(0.5, 1);
        }else if (orientation == YXGradientBottomToTop){
            gradientLayer.startPoint = CGPointMake(0.5, 1);
            gradientLayer.endPoint = CGPointMake(0.5, 0);
        }
    }
    return self;
}


@end
