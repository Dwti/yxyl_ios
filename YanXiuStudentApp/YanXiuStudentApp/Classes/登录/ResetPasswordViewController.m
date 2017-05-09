//
//  ResetPasswordViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/9.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "PasswordInputView.h"
#import "LoginActionView.h"

@interface ResetPasswordViewController ()
@property (nonatomic, strong) PasswordInputView *passwordView;
@property (nonatomic, strong) PasswordInputView *confirmPasswordView;
@property (nonatomic, strong) LoginActionView *resetPasswordView;
@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"重置密码";
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    UIImageView *topImageView = [[UIImageView alloc]init];
    topImageView.backgroundColor = [UIColor redColor];
    topImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:topImageView];
    [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(200*kPhoneWidthRatio);
    }];
    UIView *containerView = [[UIView alloc]init];
    containerView.layer.cornerRadius = 5;
    containerView.clipsToBounds = YES;
    [self.contentView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topImageView.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(35*kPhoneWidthRatio);
        make.right.mas_equalTo(-35*kPhoneWidthRatio);
    }];
    self.passwordView = [[PasswordInputView alloc]init];
    self.passwordView.inputView.placeHolder = @"请输入6~18位密码";
    WEAK_SELF
    [self.passwordView setTextChangeBlock:^{
        STRONG_SELF
        [self refreshResetPasswordView];
    }];
    [containerView addSubview:self.passwordView];
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    self.confirmPasswordView = [[PasswordInputView alloc]init];
    self.confirmPasswordView.inputView.placeHolder = @"请输入6~18位密码";
    [self.confirmPasswordView setTextChangeBlock:^{
        STRONG_SELF
        [self refreshResetPasswordView];
    }];
    [containerView addSubview:self.confirmPasswordView];
    [self.confirmPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.passwordView.mas_bottom).mas_offset(1);
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    self.resetPasswordView = [[LoginActionView alloc]init];
    self.resetPasswordView.title = @"下一步";
    [self.resetPasswordView setActionBlock:^{
        STRONG_SELF
    }];
    [self.contentView addSubview:self.resetPasswordView];
    [self.resetPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(containerView.mas_left);
        make.right.mas_equalTo(containerView.mas_right);
        make.top.mas_equalTo(containerView.mas_bottom).mas_offset(15);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(-40);
    }];
    
    [self refreshResetPasswordView];
}

- (void)refreshResetPasswordView {
    if (!isEmpty([self.passwordView text])&&!isEmpty([self.confirmPasswordView text])) {
        self.resetPasswordView.isActive = YES;
    }else {
        self.resetPasswordView.isActive = NO;
    }
}

@end
