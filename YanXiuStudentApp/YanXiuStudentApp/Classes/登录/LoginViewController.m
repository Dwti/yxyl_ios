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
#import "RegisterViewController.h"
#import "AddClassViewController.h"
#import "YXSSOAuthManager.h"
#import "YXInitRequest.h"

@interface LoginViewController ()
@property (nonatomic, strong) AccountInputView *accountView;
@property (nonatomic, strong) PasswordInputView *passwordView;
@property (nonatomic, strong) LoginActionView *loginView;
@property (nonatomic, strong) UIButton *touristButton;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self nyx_setupLeftWithCustomView:[UIView new]];
    [self setupUI];
    [self setupObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupObserver {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:YXInitSuccessNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        self.touristButton.hidden = ![[YXInitHelper sharedHelper] isAppleChecking];
    }];
    [YXSSOAuthManager sharedManager].thirdRegisterBlock = ^(UIViewController *rootViewController, NSDictionary *params) {
        AddClassViewController *vc = [[AddClassViewController alloc] init];
        vc.thirdLoginParams = params;
        vc.isThirdLogin = YES;
        [rootViewController.navigationController pushViewController:vc animated:YES];
    };
}

- (void)setupUI {
    UIImageView *topImageView = [[UIImageView alloc]init];
    topImageView.image = [UIImage imageNamed:@"登录注册页头图"];
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
    WEAK_SELF
    [self.accountView setTextChangeBlock:^{
        STRONG_SELF
        if (self.accountView.text.length>16) {
            self.accountView.inputView.textField.text = [self.accountView.text substringToIndex:16];
        }
        [self refreshLoginButton];
    }];
    [containerView addSubview:self.accountView];
    [self.accountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    self.passwordView = [[PasswordInputView alloc]init];
    [self.passwordView setTextChangeBlock:^{
        STRONG_SELF
        [self refreshLoginButton];
    }];
    [containerView addSubview:self.passwordView];
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.accountView.mas_bottom).mas_offset(1);
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    LoginActionView *loginView = [[LoginActionView alloc]init];
    self.loginView = loginView;
    loginView.title = @"登 录";
    [loginView setActionBlock:^{
        STRONG_SELF
        [self gotoLogin];
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
    self.touristButton = touristButton;
    self.touristButton.hidden = ![[YXInitHelper sharedHelper] isAppleChecking];
    
    ThirdLoginView *thirdView = [[ThirdLoginView alloc]init];
    [thirdView setLoginAction:^(ThirdLoginType type) {
        STRONG_SELF
        if (![self isNetworkReachable]) {
            [self.view nyx_showToast:@"网络未连接，请检查后重试"];
            return;
        }
        if (type == ThirdLogin_Weixin) {
            [[YXSSOAuthManager sharedManager] weixinLoginWithRootViewController:self];
        }else {
            [[YXSSOAuthManager sharedManager] qqLoginWithRootViewController:self];
        }
    }];
    [self.contentView addSubview:thirdView];
    [thirdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(loginView.mas_left);
        make.right.mas_equalTo(loginView.mas_right);
        make.top.mas_equalTo(loginView.mas_bottom).mas_offset(75*kPhoneWidthRatio);
        make.bottom.mas_equalTo(-40);
    }];
    
    [self refreshLoginButton];
}

- (void)refreshLoginButton {
    if (!isEmpty([self.accountView text])&&!isEmpty([self.passwordView text])) {
        self.loginView.isActive = YES;
    }else {
        self.loginView.isActive = NO;
    }
}

- (void)gotoForgotPassword {
    ForgotPasswordViewController *vc = [[ForgotPasswordViewController alloc]init];
    if ([LoginUtils isPhoneNumberValid:self.accountView.text]) {
        vc.phoneNum = self.accountView.text;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoRegister {
    RegisterViewController *vc = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoTouristLogin {
    [self.view nyx_startLoading];
    WEAK_SELF
    [LoginDataManager touristLoginWithCompleteBlock:^(YXLoginRequestItem *item, NSError *error, BOOL isBind) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
    }];
}

- (void)gotoLogin {
    if (![LoginUtils isAccountValid:self.accountView.text]) {
        [self.view nyx_showToast:@"请输入正确的账号"];
        return;
    }
    if (![LoginUtils isPasswordValid:self.passwordView.text]) {
        [self.view nyx_showToast:@"密码不符合要求"];
        return;
    }
    [self.view nyx_startLoading];
    WEAK_SELF
    [LoginDataManager loginWithMobileNumber:self.accountView.text password:self.passwordView.text isThirdLogin:NO completeBlock:^(YXLoginRequestItem *item, NSError *error, BOOL isBind) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }else {
            if (!isBind) { //未绑定用户信息
                AddClassViewController *vc = [[AddClassViewController alloc] init];
                vc.phoneNum = self.accountView.text;
                [self.navigationController pushViewController:vc animated:YES];
                return;
            }
            if (item.data.count > 0) {
                [self.view nyx_showToast:@"登录成功"];
            }
        }
    }];
}

@end
