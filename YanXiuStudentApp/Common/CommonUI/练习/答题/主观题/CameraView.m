//
//  CameraView.m
//  YanXiuStudentApp
//
//  Created by 贾培军 on 2016/11/16.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "CameraView.h"
#import "PrefixHeader.pch"

@interface CameraView()

@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation CameraView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    UIView *navigationBar = [UIView new];
    navigationBar.backgroundColor = [[UIColor colorWithRGBHex:0x000000] colorWithAlphaComponent:0.3];
    [self addSubview:navigationBar];
    [navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset = 0;
        make.height.offset = 44;
    }];
    
    UIButton *closeButton = [UIButton new];
    self.closeButton = closeButton;
    [closeButton setImage:[UIImage imageNamed:@"关闭取消按钮"] forState:UIControlStateNormal];
    [navigationBar addSubview:closeButton];
    WEAK_SELF
    [[closeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        [self.viewController dismissViewControllerAnimated:YES completion:nil];
    }];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 5;
        make.centerY.offset = 0;
        make.width.height.mas_equalTo(20);
    }];
    self.closeButton = closeButton;

    
    UIView *toolBar = [UIView new];
    toolBar.backgroundColor = [[UIColor colorWithRGBHex:0x000000] colorWithAlphaComponent:0.3];
    [self addSubview:toolBar];
    [toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset = 0;
        make.height.offset = 110;
    }];
    
    UIButton *albumButton = [UIButton new];
    albumButton.backgroundColor = [[UIColor colorWithRGBHex:0x000000] colorWithAlphaComponent:0.3];
    [albumButton setTitle:@"相册" forState:UIControlStateNormal];
    [albumButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    albumButton.layer.cornerRadius = 20;
    albumButton.layer.masksToBounds = YES;
    albumButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [[albumButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        if (self.album) {
            self.album();
        }
    }];
    [toolBar addSubview:albumButton];
    [albumButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.width.height.offset = 40;
        make.centerY.offset = 0;
    }];
    
    UIButton *cameraButton = [UIButton new];
    [cameraButton setImage:[UIImage imageNamed:@"拍照"] forState:UIControlStateNormal];
    [toolBar addSubview:cameraButton];
    [[cameraButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        if (self.camera) {
            self.camera();
        }
    }];
    [cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset = 0;
    }];
}

#pragma mark-
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    CGRect rect = CGRectMake(0, 0, 100, 100);
    if (CGRectContainsPoint(rect, point)) {
        return self.closeButton;
    }
    return [super hitTest:point withEvent:event];
}

@end
