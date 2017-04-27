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
    // 此图高70
    UIImage *bgImage = [[UIImage imageNamed:@"选修下拉控件"] resizableImageWithCapInsets:UIEdgeInsetsMake(35, 30, 35, 30)];
    // 下图高64
    //UIImage *bgImageH = [[UIImage imageNamed:@"选修下拉控件-按下"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 30)];
    [self setBackgroundImage:bgImage forState:UIControlStateNormal];
    [self setBackgroundImage:bgImage forState:UIControlStateHighlighted];
    [self setImage:[UIImage imageNamed:@"选修下拉控件-三角"] forState:UIControlStateNormal];
    
    [self setTitleColor:[UIColor colorWithHexString:@"00e6e6"] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithHexString:@"ffdb4d"] forState:UIControlStateSelected];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.layer.shadowColor = [UIColor colorWithHexString:@"005959"].CGColor;
    self.titleLabel.layer.shadowOffset = CGSizeMake(0, 1);
    self.titleLabel.layer.shadowOpacity = 1;
    self.titleLabel.layer.shadowRadius = 0;
}

- (CGSize)updateWithTitle:(NSString *)title {
    [self setTitle:title forState:UIControlStateNormal];
    [self.titleLabel sizeToFit];
    CGFloat labelWidth = self.titleLabel.frame.size.width;
    CGFloat imageWidth = [UIImage imageNamed:@"选修下拉控件-三角"].size.width;
    CGFloat gap = 10;
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
