//
//  YXToastView.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/12/9.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXToastView.h"
#import "YXDottedLineView+YXShadowLineMethod.h"
#import "UIColor+YXColor.h"
#import "UIView+YXScale.h"

@interface YXToastView ()

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, assign) BOOL showing;

@end

@implementation YXToastView

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
        CGFloat height = 84 * [UIView scale];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(0);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
        }];
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.numberOfLines = 2;
        _textLabel.textColor = [UIColor yx_colorWithHexString:@"805500"];
        _textLabel.shadowColor = [UIColor yx_colorWithHexString:@"ffff99"];
        _textLabel.shadowOffset = CGSizeMake(0, 1);
        _textLabel.font = [UIFont boldSystemFontOfSize:15.f];
        [contentView addSubview:_textLabel];
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(20 * [UIView scale]);
            make.right.mas_equalTo(-20 * [UIView scale]);
        }];
    }
    return self;
}

- (void)setText:(NSString *)text
{
    self.textLabel.text = text;
}

- (NSString *)text
{
    return self.textLabel.text;
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
    [self removeFromSuperview];
}

@end
