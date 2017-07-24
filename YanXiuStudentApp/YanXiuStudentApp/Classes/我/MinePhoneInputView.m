//
//  MinePhoneInputView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/24.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "MinePhoneInputView.h"

static NSUInteger const YXPhoneNumberCount = 11;
static NSUInteger const YXFirstIntervalIndex = 4;
static NSUInteger const YXSecondIntervalIndex = 9;

@interface MinePhoneInputView()<UITextFieldDelegate>
@property (nonatomic, strong) UIButton *clearButton;
@end

@implementation MinePhoneInputView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupObserver];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    self.clearButton = [[UIButton alloc]init];
    [self.clearButton setBackgroundImage:[UIImage imageNamed:@"绑定手机删除当前编辑文字icon正常态"] forState:UIControlStateNormal];
    [self.clearButton setBackgroundImage:[UIImage imageNamed:@"绑定手机删除当前编辑文字icon点击态"] forState:UIControlStateHighlighted];
    [self.clearButton addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.clearButton];
    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(17, 17));
    }];
    self.inputView = [[MineInputView alloc]init];
    self.inputView.placeHolder = @"请输入手机号";
    self.inputView.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.inputView.textField.delegate = self;
    [self addSubview:self.inputView];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self.clearButton.mas_left).mas_offset(-15);
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
    return [self.inputView.textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.clearButton.hidden = textField.text.length==0;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.clearButton.hidden = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (!isEmpty(string) && ![string nyx_isPureInt]) {
        return NO;
    }
    NSString *replacedText = [self replacedTextWithOriText:textField.text range:range replacementString:string];
    NSString *adjustedText = [self adjustedPhoneNumberStringWithString:replacedText];
    if (adjustedText.length > YXPhoneNumberCount+2) {
        return NO;
    }
    textField.text = adjustedText;
    self.clearButton.hidden = isEmpty(textField.text);
    BLOCK_EXEC(self.textChangeBlock)
    
    NSInteger position = 0;
    if (string.length > 0) { // input
        position = range.location;
        NSInteger length = string.length;
        while (length>0) {
            if ([self isSpaceLocationWithLocation:position]) {
                position++;
            }
            NSInteger count = 0;
            if (position<YXFirstIntervalIndex-1) {
                count = YXFirstIntervalIndex-1-position;
            }else if (position<YXSecondIntervalIndex-1) {
                count = YXSecondIntervalIndex-1-position;
            }else {
                count = YXSecondIntervalIndex+4-position;
            }
            position += MIN(length, count);
            length -= count;
        }
    }else { // delete
        if ([self isSpaceLocationWithLocation:range.location] || range.location>textField.text.length) {
            position = range.location-1;
        }else {
            position = range.location;
        }
    }
    
    [self setCursorPosition:position inTextfield:textField];
    return NO;
}

- (NSString *)replacedTextWithOriText:(NSString *)oriText range:(NSRange)range replacementString:(NSString *)string {
    NSRange adjustedRange = range;
    if (string.length == 0 && [self isSpaceLocationWithLocation:range.location]) {
        adjustedRange = NSMakeRange(range.location-1, range.length+1);
    }
    return [oriText stringByReplacingCharactersInRange:adjustedRange withString:string];
}

- (BOOL)isSpaceLocationWithLocation:(NSInteger)loc {
    if (loc == YXFirstIntervalIndex - 1 || loc == YXSecondIntervalIndex - 1) {
        return YES;
    }
    return NO;
}

- (NSString *)adjustedPhoneNumberStringWithString:(NSString *)string {
    NSString *mobile = [string yx_stringByTrimmingCharacters];
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length >= YXFirstIntervalIndex) {
        mobile = [mobile stringByReplacingCharactersInRange:NSMakeRange(YXFirstIntervalIndex-1, 0) withString:@" "];
    }
    if (mobile.length >= YXSecondIntervalIndex) {
        mobile = [mobile stringByReplacingCharactersInRange:NSMakeRange(YXSecondIntervalIndex-1, 0) withString:@" "];
    }
    return mobile;
}

- (void)setCursorPosition:(NSInteger)pos inTextfield:(UITextField *)textfield {
    UITextPosition* beginning = textfield.beginningOfDocument;
    UITextPosition* startPosition = [textfield positionFromPosition:beginning offset:pos];
    UITextPosition* endPosition = [textfield positionFromPosition:beginning offset:pos];
    UITextRange* selectionRange = [textfield textRangeFromPosition:startPosition toPosition:endPosition];
    textfield.selectedTextRange = selectionRange;;
}


@end
