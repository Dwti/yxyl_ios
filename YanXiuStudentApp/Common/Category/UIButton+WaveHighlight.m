//
//  UIButton+WaveHighlight.m
//  test
//
//  Created by niuzhaowang on 2017/5/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UIButton+WaveHighlight.h"
#import <objc/runtime.h>

static char waveHighlightKey;
static char waveLayerKey;

@interface UIButton()<CAAnimationDelegate>
@property (nonatomic, strong) CALayer *waveLayer;
@end

@implementation UIButton (WaveHighlight)

- (void)setIsWaveHighlight:(BOOL)isWaveHighlight {
    objc_setAssociatedObject(self, &waveHighlightKey, @(isWaveHighlight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (isWaveHighlight) {
        [self addTarget:self action:@selector(nyx_buttonTouchDown:withEvent:) forControlEvents:UIControlEventTouchDown];
    }else {
        [self removeTarget:self action:@selector(nyx_buttonTouchDown:withEvent:) forControlEvents:UIControlEventTouchDown];
    }
}

- (BOOL)isWaveHighlight {
    return [(NSNumber *)objc_getAssociatedObject(self, &waveHighlightKey) integerValue];
}

- (void)setWaveLayer:(CALayer *)waveLayer {
    objc_setAssociatedObject(self, &waveLayerKey, waveLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CALayer *)waveLayer {
    return objc_getAssociatedObject(self, &waveLayerKey);
}

- (void)nyx_buttonTouchDown:(UIButton *)sender withEvent:(UIEvent*)event {
    [self.waveLayer removeFromSuperlayer];
    
    UITouch *touch = [event touchesForView:sender].anyObject;
    CGPoint p = [touch locationInView:sender];
    
    CALayer *bottomLayer = [CALayer layer];
    bottomLayer.frame = sender.bounds;
    bottomLayer.contents = (id)[self backgroundImageForState:UIControlStateNormal].CGImage;
    
    CGFloat oriWidth = 40;
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, oriWidth, oriWidth);
    layer.position = p;
    layer.cornerRadius = oriWidth/2;
    layer.masksToBounds = YES;
    layer.contents = (id)[self backgroundImageForState:UIControlStateHighlighted].CGImage;
    
    [bottomLayer addSublayer:layer];
    [sender.layer insertSublayer:bottomLayer below:sender.imageView.layer];
    self.waveLayer = bottomLayer;
    
    CGFloat maxWidth = MAX(p.x, sender.bounds.size.width-p.x);
    CGFloat maxHeight = MAX(p.y, sender.bounds.size.height-p.y);
    CGFloat scale = sqrtf(powf(maxWidth, 2)+powf(maxHeight, 2))/oriWidth*2;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = @(1);
    animation.toValue = @(scale);
    animation.duration = .2;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.delegate = self;
    [layer addAnimation:animation forKey:@"ani"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.waveLayer removeFromSuperlayer];
}

@end
