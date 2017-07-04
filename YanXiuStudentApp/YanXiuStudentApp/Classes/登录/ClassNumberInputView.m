//
//  ClassNumberInputView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/9.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "ClassNumberInputView.h"
#import "PrefixHeader.pch"

@interface ClassNumberTextfield : UITextField
@end
@implementation ClassNumberTextfield
- (void)deleteBackward {
    [super deleteBackward];
    [self.delegate textField:self shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@""];
}
@end


static const NSInteger kLabelTagBase = 555;

@interface ClassNumberInputView () <UITextFieldDelegate>
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) ClassNumberTextfield *inputField;
@property (nonatomic, strong) NSMutableArray<__kindof UILabel *> *labelArray;
@property (nonatomic, assign) NSInteger inputPositionIndex;
@end
@implementation ClassNumberInputView

- (void)setNumberCount:(NSInteger)numberCount {
    if (numberCount < 1) {
        return;
    }
    _numberCount = numberCount;
    [self setupUI];
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"69ad0a"];
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    
    UILabel *preLabel = nil;
    UIView *preLine = nil;
    
    self.labelArray = [NSMutableArray array];
    for (NSInteger i=0; i<self.numberCount; i++) {
        UILabel *lb = [[UILabel alloc] init];
        lb.tag = kLabelTagBase+i;
        lb.textColor = [UIColor whiteColor];
        lb.textAlignment = NSTextAlignmentCenter;
        lb.font = [UIFont fontWithName:YXFontMetro_Bold size:18.f];
//        lb.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTapAction:)];
//        [lb addGestureRecognizer:tap];
        [self addSubview:lb];
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor colorWithHexString:@"89e00d"];
        [self addSubview:line];
        
        if (!preLabel) {
            [lb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(0);
                make.left.mas_equalTo(0);
            }];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(0);
                make.left.mas_equalTo(lb.mas_right);
                make.size.mas_equalTo(CGSizeMake(1, 18));
            }];
        }else if (i < self.numberCount-1) {
            [lb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(0);
                make.left.mas_equalTo(preLine.mas_right);
                make.width.mas_equalTo(preLabel.mas_width);
            }];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(0);
                make.left.mas_equalTo(lb.mas_right);
                make.size.mas_equalTo(CGSizeMake(1, 18));
            }];
        }else {
            [line removeFromSuperview];
            [lb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(0);
                make.left.mas_equalTo(preLine.mas_right);
                make.width.mas_equalTo(preLabel.mas_width);
                make.right.mas_equalTo(0);
            }];
        }
        preLabel = lb;
        preLine = line;
        [self.labelArray addObject:lb];
    }
    self.inputField = [[ClassNumberTextfield alloc] init];
    self.inputField.textColor = [UIColor clearColor];
    self.inputField.keyboardType = UIKeyboardTypeNumberPad;
//    self.inputField.textAlignment = NSTextAlignmentCenter;
    self.inputField.tintColor = [UIColor colorWithHexString:@"69ad0a"];
    self.inputField.delegate = self;
    self.inputPositionIndex = 0;
//    [self addSubview:self.inputField];
//    [self.inputField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo([self.labelArray firstObject]).offset(0);
//    }];
    [self insertSubview:self.inputField atIndex:0];
    [self.inputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    WEAK_SELF
    [[self.inputField rac_textSignal]subscribeNext:^(id x) {
        STRONG_SELF
        NSString *text = x;
        text = [text yx_stringByTrimmingCharacters];        
        if (text.length > self.numberCount) {
            text = [text substringToIndex:self.numberCount];
        }
        self.inputField.text = text;
        NSInteger len = MIN(text.length, self.numberCount);
        [self.labelArray enumerateObjectsUsingBlock:^(__kindof UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx < len) {
                obj.text = [text substringWithRange:NSMakeRange(idx, 1)];
            }else{
                obj.text = @"";
            }
        }];
        BLOCK_EXEC(self.textChangeBlock,text);
    }];
}

- (void)labelTapAction:(UITapGestureRecognizer *)gesture {
    UILabel *label = (UILabel *)gesture.view;
    if (label.text.length == 0) {
        return;
    }
    if (label.tag-kLabelTagBase == self.inputPositionIndex) {
        return;
    }
    self.inputPositionIndex = label.tag-kLabelTagBase;
    [self updateFieldWithPosition:self.inputPositionIndex];
    [self.inputField becomeFirstResponder];
}

- (void)updateFieldWithPosition:(NSInteger)index {
    self.inputField.text = self.labelArray[index].text;
    [self addSubview:self.inputField];
    [self.inputField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.labelArray[index]).offset(0);
    }];
}

- (BOOL)becomeFirstResponder {
    return [self.inputField becomeFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (isEmpty(string) || [string nyx_isPureInt]) {
        return YES;
    }
    return NO;
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    if (string.length > 0) { // input
//        if (![self canInput]) {
//            return NO;
//        }
//        NSInteger index = self.inputPositionIndex;
//        if (range.location>0) {
//            index++;
//        }
//        [self updateLabelsWithRange:NSMakeRange(index, 0) replacementString:string];
//        self.inputPositionIndex++;
//        if (![self canInput]) {
//            [self.inputField resignFirstResponder];
//            [self.inputField removeFromSuperview];
//            self.inputPositionIndex = -1;
//        }else{
//            [self updateFieldWithPosition:self.inputPositionIndex];
//        }
//    }else { // delete
//        if (![self canDeleteWithRange:range]) {
//            return NO;
//        }
//        NSInteger index = self.inputPositionIndex;
//        if (range.length==0) {
//            index--;
//        }
//        [self updateLabelsWithRange:NSMakeRange(index, 1) replacementString:@""];
//        self.inputPositionIndex--;
//        self.inputPositionIndex = MAX(self.inputPositionIndex, 0);
//        [self updateFieldWithPosition:self.inputPositionIndex];
//    }
//    return NO;
//}

- (BOOL)canInput {
    return self.labelArray.lastObject.text.length == 0;
}

- (BOOL)canDeleteWithRange:(NSRange)range {
    if (range.length > 0) {
        return YES;
    }
    if (self.inputPositionIndex > 0) {
        return YES;
    }
    return NO;
}

- (void)updateLabelsWithRange:(NSRange)range replacementString:(NSString *)string {
    NSString *oriString = [self classNumberStringFromLabels];
    NSString *curString = [oriString stringByReplacingCharactersInRange:range withString:string];
    [self resetLabelsWithClassNumberString:curString];
    if (self.textChangeBlock) {
        self.textChangeBlock(curString);
    }
}

- (NSString *)classNumberStringFromLabels {
    __block NSString *str = @"";
    [self.labelArray enumerateObjectsUsingBlock:^(__kindof UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.text.length > 0) {
            str = [str stringByAppendingString:obj.text];
        }else {
            *stop = YES;
        }
    }];
    return str;
}

- (void)resetLabelsWithClassNumberString:(NSString *)string {
    [self.labelArray enumerateObjectsUsingBlock:^(__kindof UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < string.length) {
            obj.text = [string substringWithRange:NSMakeRange(idx, 1)];
        }else{
            obj.text = @"";
        }
    }];
}

@end
