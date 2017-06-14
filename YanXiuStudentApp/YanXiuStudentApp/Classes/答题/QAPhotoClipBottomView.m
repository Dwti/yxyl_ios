//
//  QAPhotoClipBottomView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/15.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAPhotoClipBottomView.h"

@interface QAPhotoClipBottomView()
@property (nonatomic, strong) UIButton *exitButton;
@property (nonatomic, strong) UIButton *resetButton;
@property (nonatomic, strong) UIButton *confirmButton;
@end

@implementation QAPhotoClipBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.shadowOffset = CGSizeMake(0, -2.5);
    self.layer.shadowRadius = 2.5;
    self.layer.shadowOpacity = 0.02;
    self.layer.shadowColor = [UIColor colorWithHexString:@"002c0f"].CGColor;
    self.exitButton = [[UIButton alloc]init];
    [self.exitButton setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
    [self.exitButton addTarget:self action:@selector(exitAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.exitButton];
    [self.exitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50*kPhoneWidthRatio);
        make.size.mas_equalTo(CGSizeMake(22, 22));
        make.centerY.mas_equalTo(0);
    }];
    self.confirmButton = [[UIButton alloc]init];
    [self.confirmButton setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
    [self.confirmButton addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.confirmButton];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-50*kPhoneWidthRatio);
        make.size.mas_equalTo(CGSizeMake(22, 22));
        make.centerY.mas_equalTo(0);
    }];
    self.resetButton = [[UIButton alloc]init];
    [self.resetButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.resetButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"89e00d"]] forState:UIControlStateHighlighted];
    [self.resetButton setTitle:@"还原" forState:UIControlStateNormal];
    [self.resetButton setTitleColor:[UIColor colorWithHexString:@"89e00d"] forState:UIControlStateNormal];
    [self.resetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    self.resetButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.resetButton.layer.borderColor = [UIColor colorWithHexString:@"89e00d"].CGColor;
    self.resetButton.layer.borderWidth = 2;
    self.resetButton.layer.cornerRadius = 6;
    self.resetButton.clipsToBounds = YES;
    [self.resetButton addTarget:self action:@selector(resetAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.resetButton];
    [self.resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(50, 35));
    }];
}

- (void)exitAction {
    BLOCK_EXEC(self.exitBlock);
}

- (void)resetAction {
    BLOCK_EXEC(self.resetBlock);
}

- (void)confirmAction {
    BLOCK_EXEC(self.confirmBlock);
}

@end
