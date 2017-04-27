//
//  NameView.m
//  YanXiuStudentApp
//
//  Created by 贾培军 on 2016/12/21.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "NameView.h"
#import "UIView+YXScale.h"

@interface NameView()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *textFieldClipsView;

@end

@implementation NameView

- (void)setupUI {
    EEAlertContentBackgroundImageView *contentView = [EEAlertContentBackgroundImageView new];
    contentView.userInteractionEnabled = YES;
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset = 0;
    }];
    
    EEAlertTipImageView *tip = [EEAlertTipImageView new];
    [tip sizeToFit];
    tip.x = 15;
    tip.y = 10;
    [contentView addSubview:tip];
    
    EEAlertTitleLabel *title = [EEAlertTitleLabel new];
    title.text = @"请输入真实姓名，确保通过老师审核";
    [contentView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(tip.mas_right).offset = 5;
        make.centerY.mas_equalTo(tip);
    }];
    
    EEAlertDottedLineView *line = [EEAlertDottedLineView new];
    [contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 5;
        make.right.offset = -5;
        make.height.offset = 2;
        make.top.mas_equalTo(tip.mas_bottom).offset = 4.5;
    }];
    
    self.containerView = [[UIView alloc] init];
    [contentView addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 20;
        make.right.offset = -20;
        make.top.mas_equalTo(line.mas_bottom).offset = 14;
        make.height.offset = 36;
    }];
    
    UIImageView *inputBGView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"输入框"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 6, 8, 6)]];
    [self.containerView addSubview:inputBGView];
    [inputBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.textFieldClipsView = [[UIView alloc] init];
    self.textFieldClipsView.clipsToBounds = YES;
    self.textFieldClipsView.backgroundColor = [UIColor clearColor];
    
    [self.containerView addSubview:self.textFieldClipsView];
    [self.textFieldClipsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
    
    self.textField = [[UITextField alloc] init];
    self.textField.text = [YXUserManager sharedManager].userModel.realname;
    self.textField.tintColor = [UIColor whiteColor];
    self.textField.defaultTextAttributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.f],
                                             NSForegroundColorAttributeName: [UIColor whiteColor],
                                             NSShadowAttributeName: [self textShadow]};
    [self.textFieldClipsView addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(21);
        make.centerY.mas_equalTo(0);
    }];

    EEAlertButton *button = [EEAlertButton new];
    button.title = @"确定";
    self.button = button;
    [contentView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 20;
        make.right.offset = -20;
        make.height.offset = 40;
        make.bottom.offset = -22;
    }];
}

- (NSShadow *)textShadow{
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0, 1); //垂直投影
    shadow.shadowColor = [UIColor colorWithRGBHex:0xa37a00];
    return shadow;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

@end
