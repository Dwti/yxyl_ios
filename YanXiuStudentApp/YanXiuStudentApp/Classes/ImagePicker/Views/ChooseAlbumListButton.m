//
//  ChooseAlbumListButton.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 1/4/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "ChooseAlbumListButton.h"

@implementation ChooseAlbumListButton

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self setImage:[UIImage imageNamed:@"箭头"] forState:UIControlStateNormal];
    
    [self setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.layer.shadowColor = [UIColor colorWithHexString:@"005959"].CGColor;
    self.titleLabel.layer.shadowOffset = CGSizeMake(0, 1);
    self.titleLabel.layer.shadowOpacity = 1;
    self.titleLabel.layer.shadowRadius = 0;
}

- (void)updateWithTitle:(NSString *)title {
    [self setTitle:title forState:UIControlStateNormal];
    [self.titleLabel sizeToFit];
    CGFloat labelWidth = self.titleLabel.frame.size.width;
    CGFloat imageWidth = [UIImage imageNamed:@"箭头"].size.width;
    CGFloat gap = 10;
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth-gap, 0, imageWidth+gap);
    self.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+gap, 0, -labelWidth-gap);
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
