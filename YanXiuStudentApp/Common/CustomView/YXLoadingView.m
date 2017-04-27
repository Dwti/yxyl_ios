//
//  YXLoadingView.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/12/28.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXLoadingView.h"

#define YXLoadingViewTag 151228

@interface YXLoadingView ()

@property (nonatomic, strong) UIImageView *maskView;
@property (nonatomic, strong) UIImageView *loadingImageView;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation YXLoadingView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        _maskView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"loading背景"] resizableImageWithCapInsets:UIEdgeInsetsMake(40, 40, 40, 40)]];
        [self addSubview:_maskView];
        [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
        UIImage *loadingImage = [UIImage imageNamed:@"loading前景"];
        _loadingImageView = [[UIImageView alloc] initWithImage:loadingImage];
        [self addSubview:_loadingImageView];
        [_loadingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(loadingImage.size.width);
            make.height.mas_equalTo(loadingImage.size.height);
            make.centerX.centerY.mas_equalTo(0);
        }];
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.font = [UIFont boldSystemFontOfSize:17.f];
        [self addSubview:_textLabel];
    }
    return self;
}

- (void)startLoading
{
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    rotationAnimation.duration = 1.f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = NSIntegerMax;
    [self.loadingImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stopLoading
{
    [self.loadingImageView.layer removeAllAnimations];
    [self removeFromSuperview];
}

- (void)setText:(NSString *)text
{
    if ([text yx_isValidString]) {
        [self.loadingImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.loadingImageView.image.size.width);
            make.height.mas_equalTo(self.loadingImageView.image.size.height);
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(-15);
        }];
        self.textLabel.hidden = NO;
        self.textLabel.text = text;
        [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(self.loadingImageView.mas_bottom);
            make.bottom.mas_equalTo(-10);
        }];
    } else {
        [self.loadingImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.loadingImageView.image.size.width);
            make.height.mas_equalTo(self.loadingImageView.image.size.height);
            make.centerX.centerY.mas_equalTo(0);
        }];
        self.textLabel.hidden = YES;
    }
}

@end

@implementation YXLoadingControl

+ (UIView *)startLoadingWithSuperview:(UIView *)superview
{
    return [self startLoadingWithSuperview:superview text:nil];
}

+ (UIView *)startLoadingWithSuperview:(UIView *)superview text:(NSString *)text
{
    [self stopLoadingWithSuperview:superview];
    
    YXLoadingView *loadingView = [[YXLoadingView alloc] init];
    loadingView.tag = YXLoadingViewTag;
    [superview addSubview:loadingView];
    if ([text yx_isValidString]) {
        loadingView.text = text;
        [loadingView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(125);
            make.height.mas_equalTo(125);
            make.centerX.centerY.mas_equalTo(0);
        }];
    } else {
        [loadingView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(94);
            make.height.mas_equalTo(94);
            make.centerX.centerY.mas_equalTo(0);
        }];
    }
    
    [loadingView startLoading];
    return loadingView;
}

+ (void)stopLoadingWithSuperview:(UIView *)superview
{
    UIView *view = [superview viewWithTag:YXLoadingViewTag];
    if (view && [view isKindOfClass:[YXLoadingView class]]) {
        [(YXLoadingView *)view stopLoading];
        view = nil;
    }
}

@end
