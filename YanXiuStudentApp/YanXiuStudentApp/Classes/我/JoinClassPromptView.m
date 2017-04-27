//
//  JoinClassPromptView.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 12/21/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import "JoinClassPromptView.h"
#import "TextInputView.h"

@interface JoinClassPromptView ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) EEAlertTitleLabel *schoolNameLabel;
@property (nonatomic, strong) EEAlertTitleLabel *classNameLabel;
@property (nonatomic, strong) EEAlertTitleLabel *teacherNameLabel;
@property (nonatomic, strong) EEAlertDottedLineView *lineView;
@property (nonatomic, strong) EEAlertTipImageView *tipsView;
@property (nonatomic, strong) EEAlertButton *joinClassButton;
@property (nonatomic, strong) EEAlertContentBackgroundImageView *contentBGView;
@end

@implementation JoinClassPromptView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self registerNotification];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)setupUI {
    self.containerView = [[UIView alloc] init];
    [self addSubview:self.containerView];
    
    self.contentBGView = [[EEAlertContentBackgroundImageView alloc] init];
    
    self.schoolNameLabel = [[EEAlertTitleLabel alloc] init];
    self.schoolNameLabel.font = [UIFont systemFontOfSize:12];
    
    self.classNameLabel = [[EEAlertTitleLabel alloc] init];
    self.classNameLabel.font = [UIFont systemFontOfSize:12];
    
    self.teacherNameLabel = [[EEAlertTitleLabel alloc] init];
    self.teacherNameLabel.font = [UIFont systemFontOfSize:12];
    
    self.tipsView = [[EEAlertTipImageView alloc] init];
    
    self.lineView = [[EEAlertDottedLineView alloc] init];
    
    self.inputView = [[TextInputView alloc] init];
    self.inputView.placeholder = @"老师需要知道你的真实姓名，请输入";
    self.inputView.maxInputLength = 25;
    
    self.joinClassButton = [[EEAlertButton alloc] init];
    self.joinClassButton.enabled = NO;
    [self.joinClassButton setTitle:@"加入班级" forState:UIControlStateNormal];
    [[self.joinClassButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        BLOCK_EXEC(self.joinAction);
    }];
}

- (void)setupLayout {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.containerView addSubview:self.contentBGView];
    [self.contentBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.containerView addSubview:self.schoolNameLabel];
    [self.schoolNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_top).mas_offset(15);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.containerView addSubview:self.classNameLabel];
    [self.classNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.schoolNameLabel.mas_bottom).mas_offset(10);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.containerView addSubview:self.teacherNameLabel];
    [self.teacherNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.classNameLabel.mas_bottom).mas_offset(10);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.containerView addSubview:self.tipsView];
    [self.tipsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).offset(15);
        make.top.equalTo(self.containerView).offset(15);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    [self.containerView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.teacherNameLabel.mas_bottom).offset(10);
        make.left.equalTo(self.containerView.mas_left).offset(5);
        make.right.equalTo(self.containerView.mas_right).offset(-5);
        make.height.mas_equalTo(1);
    }];
    
    [self.containerView addSubview:self.inputView];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(13);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(36);
    }];
    
    [self.containerView addSubview:self.joinClassButton];
    [self.joinClassButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputView.mas_bottom).offset(13);
        make.width.equalTo(self.inputView.mas_width);
        make.centerX.equalTo(self.inputView.mas_centerX);
        make.height.mas_equalTo(40);
        make.bottom.equalTo(self.containerView.mas_bottom).offset(-15);
    }];
}

- (void)setRawData:(YXSearchClassItem_Data *)rawData {
    _rawData = rawData;
    
    self.schoolNameLabel.text = [NSString stringWithFormat:@"学校: %@", [rawData.schoolname yx_safeString]];
    self.classNameLabel.text = [NSString stringWithFormat:@"班级: %@%@班", [rawData.gradename yx_safeString], [rawData.name yx_safeString]];
    self.teacherNameLabel.text = [NSString stringWithFormat:@"老师: %@", [rawData.adminName yx_safeString]];
}

- (void)registerNotification {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UITextFieldTextDidChangeNotification object:nil] subscribeNext:^(id x) {
        STRONG_SELF;
        [self textDidChange];
    }];
}

- (void)textDidChange {
    self.joinClassButton.enabled = [self.inputView.text length] != 0;
}

@end
