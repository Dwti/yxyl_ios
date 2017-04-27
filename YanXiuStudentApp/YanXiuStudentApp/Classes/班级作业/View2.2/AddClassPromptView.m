//
//  AddClassPromptView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/12/20.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "AddClassPromptView.h"

@implementation AddClassPromptView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    EEAlertContentBackgroundImageView *contentView = [[EEAlertContentBackgroundImageView alloc]initWithFrame:self.bounds];
    contentView.userInteractionEnabled = YES;
    [self addSubview:contentView];
    
    EEAlertTipImageView *tipIconView = [EEAlertTipImageView new];
    tipIconView.frame = CGRectMake(15, 10, 22, 22);
    [contentView addSubview:tipIconView];
    
    EEAlertTitleLabel *messageLabel = [EEAlertTitleLabel new];
    messageLabel.text = @"同学，你需要先加入一个班级 ^_^";
    [messageLabel sizeToFit];
    messageLabel.x = tipIconView.maxX + 11;
    messageLabel.centerY = tipIconView.centerY;
    messageLabel.numberOfLines = 2;
    [contentView addSubview:messageLabel];
    
    EEAlertDottedLineView *shadowLineView = [[EEAlertDottedLineView alloc] initWithFrame:CGRectMake(5, 37, contentView.width - 10, 2)];
    [contentView addSubview:shadowLineView];
    
    UIButton *helpButton = [[UIButton alloc] init];
    WEAK_SELF
    [[helpButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.helpAction);
    }];
    [helpButton setTitle:@"怎样加入班级？>" forState:UIControlStateNormal];
    [helpButton setTitleColor:[UIColor colorWithRGBHex:0x805500] forState:UIControlStateNormal];
    [helpButton setTitleShadowColor:[UIColor colorWithRGBHex:0xffff99] forState:UIControlStateNormal];
    helpButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    helpButton.titleLabel.shadowOffset = CGSizeMake(0, 1);
    [contentView addSubview:helpButton];
    [helpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset = -9;
        make.centerX.offset = 0;
        make.left.right.offset = 0;
        make.height.offset = 50;
    }];
    
    EEAlertButton *joinButton = [EEAlertButton new];
    joinButton.title = @"加入班级";
    [[joinButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.joinAction);
    }];
    [contentView addSubview:joinButton];
    [joinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(helpButton.mas_top).offset = 0;
        make.left.offset = 20;
        make.right.offset = -20;
        make.height.offset = 40;
    }];
}

@end
