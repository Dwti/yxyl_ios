//
//  QAInputAccessoryView.m
//  YanXiuStudentApp
//
//  Created by LiuWenXing on 2017/6/12.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAInputAccessoryView.h"

@interface QAInputAccessoryView ()<UITextViewDelegate>

@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UILabel *placeHolderLabel;

@end

@implementation QAInputAccessoryView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupLayout];
        [self setupObserver];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI {
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    
    self.topLine = [[UIView alloc] init];
    self.topLine.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
    [self addSubview:self.topLine];
    self.bottomLine = [[UIView alloc] init];
    self.bottomLine.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
    [self addSubview:self.bottomLine];
    
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    self.confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    [self.confirmButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateDisabled];
    [self.confirmButton setTitleColor:[UIColor colorWithHexString:@"89e00d"] forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.confirmButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"89e00d"] rect:CGRectMake(0, 0, 50.0f, 28.0f)] forState:UIControlStateHighlighted];
    self.confirmButton.layer.cornerRadius = 6.0f;
    self.confirmButton.layer.borderWidth = 2.0f;
    self.confirmButton.clipsToBounds = YES;
    [self.confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    self.confirmButton.enabled = NO;
    [self addSubview:self.confirmButton];
    
    
    self.inputTextView = [[UITextView alloc] init];
    self.inputTextView.delegate = self;
    self.inputTextView.layer.cornerRadius = 6.0f;
    self.inputTextView.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
    self.inputTextView.layer.borderWidth = 0.5f;
    self.inputTextView.textContainerInset = UIEdgeInsetsMake(8.5f, 15.0f, 8.5f, 15.0f);
    self.inputTextView.tintColor = [UIColor colorWithHexString:@"89e00d"];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5.0f;
    self.inputTextView.typingAttributes = @{
                                            NSFontAttributeName : [UIFont systemFontOfSize:15.0f],
                                            NSParagraphStyleAttributeName : paragraphStyle,
                                            NSForegroundColorAttributeName : [UIColor colorWithHexString:@"333333"]
                                            };
    [self addSubview:self.inputTextView];
    
    self.placeHolderLabel = [[UILabel alloc] init];
    self.placeHolderLabel.font = [UIFont systemFontOfSize:15.0f];
    self.placeHolderLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.placeHolderLabel.text = @"开始作答...";
    [self.inputTextView addSubview:self.placeHolderLabel];
}

- (void)setupLayout {
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self);
        make.height.mas_equalTo(0.5f);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self);
        make.height.mas_equalTo(0.5f);
    }];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(-15.0f);
        make.width.mas_equalTo(50.0f);
    }];
    [self.inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15.0f);
        make.top.offset(10.0f);
        make.bottom.offset(-10.0f);
        make.right.mas_equalTo(self.confirmButton.mas_left).offset(-15.0f);
    }];
    [self.placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(25.0f);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
}

- (void)setupObserver {
    WEAK_SELF
    [RACObserve(self.inputTextView, text) subscribeNext:^(NSString *text) {
        STRONG_SELF
        [self changeStateByText:text];
        [self layoutIfNeeded];
        [self invalidateIntrinsicContentSize];
    }];
}

- (void)confirmAction:(UIButton *)sender {
    self.confirmBlock();
}

- (void)changeStateByText:(NSString *)text {
    if (text.length > 0) {
        self.confirmButton.enabled = YES;
        self.confirmButton.layer.borderColor = [UIColor colorWithHexString:@"89e00d"].CGColor;
        self.placeHolderLabel.hidden = YES;
    } else {
        self.confirmButton.enabled = NO;
        self.confirmButton.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
        self.placeHolderLabel.hidden = NO;
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    [self invalidateIntrinsicContentSize];
    [self changeStateByText:textView.text];
}

- (CGSize)intrinsicContentSize {
    CGSize textSize = self.inputTextView.contentSize;
    if (self.inputTextView.text.length > 0) {
        self.placeHolderLabel.hidden = YES;
        CGFloat textHeight = textSize.height;
        if (textHeight > 81.0f) {
            textSize.height = 112.0f;
        } else {
            textSize.height = textHeight + 20.0f;
            CGRect inputTextBounds = self.inputTextView.bounds;
            inputTextBounds.size = self.inputTextView.contentSize;
            self.inputTextView.bounds = inputTextBounds;
            [self.inputTextView scrollRangeToVisible:NSMakeRange(self.inputTextView.text.length - 1, 1)];
        }
    } else {
        textSize.height = 55.0f;
    }
    return CGSizeMake(self.bounds.size.width, textSize.height);
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
