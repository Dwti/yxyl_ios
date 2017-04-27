//
//  ChangeView.m
//  YanXiuStudentApp
//
//  Created by 贾培军 on 2016/12/21.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "ChangeView.h"

@implementation ChangeView

- (void)setupUI{
    EEAlertContentBackgroundImageView *bgView = [[EEAlertContentBackgroundImageView alloc] init];
    
    EEAlertTipImageView *tipImageView = [[EEAlertTipImageView alloc] init];
    
    EEAlertTitleLabel *titleLabel = [[EEAlertTitleLabel alloc] init];
    titleLabel.text = @"请拍照，或选择相册中的图片";
    
    EEAlertDottedLineView *lineView = [[EEAlertDottedLineView alloc] init];
    
    EEAlertButton *cameraButton = [[EEAlertButton alloc] init];
    [cameraButton setImage:[UIImage imageNamed:@"相机"] forState:UIControlStateNormal];
    cameraButton.title = @"拍照";
    self.cameraButton = cameraButton;
    
    EEAlertButton *albumButton = [[EEAlertButton alloc] init];
    [albumButton setImage:[UIImage imageNamed:@"相册"] forState:UIControlStateNormal];
    albumButton.title = @"相册";
    self.albumButton = albumButton;
    
    EEAlertButton *cancelButton = [[EEAlertButton alloc] init];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    self.cancelButton = cancelButton;
    
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self addSubview:tipImageView];
    [tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(15);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipImageView.mas_right).offset(10);
        make.top.equalTo(tipImageView).offset(3);
        make.right.mas_lessThanOrEqualTo(self).offset(-20);
    }];
    
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        make.right.equalTo(self).offset(-5);
        make.height.mas_equalTo(1);
        make.top.equalTo(titleLabel.mas_bottom).offset(8);
    }];
    
    [self addSubview:cameraButton];
    [cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(54);
        make.left.equalTo(self).offset(15);
        make.width.mas_equalTo(125);
        make.top.equalTo(lineView.mas_bottom).offset(15);
    }];
    
    [self addSubview:albumButton];
    [albumButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(54);
        make.right.equalTo(self).offset(-15);
        make.width.mas_equalTo(125);
        make.top.equalTo(lineView.mas_bottom).offset(15);
    }];
    
    [self addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(42);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.bottom.equalTo(self).offset(-15);
        make.top.mas_equalTo(84 + 32 + 10);
    }];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

@end
