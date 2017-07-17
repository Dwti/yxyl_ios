//
//  HeadImagePickerOptionView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/19.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "HeadImagePickerOptionView.h"
#import "HeadImagePickerOptionItemView.h"

@implementation HeadImagePickerOptionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor colorWithHexString:@"89e00d"];
    bgView.layer.cornerRadius = 6;
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(6);
    }];
    UIButton *cancelButton = [[UIButton alloc]init];
    [cancelButton setTitle:@"取 消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.76] forState:UIControlStateHighlighted];
    cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:21];
    [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(60);
    }];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"81d404"];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(cancelButton.mas_top);
        make.height.mas_equalTo(1);
    }];
    
    HeadImagePickerOptionItemView *albumView = [[HeadImagePickerOptionItemView alloc]init];
    [albumView updateWithImage:[UIImage imageNamed:@"相册icon正常态"] highlightImage:[UIImage imageNamed:@"相册icon点击态"] title:@"相册"];
    WEAK_SELF
    [albumView setActionBlock:^{
        STRONG_SELF
        BLOCK_EXEC(self.albumBlock);
    }];
    [self addSubview:albumView];
    [albumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(26);
        make.right.mas_equalTo(self.mas_centerX).mas_offset(-30*kPhoneWidthRatio);
        make.size.mas_equalTo(CGSizeMake(95, 120));
    }];
    
    HeadImagePickerOptionItemView *cameraView = [[HeadImagePickerOptionItemView alloc]init];
    [cameraView updateWithImage:[UIImage imageNamed:@"拍照icon正常态"] highlightImage:[UIImage imageNamed:@"拍照icon点击态"] title:@"拍照"];
    [cameraView setActionBlock:^{
        STRONG_SELF
        BLOCK_EXEC(self.cameraBlock);
    }];
    [self addSubview:cameraView];
    [cameraView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(26);
        make.left.mas_equalTo(self.mas_centerX).mas_offset(30*kPhoneWidthRatio);
        make.size.mas_equalTo(CGSizeMake(95, 120));
    }];
}

- (void)cancelAction {
    BLOCK_EXEC(self.cancelBlock);
}

@end
