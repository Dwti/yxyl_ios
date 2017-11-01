//
//  YXPlayerBufferingView.m
//  YanXiuApp
//
//  Created by Lei Cai on 5/26/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "YXPlayerBufferingView.h"

@implementation YXPlayerBufferingView {
    UIImageView *_imageView;
    BOOL _bAnimating;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (id)init {
    self = [super init];
    if (self) {
//        [self _setupUI];
        WEAK_SELF
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidBecomeActiveNotification object:nil] subscribeNext:^(id x) {
            STRONG_SELF
            [self refresh];//解决切换后台动画停止问题
        }];
    }
    return self;
}

- (void)_setupUI {
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"播放器buffering"]];
    [self addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(@0);
    }];
}
- (void)refresh {
    if (_bAnimating) {
        [self nyx_startLoading];
//        [self.layer removeAnimationForKey:@"buffering rotation"];
//        CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
//        anim.duration = 1;
//        anim.repeatCount = MAXFLOAT;
//        anim.values = @[@(0),@(M_PI_2),@(M_PI),@(M_PI*1.5),@(M_PI*2)];
//        [self.layer addAnimation:anim forKey:@"buffering rotation"];
    }
}

- (void)start {
    if (_bAnimating) {
        return;
    }
    [self nyx_startLoading];
//    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
//    anim.duration = 1;
//    anim.repeatCount = MAXFLOAT;
//    anim.values = @[@(0),@(M_PI_2),@(M_PI),@(M_PI*1.5),@(M_PI*2)];
//    [self.layer addAnimation:anim forKey:@"buffering rotation"];
    _bAnimating = YES;
}

- (void)stop {
//    [self.layer removeAnimationForKey:@"buffering rotation"];
    [self nyx_stopLoading];
    _bAnimating = NO;
}

@end
