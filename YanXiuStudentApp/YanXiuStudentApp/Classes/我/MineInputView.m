//
//  MineInputView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/24.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "MineInputView.h"

@interface MineInputView ()<UITextFieldDelegate>
@end

@implementation MineInputView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.clipsToBounds = YES;
    self.textField = [[ExtendTextField alloc]init];
    self.textField.font = [UIFont boldSystemFontOfSize:19];
    self.textField.textColor = [UIColor colorWithHexString:@"333333"];
    [self.textField setTintColor:[UIColor colorWithHexString:@"89e00d"]];
    self.textField.delegate = self;
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.clipsToBounds = YES;
    [self addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    _placeHolder = placeHolder;
    self.textField.attributedPlaceholder = [[NSMutableAttributedString alloc]initWithString:placeHolder attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"cccccc"],NSFontAttributeName:[UIFont boldSystemFontOfSize:19]}];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.textField resignFirstResponder];
    return YES;
}

@end
