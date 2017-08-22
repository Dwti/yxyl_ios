//
//  HeadImageCameraOverlayView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/17.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "HeadImageCameraOverlayView.h"

@interface HeadImageCameraOverlayView()
@property (nonatomic, strong) UIButton *switchButton;
@end

@implementation HeadImageCameraOverlayView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIView *containerView = [[UIView alloc]init];
    containerView.backgroundColor = [[UIColor colorWithHexString:@"cccccc"]colorWithAlphaComponent:0.5];
    [self addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(123);
    }];
    UIButton *switchButton = [[UIButton alloc]init];
    switchButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    switchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    switchButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    [switchButton setBackgroundImage:[UIImage imageNamed:@"镜头旋转icon正常态-"] forState:UIControlStateNormal];
    [switchButton setBackgroundImage:[UIImage imageNamed:@"镜头转换icon点击态"] forState:UIControlStateHighlighted];
    [switchButton addTarget:self action:@selector(switchAction) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:switchButton];
    [switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30*kPhoneWidthRatio);
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.centerY.mas_equalTo(0);
    }];
    self.switchButton = switchButton;
    
    UIView *cameraBottomView = [[UIView alloc]init];
    cameraBottomView.backgroundColor = [UIColor whiteColor];
    cameraBottomView.layer.cornerRadius = 33;
    cameraBottomView.layer.borderWidth = 5;
    cameraBottomView.layer.borderColor = [UIColor colorWithHexString:@"89e00d"].CGColor;
    cameraBottomView.clipsToBounds = YES;
    [containerView addSubview:cameraBottomView];
    [cameraBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(66, 66));
    }];
    UIButton *cameraButton = [[UIButton alloc]init];
    [cameraButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"89e00d"]] forState:UIControlStateNormal];
    [cameraButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"69ad0a"]] forState:UIControlStateHighlighted];
    [cameraButton addTarget:self action:@selector(cameraAction) forControlEvents:UIControlEventTouchUpInside];
    cameraButton.layer.cornerRadius = 25;
    cameraButton.clipsToBounds = YES;
    [cameraBottomView addSubview:cameraButton];
    [cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    UIButton *exitButton = [[UIButton alloc]init];
    [exitButton setBackgroundImage:[UIImage imageNamed:@"关闭拍照页面icon正常态"] forState:UIControlStateNormal];
    [exitButton setBackgroundImage:[UIImage imageNamed:@"关闭拍照页面icon点击态"] forState:UIControlStateHighlighted];
    [exitButton addTarget:self action:@selector(exitAction) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:exitButton];
    [exitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-53*kPhoneWidthRatio);
        make.size.mas_equalTo(CGSizeMake(26, 26));
        make.centerY.mas_equalTo(0);
    }];
}

- (void)switchAction {
    BLOCK_EXEC(self.switchBlock);
}

- (void)cameraAction {
    BLOCK_EXEC(self.cameraBlock);
}

- (void)exitAction {
    BLOCK_EXEC(self.exitBlock);
}

@end
