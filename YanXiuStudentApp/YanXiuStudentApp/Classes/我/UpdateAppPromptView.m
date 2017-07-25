//
//  UpdateAppAlertView.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 12/20/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import "UpdateAppPromptView.h"

@interface UpdateAppPromptView ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) EEAlertTipImageView *tipImageView;
@property (nonatomic, strong) EEAlertTitleLabel *titleLabel;
@property (nonatomic, strong) EEAlertDottedLineView *lineView;
@property (nonatomic, strong) EEAlertTitleLabel *contentLabel;
@property (nonatomic, strong) EEAlertButton *updateButton;
@property (nonatomic, strong) EEAlertButton *cancelButton;
@property (nonatomic, strong) EEAlertContentBackgroundImageView *bgImageView;
@end

@implementation UpdateAppPromptView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.containerView = [[UIView alloc] init];
    
    self.bgImageView = [[EEAlertContentBackgroundImageView alloc] init];
    
    self.tipImageView = [[EEAlertTipImageView alloc] init];
    
    self.lineView = [[EEAlertDottedLineView alloc] init];
    
    self.titleLabel = [[EEAlertTitleLabel alloc] init];
    
    self.contentLabel = [[EEAlertTitleLabel alloc] init];
    
    self.cancelButton = [[EEAlertButton alloc] init];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [[self.cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        BLOCK_EXEC(self.cancelAction);
    }];
    
    self.updateButton = [[EEAlertButton alloc] init];
    [self.updateButton setTitle:@"更新" forState:UIControlStateNormal];
    [[self.updateButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        BLOCK_EXEC(self.updateAction)
    }];
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
    
    [self.containerView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tipImageView.mas_right).offset(10);
        make.top.equalTo(self.tipImageView).offset(3);
        make.right.mas_lessThanOrEqualTo(self.containerView).offset(-20);
    }];
    
    [self.containerView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).offset(5);
        make.right.equalTo(self.containerView).offset(-5);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
    }];
    
    [self.containerView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(20);
        make.right.mas_offset(-20);
        if ([self.body.content yx_isValidString]) {
            make.top.equalTo(self.lineView.mas_bottom).offset(15);
        } else {
            make.top.equalTo(self.lineView.mas_bottom).offset(0);
        }
    }];
    
//    if (![self.body isForce])
    {
        [self.containerView addSubview:self.cancelButton];
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLabel.mas_bottom).offset(15);
            make.bottom.equalTo(self.containerView.mas_bottom).offset(-20);
            make.left.equalTo(self.containerView).offset(15);
            make.height.mas_equalTo(42);
        }];
        
        [self.containerView addSubview:self.updateButton];
        [self.updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLabel.mas_bottom).offset(15);
            make.bottom.equalTo(self.containerView.mas_bottom).offset(-20);
            make.left.equalTo(self.cancelButton.mas_right).offset(26);
            make.right.equalTo(self.containerView).offset(-15);
            make.height.mas_equalTo(42);
            make.width.equalTo(self.cancelButton.mas_width);
        }];
    }
//    else {
//        [self.containerView addSubview:self.updateButton];
//        [self.updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.contentLabel.mas_bottom).offset(15);
//            make.bottom.equalTo(self.containerView.mas_bottom).offset(-20);
//            make.left.equalTo(self.containerView).offset(20);
//            make.right.equalTo(self.containerView).offset(-20);
//            make.height.mas_equalTo(42);
//        }];
//    }
}

- (void)setBody:(YXInitRequestItem_Body *)body {
    _body = body;
    
    self.titleLabel.text = body.title;
    self.contentLabel.text = body.content;
    
    [self setupLayout];
    if ([self.body isForce]) {
        [self.cancelButton setTitle:@"退出" forState:UIControlStateNormal];
    }
}

@end
