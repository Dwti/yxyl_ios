//
//  YXNumberField.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/12/17.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXNumberField.h"
#import "UIView+YXScale.h"

@interface YXNumberField ()

@property (nonatomic, strong) UIImageView *backImageView;

@end

@implementation YXNumberField

#pragma mark- Get
- (UIImageView *)backImageView
{
    if (!_backImageView) {
        _backImageView = [UIImageView new];
        _backImageView.image = [UIImage yx_resizableImageNamed:@"输入框"];
        _backImageView.frame = self.frame;
    }
    return _backImageView;
}
#pragma mark-
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textDidChange:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (BOOL)becomeFirstResponder
{
    [super becomeFirstResponder];
    return [self.textField becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    [super resignFirstResponder];
    return [self.textField resignFirstResponder];
}

#pragma mark -

- (void)setText:(NSString *)text
{
    self.textField.text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self setLabelText];
}

- (NSString *)text
{
    return self.textField.text;
}

- (void)setNumberCount:(NSInteger)numberCount
{
    if (numberCount < 1) {
        return;
    }
    _numberCount = numberCount;
    [self setupSubviews];
}

- (void)setSecureTextEntry:(BOOL)secureTextEntry
{
    self.textField.secureTextEntry = secureTextEntry;
}

- (BOOL)secureTextEntry
{
    return self.textField.secureTextEntry;
}

#pragma mark -

- (void)setupSubviews
{
    if (self.textField) {
        return;
    }
    CGFloat width = 29.f * [UIView scale];
    CGFloat interval = 5.f * [UIView scale];
    CGFloat originX = (CGRectGetWidth(self.bounds) - width * self.numberCount - interval * (self.numberCount - 1)) / 2.f;
    originX = (originX < 0 ? 0:originX);
    [self addSubview:self.backImageView];
//    UIImage *image = [[UIImage imageNamed:@"输入框"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 6, 8, 6)];
    for (NSInteger index = 0; index < self.numberCount; index++) {
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//        imageView.frame = CGRectMake(originX + (width + interval) * index, 0, width, CGRectGetHeight(self.bounds));
//        [self addSubview:imageView];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(originX + (width + interval) * index, 0, width, CGRectGetHeight(self.bounds))];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:YXFontMetro_Bold size:22.f];
        label.shadowColor = [UIColor colorWithHexString:@"a37a00"];
        label.shadowOffset = CGSizeMake(0, 1);
        label.tag = index;
        [self addSubview:label];
    }
    
    CGRect frame = self.bounds;
    frame.origin.x = originX;
    frame.size.width -= (2*originX);
    
    self.textField = [[UITextField alloc] initWithFrame:frame];
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.textField.tintColor = [UIColor clearColor];
    self.textField.textColor = [UIColor clearColor];
//    self.textField.font = [UIFont fontWithName:YXFontMetro_Bold size:22.f];
    self.textField.delegate = self;
    [self addSubview:self.textField];
}

- (void)textDidChange:(NSNotification *)notification
{
    [self setLabelText];
}

- (void)setLabelText
{
    NSString *text = self.textField.text;
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)subview;
            if (label.tag >= text.length) {
                label.text = nil;
            } else {
                label.text = [text substringWithRange:NSMakeRange(label.tag, 1)];
            }
        }
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger count = 0;
    if (range.length == 0) { // 输入操作
        count = self.numberCount;
    } else { // 删除操作
        count = self.numberCount + 1;
    }
    if (textField.text.length >= count) {
        return NO;
    }
    return YES;
}

@end
