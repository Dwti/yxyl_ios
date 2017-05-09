//
//  PasswordInputView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/8.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "PasswordInputView.h"

@interface PasswordInputView()
@property (nonatomic, strong) UIButton *showHideButton;
@end

@implementation PasswordInputView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupObserver];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"69ad0a"];
    self.showHideButton = [[UIButton alloc]init];
    [self.showHideButton setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
    [self.showHideButton addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.showHideButton];
    [self.showHideButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-17);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(17, 17));
    }];
    self.inputView = [[LoginInputView alloc]init];
    self.inputView.textField.secureTextEntry = YES;
    self.inputView.placeHolder = @"请输入密码";
    [self addSubview:self.inputView];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(self.showHideButton.mas_left).mas_offset(-17);
        make.top.bottom.mas_equalTo(0);
    }];
}

- (void)setupObserver {
    WEAK_SELF
    [[self.inputView.textField rac_textSignal]subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.textChangeBlock)
    }];
}

- (void)btnAction {
    self.inputView.textField.secureTextEntry = !self.inputView.textField.secureTextEntry;
}

- (NSString *)text {
    return [self.inputView.textField.text yx_stringByTrimmingCharacters];
}

@end
