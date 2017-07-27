//
//  MistakeRedoReportView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/2/15.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "MistakeRedoReportView.h"

@interface MistakeRedoReportView()
//@property (nonatomic, strong) EEAlertTitleLabel *contentLabel;
@end

@implementation MistakeRedoReportView

//- (instancetype)initWithFrame:(CGRect)frame {
//    if (self = [super initWithFrame:frame]) {
//        [self setupUI];
//    }
//    return self;
//}
//
//- (void)setupUI {
//    EEAlertContentBackgroundImageView *bgImageView = [[EEAlertContentBackgroundImageView alloc] init];
//    [self addSubview:bgImageView];
//    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(0);
//    }];
//    
//    EEAlertTitleLabel *titleLabel = [[EEAlertTitleLabel alloc] init];
//    titleLabel.text = @"重做练习报告";
//    titleLabel.font = [UIFont boldSystemFontOfSize:17.f];
//    [self addSubview:titleLabel];
//    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        //make.left.equalTo(tipImageView.mas_right).offset(10);
//        make.centerX.mas_equalTo(0);
//        make.top.equalTo(self).offset(15);
//        //make.right.mas_equalTo(-20);
//    }];
//    
//    self.contentLabel = [[EEAlertTitleLabel alloc] init];
//    self.contentLabel.font = [UIFont systemFontOfSize:13.f];
//    self.contentLabel.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:self.contentLabel];
//    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(20);
//        make.right.mas_equalTo(-20);
//        make.top.equalTo(titleLabel.mas_bottom).offset(15);
//    }];
//    
//    EEAlertButton *continueButton = [[EEAlertButton alloc] init];
//    [continueButton setTitle:@"继续作答" forState:UIControlStateNormal];
//    WEAK_SELF
//    [[continueButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        STRONG_SELF
//        BLOCK_EXEC(self.continueAction);
//    }];
//    [self addSubview:continueButton];
//    [continueButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentLabel.mas_bottom).offset(20);
//        make.bottom.equalTo(self.mas_bottom).offset(-20);
//        make.left.equalTo(self).offset(15);
//        make.height.mas_equalTo(42);
//    }];
//    
//    EEAlertButton *exitButton = [[EEAlertButton alloc] init];
//    [exitButton setTitle:@"退出" forState:UIControlStateNormal];
//    [[exitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        STRONG_SELF
//        BLOCK_EXEC(self.exitAction);
//    }];
//    [self addSubview:exitButton];
//    [exitButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(continueButton.mas_centerY);
//        make.height.mas_equalTo(continueButton.mas_height);
//        make.left.equalTo(continueButton.mas_right).offset(26);
//        make.right.equalTo(self).offset(-15);
//        make.width.mas_equalTo(continueButton.mas_width);
//    }];
//}
//
//- (void)setReportString:(NSString *)reportString {
//    _reportString = reportString;
//    self.contentLabel.text = reportString;
//}

@end
