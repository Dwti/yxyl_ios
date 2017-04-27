//
//  NumberInputView.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 12/22/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import "NumberInputView.h"
#import "UIView+YXScale.h"


@interface ExtendTextfield : UITextField
@end
@implementation ExtendTextfield
- (void)deleteBackward {
    [super deleteBackward];
    [self.delegate textField:self shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@""];
}
@end


static const NSInteger kLabelTagBase = 555;

@interface NumberInputView () <UITextFieldDelegate>
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) ExtendTextfield *inputField;
@property (nonatomic, strong) NSMutableArray<__kindof UILabel *> *labelArray;
@property (nonatomic, assign) NSInteger inputPositionIndex;
@end

@implementation NumberInputView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
    }
    return self;
}

- (void)setNumberCount:(NSInteger)numberCount {
    if (numberCount < 1) {
        return;
    }
    _numberCount = numberCount;
    [self setupUI];
}

- (void)setupUI {
    self.backImageView = [UIImageView new];
    self.backImageView.image = [UIImage yx_resizableImageNamed:@"输入框"];
    [self addSubview:self.backImageView];
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];

    CGFloat width = (306 * [UIView scale]-40) / self.numberCount;
    
    self.labelArray = [NSMutableArray array];
    for (NSInteger i=0; i<self.numberCount; i++) {
        UILabel *lb = [[UILabel alloc] init];
        lb.tag = kLabelTagBase+i;
        lb.textColor = [UIColor whiteColor];
        lb.tintColor = [UIColor whiteColor];
        lb.textAlignment = NSTextAlignmentCenter;
        lb.layer.shadowColor = [[UIColor colorWithHexString:@"a37a00"] CGColor];
        lb.layer.shadowOffset = CGSizeMake(0, 1);
        lb.font = [UIFont fontWithName:YXFontMetro_Bold size:22.f];
        lb.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTapAction:)];
        [lb addGestureRecognizer:tap];
        [self addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(width);
            make.left.mas_equalTo(width * i);
        }];
        [self.labelArray addObject:lb];
    }
    self.inputField = [[ExtendTextfield alloc] init];
    self.inputField.textColor = [UIColor clearColor];
    self.inputField.keyboardType = UIKeyboardTypeNumberPad;
    self.inputField.textAlignment = NSTextAlignmentCenter;
    self.inputField.delegate = self;
    self.inputPositionIndex = 0;
    [self addSubview:self.inputField];
    [self.inputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo([self.labelArray firstObject]).offset(0);
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
    if (string.length > 0) { // input
        if (![self canInput]) {
            return NO;
        }
        NSInteger index = self.inputPositionIndex;
        if (range.location>0) {
            index++;
        }
        [self updateLabelsWithRange:NSMakeRange(index, 0) replacementString:string];
        self.inputPositionIndex++;
        if (![self canInput]) {
            [self.inputField resignFirstResponder];
            [self.inputField removeFromSuperview];
            self.inputPositionIndex = -1;
        }else{
            [self updateFieldWithPosition:self.inputPositionIndex];
        }
    }else { // delete
        if (![self canDeleteWithRange:range]) {
            return NO;
        }
        NSInteger index = self.inputPositionIndex;
        if (range.length==0) {
            index--;
        }
        [self updateLabelsWithRange:NSMakeRange(index, 1) replacementString:@""];
        self.inputPositionIndex--;
        self.inputPositionIndex = MAX(self.inputPositionIndex, 0);
        [self updateFieldWithPosition:self.inputPositionIndex];
    }
    return NO;
}

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
