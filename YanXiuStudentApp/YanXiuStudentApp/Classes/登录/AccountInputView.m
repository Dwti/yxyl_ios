//
//  AccountInputView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/8.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "AccountInputView.h"

@interface AccountInputView()<UITextFieldDelegate>
@property (nonatomic, strong) UIButton *clearButton;
@end

@implementation AccountInputView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupObserver];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"69ad0a"];
    self.clearButton = [[UIButton alloc]init];
    [self.clearButton setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
    [self.clearButton addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.clearButton];
    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-17);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(17, 17));
    }];
    self.inputView = [[LoginInputView alloc]init];
    self.inputView.placeHolder = @"请输入账号或手机号";
    self.inputView.textField.delegate = self;
    [self addSubview:self.inputView];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(self.clearButton.mas_left).mas_offset(-17);
        make.top.bottom.mas_equalTo(0);
    }];
}

- (void)setupObserver {
    WEAK_SELF
    [[self.inputView.textField rac_textSignal]subscribeNext:^(id x) {
        STRONG_SELF
        self.clearButton.hidden = isEmpty(x);
        BLOCK_EXEC(self.textChangeBlock)
    }];
}

- (void)clearAction {
    self.inputView.textField.text = @"";
    BLOCK_EXEC(self.textChangeBlock)
    self.clearButton.hidden = YES;
}

- (NSString *)text {
    return [self.inputView.textField.text yx_stringByTrimmingCharacters];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.clearButton.hidden = textField.text.length==0;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.clearButton.hidden = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
