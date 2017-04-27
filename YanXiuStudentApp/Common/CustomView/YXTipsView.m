//
//  YXTipsView.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/12/22.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXTipsView.h"
#import "UIColor+YXColor.h"
#import "UIView+YXScale.h"
#import "YXCommonLabel.h"

@interface YXTipsView ()

@property (nonatomic, strong) YXCommonLabel *titleLabel;
@property (nonatomic, strong) YXCommonLabel *textLabel;
@property (nonatomic, strong) YXCommonLabel *detailTextLabel;
@property (nonatomic, assign) BOOL showing;

@end

@implementation YXTipsView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0.f;
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
        UIImageView *contentView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"提示框"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 30, 20, 30)]];
        [self addSubview:contentView];
        CGFloat width = 306 * [UIView scale];
        CGFloat height = 129;
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(0);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
        }];
        
        _titleLabel = [[YXCommonLabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:30.f];
        [contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(25);
            make.left.mas_equalTo(20 * [UIView scale]);
            make.right.mas_equalTo(-20 * [UIView scale]);
            make.height.mas_equalTo(36);
        }];
        
        _textLabel = [[YXCommonLabel alloc] init];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont boldSystemFontOfSize:17.f];
        _textLabel.numberOfLines = 0;
        [contentView addSubview:_textLabel];
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-25);
            make.left.mas_equalTo(20 * [UIView scale]);
            make.right.mas_equalTo(-20 * [UIView scale]);
            make.height.mas_greaterThanOrEqualTo(25);
        }];
        
        _detailTextLabel = [[YXCommonLabel alloc] init];
        _detailTextLabel.textAlignment = NSTextAlignmentCenter;
        _detailTextLabel.font = [UIFont systemFontOfSize:14.f];
        [contentView addSubview:_detailTextLabel];
        [_detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-20);
            make.left.mas_equalTo(20 * [UIView scale]);
            make.right.mas_equalTo(-20 * [UIView scale]);
            make.height.mas_equalTo(20);
        }];
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (NSString *)title
{
    return self.titleLabel.text;
}

- (void)setText:(NSString *)text
{
    self.textLabel.text = text;
}

- (NSString *)text
{
    return self.textLabel.text;
}

- (void)setDetailText:(NSString *)detailText
{
    if (![detailText yx_isValidString]) {
        return;
    }
    self.detailTextLabel.text = detailText;
    [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20 * [UIView scale]);
        make.right.mas_equalTo(-20 * [UIView scale]);
        make.height.mas_equalTo(25);
        make.bottom.mas_equalTo(self.detailTextLabel.mas_top).offset(2);
    }];
}

- (NSString *)detailText
{
    return self.detailTextLabel.text;
}

#pragma mark - Animation

- (void)show:(BOOL)animated
{
    self.showing = YES;
    if (animated) {
        [UIView animateWithDuration:0.3f animations:^{
            self.alpha = 1.f;
        }];
    } else {
        self.alpha = 1.f;
    }
}

- (void)hide:(BOOL)animated
{
    if (animated && self.showing) {
        [UIView animateWithDuration:0.3f
                         animations:^{
                             self.alpha = 0.02f;
                         } completion:^(BOOL finished) {
                             [self finishedHidden];
                         }];
    } else {
        [self finishedHidden];
    }
    self.showing = NO;
}

- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay
{
    [self performSelector:@selector(hideDelayed:) withObject:[NSNumber numberWithBool:animated] afterDelay:delay];
}

- (void)hideDelayed:(NSNumber *)animated
{
    [self hide:[animated boolValue]];
}

- (void)finishedHidden
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.alpha = 0.f;
    //[self removeFromSuperview];
}

@end
