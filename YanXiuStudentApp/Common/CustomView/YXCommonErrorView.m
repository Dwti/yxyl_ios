//
//  YXCommonErrorView.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/12/28.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXCommonErrorView.h"
#import "UIView+YXScale.h"
#import "UIButton+YXButton.h"
#import "UIColor+YXColor.h"

@interface YXCommonErrorView ()

@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIImageView *errorImageView;
@property (nonatomic, strong) UILabel *errorMsgLabel;
@property (nonatomic, strong) UIButton *retryButton;

@end

@implementation YXCommonErrorView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
        self.errorMsg = @"网络故障，请检查重试";
        self.errorImage = [UIImage imageNamed:@"没信号icon"];
    }
    return self;
}

- (void)setupSubviews
{
    _bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"报错背景"]];
    _bgView.userInteractionEnabled = YES;
    [self addSubview:_bgView];
    
    _errorImageView = [[UIImageView alloc] init];
    [_bgView addSubview:_errorImageView];
    
    UIColor *uniformColor = [UIColor yx_colorWithHexString:@"ffdb4d"];
    
    _errorMsgLabel = [[UILabel alloc] init];
    _errorMsgLabel.font = [UIFont systemFontOfSize:15.f];
    _errorMsgLabel.textAlignment = NSTextAlignmentCenter;
    _errorMsgLabel.textColor = uniformColor;
    [_bgView addSubview:_errorMsgLabel];
    
    _retryButton = [[UIButton alloc] init];
    [_retryButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_retryButton setTitle:@"重试" forState:UIControlStateNormal];
    _retryButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.f];
    [_retryButton yx_setUniformColor:uniformColor highlightedTextColor:[UIColor yx_colorWithHexString:@"333333"]];
    [_bgView addSubview:_retryButton];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(300 * [UIView scale]);
        make.height.mas_equalTo(206 * [UIView scale]);
        make.centerX.centerY.mas_equalTo(0);
    }];
    
    [_errorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30 * [UIView scale]);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(70 * [UIView scale]);
        make.height.mas_equalTo(54 * [UIView scale]);
    }];
    
    [_retryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20 * [UIView scale]);
        make.bottom.right.mas_equalTo(-20 * [UIView scale]);
        make.height.mas_equalTo(40 * [UIView scale]);
    }];
    
    [_errorMsgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_errorImageView.mas_bottom).offset(13 * [UIView scale]);
        make.left.mas_equalTo(5 * [UIView scale]);
        make.right.mas_equalTo(-5 * [UIView scale]);
        make.bottom.mas_equalTo(_retryButton.mas_top).offset(-10 * [UIView scale]);
    }];
}

- (void)setErrorImage:(UIImage *)errorImage
{
    self.errorImageView.image = errorImage;
}

- (UIImage *)errorImage
{
    return self.errorImageView.image;
}

- (void)setErrorMsg:(NSString *)errorMsg
{
    self.errorMsgLabel.text = errorMsg;
}

- (NSString *)errorMsg
{
    return self.errorMsgLabel.text;
}

- (void)setErrorCode:(NSString *)errorCode
{
    if ([errorCode isEqualToString:@"-1"]) {
        self.errorMsg = @"数据加载失败，请稍后重试";
        self.errorImage = [UIImage imageNamed:@"数据报错icon"];
    }
}

#pragma mark -

- (void)buttonAction:(id)sender
{
    // trick for bug : ZYDIPHONE-284
    if ([self.errorMsgLabel.text isEqualToString:@"网络故障，请检查重试"]) {
        self.hidden = YES;
    }
    
    if (self.retryBlock) {
        self.retryBlock();
    }
}

@end
