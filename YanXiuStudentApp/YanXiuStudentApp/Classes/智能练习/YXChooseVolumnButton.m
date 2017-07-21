//
//  YXChooseVolumnButton.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 12/7/15.
//  Copyright © 2015 yanxiu.com. All rights reserved.
//

#import "YXChooseVolumnButton.h"

@implementation YXChooseVolumnButton

- (instancetype)init {
    self = [super init];
    if (self) {
        [self _setupUI];
    }
    return self;
}

- (void)_setupUI {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 6;
    self.layer.borderWidth = 2;
    self.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
    self.clipsToBounds = YES;
    
    [self setImage:[UIImage imageNamed:@"下拉展开弹窗按钮正常态"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"下拉展开弹窗按钮点击态"] forState:UIControlStateHighlighted];
    
    [self setTitleColor:[UIColor colorWithHexString:@"89e00d"] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
}

- (CGSize)updateWithTitle:(NSString *)title {
    [self setTitle:title forState:UIControlStateNormal];
    [self.titleLabel sizeToFit];
    CGFloat labelWidth = self.titleLabel.frame.size.width;
    CGFloat imageWidth = [UIImage imageNamed:@"下拉展开弹窗按钮正常态"].size.width;
    CGFloat gap = 5;
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth-gap, 0, imageWidth+gap);
    self.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+gap, 0, -labelWidth-gap);
    return CGSizeMake(30+labelWidth+imageWidth+gap*2, 35);
}

- (void)setBExpand:(BOOL)bExpand {
    if (_bExpand != bExpand) {
        if (bExpand) {
            [CATransaction begin];
            [CATransaction setAnimationDuration:0.3];
            [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
            CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
            anim.values = @[@0, @-M_PI_2, @-M_PI];
            [self.imageView.layer addAnimation:anim forKey:anim.keyPath];
            [CATransaction commit];
            self.imageView.transform = CGAffineTransformMakeRotation(-M_PI);;
            
        } else {
            [CATransaction begin];
            [CATransaction setAnimationDuration:0.3];
            [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
            CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
            anim.values = @[@-M_PI, @-M_PI_2, @0];
            [self.imageView.layer addAnimation:anim forKey:anim.keyPath];
            [CATransaction commit];
            self.imageView.transform = CGAffineTransformIdentity;
        }
    }
    
    _bExpand = bExpand;
}

@end
