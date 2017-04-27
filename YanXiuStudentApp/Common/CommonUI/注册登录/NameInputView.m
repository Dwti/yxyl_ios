//
//  NameInputView.m
//  YanXiuStudentApp
//
//  Created by FanYu on 11/18/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import "NameInputView.h"
#import "UIColor+YXColor.h"
#import "UIView+YXScale.h"

static CGFloat const interval = 10.f;

@interface NameInputView()

@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *textFieldClipsView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *inputBGView;
@property (nonatomic, strong) NSShadow *textShadow;

@end


@implementation NameInputView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    self.bgView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"列表背景"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 32, 20, 32)]];
    self.bgView.userInteractionEnabled = YES;

    self.inputBGView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"输入框"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 6, 8, 6)]];

    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor yx_colorWithHexString:@"805500"];
    self.titleLabel.shadowColor = [UIColor yx_colorWithHexString:@"ffff99"];
    self.titleLabel.shadowOffset = CGSizeMake(0, 1);
    self.titleLabel.font = [UIFont boldSystemFontOfSize:17.f];
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.text = @"姓名";
    
    self.textFieldClipsView = [[UIView alloc] init];
    self.textFieldClipsView.clipsToBounds = YES;
    self.textFieldClipsView.backgroundColor = [UIColor clearColor];

    self.textField = [[UITextField alloc] init];
    self.textField.tintColor = [UIColor whiteColor];
    self.textField.delegate = self;
    [self.textField addTarget:self action:@selector(textEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    [self setDefaultTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.f],
                                     NSForegroundColorAttributeName: [UIColor whiteColor],
                                     NSShadowAttributeName: [self textShadow]}];
}

- (void)setupLayout {
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.bgView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30 * [UIView scale]);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(35);
    }];

    [self.bgView addSubview:self.inputBGView];
    [self.inputBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(interval + 2.f);
        make.bottom.mas_equalTo(-interval - 3.f);
        make.left.equalTo(self.titleLabel.mas_right).mas_offset(11 * [UIView scale]);
        make.right.mas_equalTo(-20 * [UIView scale]);
    }];
    
    [self.bgView addSubview:self.textFieldClipsView];
    [self.textFieldClipsView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.inputBGView.mas_left).offset(10 * [UIView scale]);
        make.right.mas_equalTo(self.inputBGView.mas_right);
        make.height.mas_equalTo(21);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.textFieldClipsView addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (BOOL)resignFirstResponder {
    [super resignFirstResponder];
    return [self.textField resignFirstResponder];
}

#pragma mark - getter & setter

- (void)setText:(NSString *)text {
    self.textField.text = text;
}

- (NSString *)text {
    return [self.textField.text yx_stringByTrimmingCharacters];
}

- (void)setPlaceholder:(NSString *)placeholder {
    if (![placeholder yx_isValidString]) {
        return;
    }
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.f],
                                 NSForegroundColorAttributeName: [UIColor whiteColor],
                                 NSShadowAttributeName: [self textShadow]};
    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:attributes];
}

- (NSString *)placeholder {
    return self.textField.placeholder;
}

- (void)setEnabled:(BOOL)enabled {
    self.textField.enabled = enabled;
}

- (BOOL)enabled {
    return self.textField.enabled;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    self.textField.keyboardType = keyboardType;
}

- (UIKeyboardType)keyboardType {
    return self.textField.keyboardType;
}

- (void)setSecureTextEntry:(BOOL)secureTextEntry {
    self.textField.secureTextEntry = secureTextEntry;
}

- (BOOL)secureTextEntry {
    return self.textField.secureTextEntry;
}

- (void)setDefaultTextAttributes:(NSDictionary *)defaultTextAttributes {
    self.textField.defaultTextAttributes = defaultTextAttributes;
}

- (NSDictionary *)defaultTextAttributes {
    return self.textField.defaultTextAttributes;
}

- (NSShadow *)textShadow {
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0, 1); //垂直投影
    shadow.shadowColor = [UIColor yx_colorWithHexString:@"a37a00"];
    return shadow;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - text change

- (void)textEditingChanged:(UITextField *)sender {
    if (self.textChangeBlock) {
        self.textChangeBlock(self.text);
    }
}

@end
