//
//  TextInputView.m
//  YanXiuStudentApp
//
//  Created by FanYu on 11/2/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import "TextInputView.h"
#import "UIColor+YXColor.h"

@interface TextInputView ()

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *textFieldClipsView;
@property (nonatomic, strong) UIImageView *inputBGView;
@property (nonatomic, strong) UIImageView *frontImageView;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) NSShadow *textShadow;

@end

@implementation TextInputView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    self.inputBGView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"输入框"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 6, 8, 6)]];
    self.inputBGView.userInteractionEnabled = YES;
    
    self.textFieldClipsView = [[UIView alloc] init];
    self.textFieldClipsView.clipsToBounds = YES;
    self.textFieldClipsView.backgroundColor = [UIColor clearColor];
    
    self.textField = [[UITextField alloc] init];
    self.textField.tintColor = [UIColor whiteColor];
    self.textField.delegate = self;
    [self.textField addTarget:self action:@selector(textEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    self.textField.defaultTextAttributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14.f],
                                             NSForegroundColorAttributeName: [UIColor whiteColor],
                                             NSShadowAttributeName: [self textShadow]};
}

- (void)setupLayout {
    [self addSubview:self.inputBGView];
    [self.inputBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.inputBGView addSubview:self.textFieldClipsView];
    [self.textFieldClipsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.inputBGView.mas_left).offset(8);
        make.right.mas_equalTo(self.inputBGView.mas_right).offset(-8);
        make.height.mas_equalTo(18);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.textFieldClipsView addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (BOOL)becomeFirstResponder {
    [super becomeFirstResponder];
    return [self.textField becomeFirstResponder];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger textLength = textField.text.length;
    if (range.length == 0) {
        if (textLength > self.maxInputLength - 1) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - text change

- (void)textEditingChanged:(UITextField *)sender {
    if (self.textChangeBlock) {
        self.textChangeBlock(self.text);
    }
}


@end
