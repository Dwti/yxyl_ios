//
//  ListenComplexPromptView.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 12/21/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import "ListenComplexPromptView.h"
#import "UIView+YXScale.h"


@implementation ListenComplexPromptView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIView *containerView = [[UIView alloc]init];
    [self addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    EEAlertContentBackgroundImageView *bgView = [[EEAlertContentBackgroundImageView alloc] init];
    [containerView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    UIImageView *errorImageView = [[UIImageView alloc] init];
    errorImageView.image = [UIImage imageNamed:@"警告"];
    [containerView addSubview:errorImageView];
    [errorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80 * [UIView scale], 80 * [UIView scale]));
        make.centerX.mas_equalTo(0);
        make.top.equalTo(containerView.mas_top).mas_offset(0);
    }];
    
    EEAlertTitleLabel *titleLabel = [[EEAlertTitleLabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.text = @"当前非WiFi网络,继续试听将会消耗手机流量.";
    [containerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(errorImageView.mas_bottom).mas_offset(-8);
        make.left.equalTo(containerView.mas_left).mas_offset(20);
        make.right.equalTo(containerView.mas_right).mas_offset(-20);
    }];
    
    EEAlertDottedLineView *lineView = [[EEAlertDottedLineView alloc] init];
    [containerView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).mas_equalTo(10);
        make.left.equalTo(containerView.mas_left).mas_equalTo(5);
        make.right.equalTo(containerView.mas_right).mas_equalTo(-5);
        make.height.mas_equalTo(1);
    }];
    
    EEAlertButton *button = [[EEAlertButton alloc] init];
    [button setTitle:@"知道了" forState:UIControlStateNormal];
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        BLOCK_EXEC(self.okAction);
    }];
    
    [containerView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).mas_equalTo(12);
        make.centerX.equalTo(containerView.mas_centerX);
        make.height.mas_equalTo(42);
        make.bottom.equalTo(containerView.mas_bottom).mas_equalTo(-15);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
}

@end
