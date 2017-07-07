//
//  QAReportErrorOptionView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/28.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAReportErrorOptionView.h"

static const NSUInteger kTagBase = 10086;
static const CGFloat kButtonHeight = 45.0f;
static const CGFloat kButtonShortWidth = 120.f;
static const CGFloat kButtonLongWidth = 150.f;
static const CGFloat kHorizontalMargin = 8.0f;
static const CGFloat kVerticalMargin = 15.0f;

@implementation QAReportErrorOption
@end

@interface QAReportErrorOptionView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) NSArray *optionArray;

@property (nonatomic, copy) ErrorOptionChangeBlock block;

@end
@implementation QAReportErrorOptionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupOptionArray];
        self.optionSelectedArray = [NSMutableArray array];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    self.titleLabel.text = @"错误类型";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"89e00d"];
    
    self.contentView = [[UIView alloc]init];
    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"cccccc"];

    
    [self addSubview:self.titleLabel];
    [self addSubview:self.contentView];
    [self addSubview:self.lineView];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.mas_equalTo(13.0f);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(11.0f);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-15.0f);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1.0f / [UIScreen mainScreen].scale);
    }];
    
    [self setupOptionView];
}

- (void)setupOptionArray {
    self.optionArray = @[
                         @"题干有误",
                         @"答案有误",
                         @"解析有误",
                         @"章节信息有误",
                         @"知识点有误",
                         @"其他错误"
                         ];
}

- (void)setupOptionView {
    [self.optionArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [self createButtonWithTitle:obj];
        button.tag = idx + kTagBase;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        CGFloat centerX = SCREEN_WIDTH / 2;
        NSUInteger row = idx / 2 ;
        CGFloat width;
        if (button.titleLabel.text.length >= 5) {
            width = kButtonLongWidth * kPhoneWidthRatio;
        }else {
            width = kButtonShortWidth * kPhoneWidthRatio;
        }
        if ((idx + 1)%2 == 1) {
            button.frame = CGRectMake(centerX - kHorizontalMargin - width, (kButtonHeight + kVerticalMargin)* row ,width , kButtonHeight);
        }else {
            button.frame = CGRectMake(centerX + kHorizontalMargin, (kButtonHeight + kVerticalMargin)* row,width , kButtonHeight);
        }
    }];
}

- (UIButton *)createButtonWithTitle:(NSString *)title {
    UIButton *button = [[UIButton alloc]init];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    button.layer.cornerRadius = 6.0f;
    button.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
    button.layer.borderWidth = 2.0f;
    button.clipsToBounds = YES;
    return button;
}

- (void)buttonAction:(UIButton *)sender {
    BOOL selected = !sender.selected;
    if (selected) {
        [sender setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        sender.backgroundColor = [UIColor colorWithHexString:@"89e00d"];
        sender.layer.borderColor = [UIColor colorWithHexString:@"89e00d"].CGColor;
        if (self.optionSelectedArray.count == 0) {
            QAReportErrorOption *option = [[QAReportErrorOption alloc]init];
            option.title = sender.titleLabel.text;
            option.tag = sender.tag;
            [self.optionSelectedArray addObject:option];
        }else {
            [self.optionSelectedArray enumerateObjectsUsingBlock:^(QAReportErrorOption * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.tag == sender.tag) {
                    *stop = YES;
                }else {
                    QAReportErrorOption *option = [[QAReportErrorOption alloc]init];
                    option.title = sender.titleLabel.text;
                    option.tag = sender.tag;
                    [self.optionSelectedArray addObject:option];
                    *stop = YES;
                }
            }];
        }
    }else {
        [sender setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        sender.backgroundColor = [UIColor clearColor];
        sender.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
        [self.optionSelectedArray enumerateObjectsUsingBlock:^(QAReportErrorOption * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.tag == sender.tag) {
                [self.optionSelectedArray removeObject:obj];
                *stop = YES;
            }
        }];
    }
    sender.selected = selected;
    BLOCK_EXEC(self.block);
}

-(void)setErrorOptionChangeBlock:(ErrorOptionChangeBlock)block {
    self.block = block;
}

@end
