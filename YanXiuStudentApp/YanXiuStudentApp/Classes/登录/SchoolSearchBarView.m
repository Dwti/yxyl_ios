//
//  SchoolSearchBarView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/10.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "SchoolSearchBarView.h"
#import "PrefixHeader.pch"

@interface SchoolSearchBarView()<UITextFieldDelegate>
@property (nonatomic, strong) UIButton *searchButton;
@end

@implementation SchoolSearchBarView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupObserver];
    }
    return self;
}

- (void)setupUI {
    self.layer.cornerRadius = 6;
    self.layer.borderWidth = 2;
    self.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
    
    self.searchButton = [[UIButton alloc]init];
    [self.searchButton setImage:[UIImage imageNamed:@"搜索icon可点击态"] forState:UIControlStateNormal];
    [self.searchButton setImage:[UIImage imageNamed:@"搜索icon点击态"] forState:UIControlStateHighlighted];
    [self.searchButton setImage:[UIImage imageNamed:@"搜索icon不能点击"] forState:UIControlStateDisabled];
    [self.searchButton addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.searchButton];
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-18);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(23, 23));
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.searchButton.mas_left).mas_offset(-18);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(1, 14));
    }];
    
    self.textField = [[UITextField alloc]init];
    self.textField.textColor = [UIColor colorWithHexString:@"333333"];
    self.textField.font = [UIFont boldSystemFontOfSize:16];
    NSString *placeholder = @"请输入学校名称";
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:placeholder];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, placeholder.length)];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"999999"] range:NSMakeRange(0, placeholder.length)];
    self.textField.attributedPlaceholder = attrString;
    self.textField.returnKeyType = UIReturnKeySearch;
    self.textField.delegate = self;
    [self addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(line.mas_left).mas_offset(-25);
    }];
}

- (void)setupObserver {
    WEAK_SELF
    [[self.textField rac_textSignal]subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.searchBlock,x)
        self.searchButton.enabled = !isEmpty(x);
    }];
}

- (void)btnAction {
    BLOCK_EXEC(self.searchBlock,self.textField.text)
    [self.textField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BLOCK_EXEC(self.searchBlock,textField.text)
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.layer.borderColor = [UIColor colorWithHexString:@"89e00d"].CGColor;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
}

@end
