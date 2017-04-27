//
//  YXLoginInputView.m
//  YanXiuApp
//
//  Created by ChenJianjun on 15/5/29.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXLoginInputView.h"
#import "UIColor+YXColor.h"

static CGFloat const interval = 10.f;

@interface YXLoginInputView ()

@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *textFieldClipsView;
@property (nonatomic, strong) UIImageView *inputBGView;
@property (nonatomic, strong) UIImageView *frontImageView;
@property (nonatomic, strong) NSShadow *textShadow;

@end

@implementation YXLoginInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _bgView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"登录_单元框"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 32, 20, 32)]];
        _bgView.userInteractionEnabled = YES;
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
        _inputBGView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"输入框"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 6, 8, 6)]];
        [_bgView addSubview:_inputBGView];
        [_inputBGView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(interval + 1.f);
            make.bottom.mas_equalTo(-interval - 3.f);
            make.left.mas_equalTo(interval*1.5f);
            make.right.mas_equalTo(-interval);
        }];
        
        self.textFieldClipsView = [[UIView alloc] init];
        self.textFieldClipsView.clipsToBounds = YES;
        self.textFieldClipsView.backgroundColor = [UIColor clearColor];
        [self.bgView addSubview:self.textFieldClipsView];
        [self remakeTextFieldConstraints];
        
        self.textField = [[UITextField alloc] init];
        self.textField.tintColor = [UIColor whiteColor];
        self.textField.delegate = self;
        [self.textField addTarget:self action:@selector(textEditingChanged:) forControlEvents:UIControlEventEditingChanged];
        [self.textFieldClipsView addSubview:_textField];
        [self setDefaultTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.f],
                                         NSForegroundColorAttributeName: [UIColor whiteColor],
                                         NSShadowAttributeName: [self textShadow]}];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return self;
}

- (BOOL)resignFirstResponder
{
    [super resignFirstResponder];
    return [self.textField resignFirstResponder];
}

- (BOOL)becomeFirstResponder {
    [super becomeFirstResponder];
    return [self.textField becomeFirstResponder];
}

#pragma mark - getter & setter

- (void)setText:(NSString *)text
{
    self.textField.text = text;
    [self setRightButtonEnabled:[text yx_isValidString]];
    [self textEditingChanged:self.textField];
}

- (NSString *)text
{
    return [self.textField.text yx_stringByTrimmingCharacters];
}

- (NSString *)originalText {
    return self.textField.text;
}
- (void)setPlaceholder:(NSString *)placeholder
{
    if (![placeholder yx_isValidString]) {
        return;
    }
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.f],
                                 NSForegroundColorAttributeName: [UIColor whiteColor],
                                 NSShadowAttributeName: [self textShadow]};
    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:attributes];
}

- (NSString *)placeholder
{
    return self.textField.placeholder;
}

- (void)setEnabled:(BOOL)enabled
{
    self.textField.enabled = enabled;
}

- (BOOL)enabled
{
    return self.textField.enabled;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType
{
    self.textField.keyboardType = keyboardType;
}

- (UIKeyboardType)keyboardType
{
    return self.textField.keyboardType;
}

- (void)setSecureTextEntry:(BOOL)secureTextEntry
{
    self.textField.secureTextEntry = secureTextEntry;
}

- (BOOL)secureTextEntry
{
    return self.textField.secureTextEntry;
}

- (void)setDefaultTextAttributes:(NSDictionary *)defaultTextAttributes
{
    self.textField.defaultTextAttributes = defaultTextAttributes;
}

- (NSDictionary *)defaultTextAttributes
{
    return self.textField.defaultTextAttributes;
}

- (NSShadow *)textShadow
{
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0, 1); //垂直投影
    shadow.shadowColor = [UIColor yx_colorWithHexString:@"a37a00"];
    return shadow;
}

#pragma mark - Public

- (void)setFrontImage:(UIImage *)image
{
    self.frontImageView.image = image;
    [self.frontImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(interval*1.5f);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(image.size.height);
        make.width.mas_equalTo(image.size.width);
    }];
    [self.inputBGView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(interval + 1.f);
        make.bottom.mas_equalTo(-interval - 3.f);
        make.right.mas_equalTo(-interval);
        make.left.mas_equalTo(self.frontImageView.mas_right).offset(interval);
    }];
    [self remakeTextFieldConstraints];
}

