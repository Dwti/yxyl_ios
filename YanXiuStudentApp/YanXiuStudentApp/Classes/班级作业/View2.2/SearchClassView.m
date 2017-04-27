//
//  SearchClassView.m
//  YanXiuStudentApp
//
//  Created by 贾培军 on 2016/12/21.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "SearchClassView.h"

@interface SearchClassView()

@property (nonatomic, strong) EEAlertContentBackgroundImageView *bgView;
@property (nonatomic, strong) EEAlertTipImageView *tipImageView;
@property (nonatomic, strong) EEAlertDottedLineView *lineView;
@property (nonatomic, strong) EEAlertTitleLabel *titleLabel;

@end

@implementation SearchClassView

- (void)setupUI{
    self.bgView = [[EEAlertContentBackgroundImageView alloc] init];
    
    self.tipImageView = [[EEAlertTipImageView alloc] init];
    
    self.titleLabel = [[EEAlertTitleLabel alloc] init];
    self.titleLabel.text = @"请输入 8 位数字班级号码 ^_^";
    
    self.lineView = [[EEAlertDottedLineView alloc] init];
    
    self.nextStepButton = [[EEAlertButton alloc] init];
    [self.nextStepButton setTitle:@"确认" forState:UIControlStateNormal];
    
    self.groupFiled = [[NumberInputView alloc] init];
    self.groupFiled.numberCount = 8;
    WEAK_SELF
    [self.groupFiled setTextChangeBlock:^(NSString *text) {
        STRONG_SELF
        self.text = text;
    }];
}

- (void)setupLayout{
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self addSubview:self.tipImageView];
    [self.tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(15);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tipImageView.mas_right).offset(10);
        make.top.equalTo(self.tipImageView).offset(3);
        make.right.mas_lessThanOrEqualTo(self).offset(-20);
    }];
    
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        make.right.equalTo(self).offset(-5);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
    }];
    
    [self addSubview:self.groupFiled];
    [self.groupFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(self.lineView.mas_bottom).offset(15);
        make.height.mas_equalTo(36);
    }];
    
    [self addSubview:self.nextStepButton];
    [self.nextStepButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(self.groupFiled.mas_bottom).offset(15);
        make.height.mas_equalTo(40);
    }];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

@end
