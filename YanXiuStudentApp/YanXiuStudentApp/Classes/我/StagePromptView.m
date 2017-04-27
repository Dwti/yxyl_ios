//
//  StagePromptView.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 12/21/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import "StagePromptView.h"

@interface StagePromptView ()
@property (nonatomic, strong) EEAlertTipImageView *tipImageView;
@property (nonatomic, strong) EEAlertTitleLabel *tipLabel;
@property (nonatomic, strong) EEAlertTitleLabel *subTitleLabel;
@property (nonatomic, strong) EEAlertTitleLabel *titleLabel;
@property (nonatomic, strong) EEAlertButton *editButton;
@property (nonatomic, strong) EEAlertButton *cancelButton;
@property (nonatomic, strong) EEAlertContentBackgroundImageView *bgImageView;
@property (nonatomic, strong) UIView *containerView;
@end

@implementation StagePromptView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)setupUI {
    self.containerView = [[UIView alloc] init];
    
    self.bgImageView = [[EEAlertContentBackgroundImageView alloc] init];
    
    self.tipImageView = [[EEAlertTipImageView alloc] init];
    
    self.tipLabel = [[EEAlertTitleLabel alloc] init];
    self.tipLabel.text = @"提示:";
    self.tipLabel.font = [UIFont boldSystemFontOfSize:17.f];
    
    self.subTitleLabel = [[EEAlertTitleLabel alloc] init];
    self.subTitleLabel.text = @"学段更改后，练习将切换到相应学段";
    self.subTitleLabel.font = [UIFont systemFontOfSize:13.f];
    
    self.titleLabel = [[EEAlertTitleLabel alloc] init];
    self.titleLabel.text = @"你确认要更改学段吗?";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:17.f];
    
    self.editButton = [[EEAlertButton alloc] init];
    [self.editButton setTitle:@"更改" forState:UIControlStateNormal];
    [[self.editButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        BLOCK_EXEC(self.editAction);
    }];
    
    self.cancelButton = [[EEAlertButton alloc] init];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [[self.cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        BLOCK_EXEC(self.cancelAction);
    }];
    
    [self setupLayout];
}

- (void)setupLayout {
    [self addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.containerView addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.containerView addSubview:self.tipImageView];
    [self.tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).offset(15);
        make.top.equalTo(self.containerView).offset(15);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    [self.containerView addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tipImageView.mas_right).offset(10);
        make.centerY.equalTo(self.tipImageView);
        make.right.mas_lessThanOrEqualTo(self.containerView).offset(-20);
    }];
    
    [self.containerView addSubview:self.subTitleLabel];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).offset(20);
        make.top.equalTo(self.tipLabel.mas_bottom).offset(15);
    }];
    
    [self.containerView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subTitleLabel.mas_bottom).offset(15);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.containerView addSubview:self.editButton];
    [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.bottom.equalTo(self.containerView.mas_bottom).offset(-20);
        make.left.equalTo(self.containerView).offset(15);
        make.height.mas_equalTo(42);
    }];
    
    [self.containerView addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.bottom.equalTo(self.containerView.mas_bottom).offset(-20);
        make.left.equalTo(self.editButton.mas_right).offset(26);
        make.right.equalTo(self.containerView).offset(-15);
        make.height.mas_equalTo(42);
        make.width.equalTo(self.editButton.mas_width);
    }];
}

@end
