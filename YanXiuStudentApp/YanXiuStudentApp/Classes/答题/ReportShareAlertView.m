//
//  ReportShareAlertView.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 12/21/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import "ReportShareAlertView.h"
#import "YXShareManager.h"

@interface ReportShareAlertView ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) EEAlertTitleLabel *titleLabel;
@property (nonatomic, strong) EEAlertTipImageView *tipImageView;
@property (nonatomic, strong) EEAlertDottedLineView *lineView;
@property (nonatomic, strong) EEAlertContentBackgroundImageView *bgView;
@property (nonatomic, strong) EEAlertButton *qqButton;
@property (nonatomic, strong) EEAlertButton *qzoneButton;
@property (nonatomic, strong) EEAlertButton *wechatButton;
@property (nonatomic, strong) EEAlertButton *timelineButton;
@property (nonatomic, strong) EEAlertButton *cancelButton;
@end

@implementation ReportShareAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)setupUI {
    self.containerView = [[UIView alloc] init];
    
    self.bgView = [[EEAlertContentBackgroundImageView alloc] init];
    
    self.tipImageView = [[EEAlertTipImageView alloc] init];
    
    self.titleLabel = [[EEAlertTitleLabel alloc] init];
    self.titleLabel.text = @"分享到";
    
    self.lineView = [[EEAlertDottedLineView alloc] init];
    
    self.qqButton = [[EEAlertButton alloc] init];
    [self.qqButton setImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
    self.qqButton.tag = 0;
    [[self.qqButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        BLOCK_EXEC(self.shareAction, self.qqButton);
    }];
    
    self.qzoneButton = [[EEAlertButton alloc] init];
    [self.qzoneButton setImage:[UIImage imageNamed:@"qzone"] forState:UIControlStateNormal];
    self.qzoneButton.tag = 1;
    [[self.qzoneButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        BLOCK_EXEC(self.shareAction, self.qzoneButton);
    }];
    
    self.wechatButton = [[EEAlertButton alloc] init];
    [self.wechatButton setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateNormal];
    self.wechatButton.tag = 2;
    [[self.wechatButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        BLOCK_EXEC(self.shareAction, self.wechatButton);
    }];
    
    self.timelineButton = [[EEAlertButton alloc] init];
    [self.timelineButton setImage:[UIImage imageNamed:@"朋友圈"] forState:UIControlStateNormal];
    self.timelineButton.tag = 3;
    [[self.timelineButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        BLOCK_EXEC(self.shareAction, self.timelineButton);
    }];
    
    self.cancelButton = [[EEAlertButton alloc] init];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [[self.cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        BLOCK_EXEC(self.cancelAction);
    }];
}

- (void)setupLayout {
    [self addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.containerView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
    }];
    
    if ([YXShareManager isWXAppSupport] && ![YXShareManager isQQSupport]) {
        [self.containerView addSubview:self.wechatButton];
        [self.wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(54);
            make.left.equalTo(self.containerView).offset(15);
            make.width.mas_equalTo(125);
            make.top.equalTo(self.lineView.mas_bottom).offset(15);
        }];
        
        [self.containerView addSubview:self.timelineButton];
        [self.timelineButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(54);
            make.right.equalTo(self.containerView).offset(-15);
            make.width.mas_equalTo(125);
            make.top.equalTo(self.lineView.mas_bottom).offset(15);
        }];
    }
    
    if ([YXShareManager isQQSupport] && ![YXShareManager isWXAppSupport]) {
        [self.containerView addSubview:self.qqButton];
        [self.qqButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(54);
            make.left.equalTo(self.containerView).offset(15);
            make.width.mas_equalTo(125);
            make.top.equalTo(self.lineView.mas_bottom).offset(15);
        }];
        
        [self.containerView addSubview:self.qzoneButton];
        [self.qzoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(54);
            make.right.equalTo(self.containerView).offset(-15);
            make.width.mas_equalTo(125);
            make.top.equalTo(self.lineView.mas_bottom).offset(15);
        }];
    }
    
    if ([YXShareManager isQQSupport] && [YXShareManager isWXAppSupport]) {
        CGFloat gap = (306 - 15 - 15 - 54 * 4) / 3;
        
        [self.containerView addSubview:self.wechatButton];
        [self.wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(54);
            make.left.equalTo(self.containerView).offset(15);
            make.width.mas_equalTo(54);
            make.top.equalTo(self.lineView.mas_bottom).offset(15);
        }];
        
        [self.containerView addSubview:self.timelineButton];
        [self.timelineButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(54);
            make.left.equalTo(self.containerView).offset(15+54+gap);
            make.width.mas_equalTo(54);
            make.top.equalTo(self.lineView.mas_bottom).offset(15);
        }];
        
        [self.containerView addSubview:self.qqButton];
        [self.qqButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(54);
            make.right.equalTo(self.containerView).offset(-(15+54+gap));
            make.width.mas_equalTo(54);
            make.top.equalTo(self.lineView.mas_bottom).offset(15);
        }];
        
        [self.containerView addSubview:self.qzoneButton];
        [self.qzoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(54);
            make.right.equalTo(self.containerView).offset(-15);
            make.width.mas_equalTo(54);
            make.top.equalTo(self.lineView.mas_bottom).offset(15);
        }];
    }
    
    [self.containerView addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(42);
        make.left.equalTo(self.containerView).offset(15);
        make.right.equalTo(self.containerView).offset(-15);
        make.bottom.equalTo(self.containerView).offset(-15);
        make.top.mas_equalTo(84 + 32 + 10);
    }];
}


@end
