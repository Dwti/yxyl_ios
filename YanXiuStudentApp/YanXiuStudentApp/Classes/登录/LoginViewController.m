//
//  LoginViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/8.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "LoginViewController.h"
#import "AccountInputView.h"
#import "PasswordInputView.h"
#import "LoginActionView.h"
#import "ThirdLoginView.h"
#import "ForgotPasswordViewController.h"

@interface LoginViewController ()
@property (nonatomic, strong) AccountInputView *accountView;
@property (nonatomic, strong) PasswordInputView *passwordView;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    self.accountView = [[AccountInputView alloc]init];
    [containerView addSubview:self.accountView];
    [self.accountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    self.passwordView = [[PasswordInputView alloc]init];
    [containerView addSubview:self.passwordView];
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.accountView.mas_bottom).mas_offset(1);
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    LoginActionView *loginView = [[LoginActionView alloc]init];
    loginView.title = @"登 录";
    WEAK_SELF
    [loginView setActionBlock:^{
        STRONG_SELF
    }];
    [self.contentView addSubview:loginView];
    [loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(containerView.mas_left);
        make.right.mas_equalTo(containerView.mas_right);
        make.top.mas_equalTo(containerView.mas_bottom).mas_offset(15);
        make.height.mas_equalTo(50);
    }];
    UIButton *forgotPasswordButton = [[UIButton alloc]init];
    [forgotPasswordButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgotPasswordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [forgotPasswordButton setTitleColor:[UIColor colorWithHexString:@"336600"] forState:UIControlStateHighlighted];
    forgotPasswordButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [forgotPasswordButton addTarget:self action:@selector(gotoForgotPassword) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:forgotPasswordButton];
    [forgotPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(loginView.mas_left);
        make.top.mas_equalTo(loginView.mas_bottom).mas_offset(15);
    }];
    UIButton *registerButton = [forgotPasswordButton clone];
    [registerButton setTitle:@"快速注册!" forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(gotoRegister) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:registerButton];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(loginView.mas_right);
        make.top.mas_equalTo(forgotPasswordButton.mas_top);
    }];
    UIButton *touristButton = [forgotPasswordButton clone];
    [touristButton setTitle:@"游客登录" forState:UIControlStateNormal];
    [touristButton addTarget:self action:@selector(gotoTouristLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:touristButton];
    [touristButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(forgotPasswordButton.mas_top);
        make.centerX.mas_equalTo(0);
    }];
    ThirdLoginView *thirdView = [[ThirdLoginView alloc]init];
    [thirdView setLoginAction:^(ThirdLoginType type) {
        STRONG_SELF
    }];
    [self.contentView addSubview:thirdView];
    [thirdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(loginView.mas_left);
        make.right.mas_equalTo(loginView.mas_right);
        make.top.mas_equalTo(loginView.mas_bottom).mas_offset(75*kPhoneWidthRatio);
        make.bottom.mas_equalTo(-40);
    }];
}

- (void)gotoForgotPassword {
    ForgotPasswordViewController *vc = [[ForgotPasswordViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoRegister {
    
}

- (void)gotoTouristLogin {
    
}

@end
