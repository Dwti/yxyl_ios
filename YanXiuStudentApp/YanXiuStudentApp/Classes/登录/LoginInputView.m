//
//  LoginInputView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/8.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "LoginInputView.h"

@interface LoginInputView ()<UITextFieldDelegate>

@end

@implementation LoginInputView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.clipsToBounds = YES;
    self.textField = [[UITextField alloc]init];
    self.textField.font = [UIFont boldSystemFontOfSize:16];
    self.textField.textColor = [UIColor whiteColor];
    self.textField.delegate = self;
    self.textField.returnKeyType = UIReturnKeyDone;
    [self addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    _placeHolder = placeHolder;
    self.textField.attributedPlaceholder = [[NSMutableAttributedString alloc]initWithString:placeHolder attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"89e00d"],NSFontAttributeName:[UIFont systemFontOfSize:16]}];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.textField resignFirstResponder];
    return YES;
}

@end