- (void)setRightButtonImage:(UIImage *)image
{
    [self.rightButton setImage:image forState:UIControlStateNormal];
    [self.rightButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-interval*1.5f);
        make.width.mas_equalTo(image.size.width);
        make.height.mas_equalTo(image.size.height);
    }];
    [self.inputBGView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(interval + 1.f);
        make.bottom.mas_equalTo(-interval - 3.f);
        make.left.mas_equalTo(self.frontImageView.mas_right).offset(interval);
        make.right.mas_equalTo(self.rightButton.mas_left).offset(-interval);
    }];
    [self remakeTextFieldConstraints];
    //[self setRightButtonEnabled:[self.text yx_isValidString]];
}

- (void)setRightButtonText:(NSString *)text
{
    [self resetRightButtonText:text];
    UIFont *font = [UIFont systemFontOfSize:14.f];
    self.rightButton.titleLabel.font = font;
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName: font}];
    [self.rightButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(interval + 1.f);
        make.bottom.mas_equalTo(-interval - 3.f);
        make.right.mas_equalTo(-interval);
        make.width.mas_equalTo(size.width + interval*1.3f);
    }];
    [self.inputBGView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(interval + 1.f);
        make.bottom.mas_equalTo(-interval - 3.f);
        make.left.mas_equalTo(self.frontImageView.mas_right).offset(interval);
        make.right.mas_equalTo(self.rightButton.mas_left).offset(-interval + 4.f);
    }];
    [self remakeTextFieldConstraints];
}

- (void)resetRightButtonText:(NSString *)text
{
    [self.rightButton setTitle:text forState:UIControlStateNormal];
}

- (void)setRightButtonBackgroundImage:(UIImage *)image forState:(UIControlState)state
{
    [self.rightButton setBackgroundImage:image forState:state];
}

- (void)setRightClearButtonImages
{
    [self.rightButton setImage:[UIImage imageNamed:@"一键清空-未激活"] forState:UIControlStateDisabled];
    [self setRightButtonImage:[UIImage imageNamed:@"清空按钮"]];
}

- (void)setRightButtonEnabled:(BOOL)enabled
{
    _rightButton.enabled = enabled;
}

#pragma mark -

- (UIImageView *)frontImageView
{
    if (!_frontImageView) {
        _frontImageView = [[UIImageView alloc] init];
        [self.bgView addSubview:_frontImageView];
    }
    return _frontImageView;
}

- (UIButton *)rightButton
{
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] init];
        [_rightButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_rightButton setTitleColor:[UIColor yx_colorWithHexString:@"805500"] forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor yx_colorWithHexString:@"e4b62e"] forState:UIControlStateHighlighted];
        [_rightButton setTitleColor:[UIColor yx_colorWithHexString:@"e4b62e"] forState:UIControlStateDisabled];
        _rightButton.titleLabel.layer.shadowColor = [UIColor colorWithHexString:@"ffff99"].CGColor;
        _rightButton.titleLabel.layer.shadowOffset = CGSizeMake(0, 1);
        _rightButton.titleLabel.layer.shadowRadius = 0;
        _rightButton.titleLabel.layer.shadowOpacity = 1;
        [self.bgView addSubview:_rightButton];
    }
    return _rightButton;
}

- (void)buttonClick:(id)sender
{
    if (self.rightClick) {
        self.rightClick();
    }
}

- (void)remakeTextFieldConstraints
{
    [self.textFieldClipsView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.inputBGView.mas_left).offset(interval - 2.f);
        make.right.mas_equalTo(self.inputBGView.mas_right);
        make.height.mas_equalTo(21);
        make.centerY.mas_equalTo(0);
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - text change

- (void)textEditingChanged:(UITextField *)sender
{
    [self setRightButtonEnabled:[self.text yx_isValidString]];
    if (self.textChangeBlock) {
        self.textChangeBlock(self.text);
    }
}

@end
