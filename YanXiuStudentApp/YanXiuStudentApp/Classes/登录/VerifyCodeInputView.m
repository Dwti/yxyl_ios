//
//  VerifyCodeInputView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/8.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "VerifyCodeInputView.h"
#import "LoginInputView.h"

static const NSInteger kTimerDuration = 45;

@interface VerifyCodeInputView()

@property (nonatomic, strong) LoginInputView *inputView;
@property (nonatomic, strong) UIButton *codeButton;
@property (nonatomic, strong) GCDTimer *timer;
@property (nonatomic, assign) NSInteger secondsRemained;
@end

@implementation VerifyCodeInputView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupObserver];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"69ad0a"];
    self.codeButton = [[UIButton alloc]init];
    [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.codeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.codeButton setTitleColor:[UIColor colorWithHexString:@"89e00d"] forState:UIControlStateDisabled];
    self.codeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.codeButton addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.codeButton];
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(103);
    }];
    UIView *seperatorView = [[UIView alloc]init];
    seperatorView.backgroundColor = [UIColor colorWithHexString:@"89e00d"];
    [self addSubview:seperatorView];
    [seperatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.codeButton.mas_left);
        make.size.mas_equalTo(CGSizeMake(1, 18));
        make.centerY.mas_equalTo(0);
    }];
    self.inputView = [[LoginInputView alloc]init];
    self.inputView.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.inputView.placeHolder = @"请输入验证码";
    [self addSubview:self.inputView];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(seperatorView.mas_left).mas_offset(-20);
    }];
    
}

- (void)setupObserver {
    WEAK_SELF
    [[self.inputView.textField rac_textSignal]subscribeNext:^(NSString *text) {
        STRONG_SELF
        if (text.length>4) {
            self.inputView.textField.text = [text substringToIndex:4];
        }
        BLOCK_EXEC(self.textChangeBlock)
    }];
}

- (void)btnAction {
    if (self.secondsRemained > 0) {
        return;
    }
    BLOCK_EXEC(self.sendAction);
}

- (void)setIsActive:(BOOL)isActive {
    _isActive = isActive;
    if (isActive) {
        self.codeButton.enabled = YES;
        self.codeButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    }else {
        self.codeButton.enabled = NO;
        self.codeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
}

- (NSString *)text {
    return [self.inputView.textField.text yx_stringByTrimmingCharacters];
}

#pragma mark - timer
- (void)startTimer {
    if (!self.timer) {
        self.secondsRemained = kTimerDuration;
        WEAK_SELF
        self.timer = [[GCDTimer alloc]initWithInterval:1 repeats:YES triggerBlock:^{
            STRONG_SELF
            [self countdownTimer];
        }];
        [self.timer resume];
    }
}

- (void)countdownTimer {
    if (self.secondsRemained <= 0) {
        [self stopTimer];
    } else {
        self.secondsRemained--;
        NSString *title = [NSString stringWithFormat:@"%@S",@(self.secondsRemained)];
        [self.codeButton setTitle:title forState:UIControlStateNormal];
    }
    [self setIsActive:self.secondsRemained <= 0];
}

- (void)stopTimer {
    self.timer = nil;
    self.secondsRemained = 0;
    [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self setIsActive:self.secondsRemained <= 0];
}
@end
