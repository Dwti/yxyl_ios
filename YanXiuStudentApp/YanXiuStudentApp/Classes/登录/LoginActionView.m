//
//  LoginActionView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/8.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "LoginActionView.h"

@interface LoginActionView()
@property (nonatomic, strong) UIButton *actionButton;
@end

@implementation LoginActionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.actionButton = [[UIButton alloc]init];
    [self.actionButton setTitleColor:[UIColor colorWithHexString:@"89e00d"] forState:UIControlStateNormal];
    [self.actionButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.actionButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"69ad0a"]] forState:UIControlStateDisabled];
    self.actionButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.actionButton.layer.cornerRadius = 6;
    self.actionButton.clipsToBounds = YES;
    [self.actionButton addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.actionButton];
    [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)btnAction {
    BLOCK_EXEC(self.actionBlock);
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [self.actionButton setTitle:title forState:UIControlStateNormal];
}

- (void)setIsActive:(BOOL)isActive {
    _isActive = isActive;
    self.actionButton.enabled = isActive;
}

@end
