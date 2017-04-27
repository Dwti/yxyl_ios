//
//  YXPhoneInputView.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/12/8.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXPhoneInputView.h"

static NSUInteger const YXPhoneNumberCount = 11;
static NSUInteger const YXFirstIntervalIndex = 4;
static NSUInteger const YXSecondIntervalIndex = 9;

@implementation YXPhoneInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.keyboardType = UIKeyboardTypeNumberPad;
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:YXFontMetro_Bold size:22.f],
                                     NSForegroundColorAttributeName: [UIColor whiteColor],
                                     NSShadowAttributeName: [self textShadow]};
        [self setDefaultTextAttributes:attributes];
        self.placeholder = @"手机号";
        [self setFrontImage:[UIImage imageNamed:@"手机号"]];
        [self setRightClearButtonImages];
        @weakify(self);
        self.rightClick = ^{
            @strongify(self);
            if (!self) {
                return;
            }
            self.text = nil;
        };
    }
    return self;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *replacedText = [self replacedTextWithOriText:textField.text range:range replacementString:string];
    NSString *adjustedText = [self adjustedPhoneNumberStringWithString:replacedText];
    if (adjustedText.length > YXPhoneNumberCount+2) {
        return NO;
    }
    textField.text = adjustedText;
    self.text = textField.text;
    
    NSInteger position = 0;
    if (string.length > 0) { // input
        if ([self isSpaceLocationWithLocation:range.location]) {
            position = range.location+2;
        }else {
            position = range.location+1;
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
- (NSString *)text
{
    NSString *text = [super text];
    return [text stringByReplacingOccurrencesOfString:@" " withString:@""];
}
@end
