//
//  MineActionView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/22.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "MineActionView.h"
#import "UIButton+WaveHighlight.h"

@interface MineActionView()
@property (nonatomic, strong) UIButton *actionButton;
@end

@implementation MineActionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.actionButton = [[UIButton alloc]init];
    self.actionButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.actionButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"89e00d"]] forState:UIControlStateNormal];
    [self.actionButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"6bab22"]] forState:UIControlStateHighlighted];
    [self.actionButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"cccccc"]] forState:UIControlStateDisabled];
    [self.actionButton addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    self.actionButton.layer.cornerRadius = 6;
    self.actionButton.clipsToBounds = YES;
    [self addSubview:self.actionButton];
    [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.actionButton.isWaveHighlight = YES;
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
