//
//  RegisterViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/9.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "RegisterViewController.h"
#import "AccountInputView.h"
#import "VerifyCodeInputView.h"
#import "LoginActionView.h"
#import "PasswordInputView.h"
#import "AddClassViewController.h"

@interface RegisterViewController ()
@property (nonatomic, strong) AccountInputView *accountView;
@property (nonatomic, strong) PasswordInputView *passwordView;
@property (nonatomic, strong) VerifyCodeInputView *verifyCodeView;
@property (nonatomic, strong) LoginActionView *registerButton;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我要注册";
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
    self.accountView.inputView.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.accountView.inputView.placeHolder = @"请输入手机号";
    WEAK_SELF
    [self.accountView setTextChangeBlock:^{
        STRONG_SELF
        if (self.accountView.text.length>11) {
            self.accountView.inputView.textField.text = [self.accountView.text substringToIndex:11];
        }
        [self refreshVerifyCodeView];
        [self refreshRegisterButton];
    }];
    [containerView addSubview:self.accountView];
    [self.accountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    self.verifyCodeView = [[VerifyCodeInputView alloc]init];
    self.verifyCodeView.isActive = NO;
    [self.verifyCodeView setTextChangeBlock:^{
        STRONG_SELF
        [self refreshRegisterButton];
    }];
    [self.verifyCodeView setTimerPauseBlock:^{
        STRONG_SELF
        self.verifyCodeView.isActive = !isEmpty(self.accountView.text);
    }];
    [self.verifyCodeView setSendAction:^{
        STRONG_SELF
        [self gotoGetVerifyCode];
    }];
    [containerView addSubview:self.verifyCodeView];
    [self.verifyCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.accountView.mas_bottom).mas_offset(1);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    self.passwordView = [[PasswordInputView alloc]init];
    self.passwordView.inputView.placeHolder = @"请输入6~18位密码";
    [self.passwordView setTextChangeBlock:^{
        STRONG_SELF
        [self refreshRegisterButton];
    }];
    [containerView addSubview:self.passwordView];
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.verifyCodeView.mas_bottom).mas_offset(1);
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    self.registerButton = [[LoginActionView alloc]init];
    self.registerButton.title = @"注 册";
    [self.registerButton setActionBlock:^{
        STRONG_SELF
        [self gotoRegister];
    }];
    [self.contentView addSubview:self.registerButton];
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(containerView.mas_left);
        make.right.mas_equalTo(containerView.mas_right);
        make.top.mas_equalTo(containerView.mas_bottom).mas_offset(15);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(-40);
    }];
    
    [self refreshVerifyCodeView];
    [self refreshRegisterButton];
}

- (void)refreshRegisterButton {
    if (!isEmpty([self.accountView text])&&!isEmpty([self.verifyCodeView text])&&!isEmpty([self.passwordView text])) {
        self.registerButton.isActive = YES;
    }else {
        self.registerButton.isActive = NO;
    }
}

- (void)refreshVerifyCodeView {
    self.verifyCodeView.isActive = !isEmpty([self.accountView text]);
}

- (void)gotoGetVerifyCode {
    if (![LoginUtils isPhoneNumberValid:self.accountView.text]) {
        [self.view nyx_showToast:@"请输入正确的手机号码"];
        return;
    }
    WEAK_SELF
    NSString *type = [NSString stringWithFormat:@"%@", @(YXLoginVerifyTypeRegister)];
    [self.view nyx_startLoading];
    [LoginDataManager getVerifyCodeWithMobileNumber:self.accountView.text verifyType:type completeBlock:^(HttpBaseRequestItem *item, NSError *error) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        [self.view nyx_showToast:@"验证码已发送，请注意查收"];
    }];
}

- (void)gotoRegister {
    if (![LoginUtils isAccountValid:self.accountView.text]) {
        [self.view nyx_showToast:@"请输入正确的账号"];
        return;
    }
    if (![LoginUtils isVerifyCodeValid:self.verifyCodeView.text]) {
        [self.view nyx_showToast:@"请输入正确的验证码"];
        return;
    }
    if (![LoginUtils isPasswordValid:self.passwordView.text]) {
        [self.view nyx_showToast:@"密码不符合要求"];
        return;
    }
    WEAK_SELF
    [self.view nyx_startLoading];
    NSString *type = [NSString stringWithFormat:@"%@", @(YXLoginVerifyTypeRegister)];
    [LoginDataManager verifySMSCodeWithMobileNumber:self.accountView.text verifyCode:self.verifyCodeView.text codeType:type completeBlock:^(HttpBaseRequestItem *item, NSError *error) {
        STRONG_SELF
        if (error) {
            [self.view nyx_stopLoading];
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        [self registerAccount];
    }];

}

- (void)registerAccount {
    AccountRegisterModel *model = [[AccountRegisterModel alloc]init];
    model.mobile = self.accountView.text;
    model.password = self.passwordView.text;
    model.code = self.verifyCodeView.text;
    model.type = [NSString stringWithFormat:@"%@", @(YXLoginVerifyTypeRegister)];
    WEAK_SELF
    [LoginDataManager registerAccountWithModel:model completeBlock:^(HttpBaseRequestItem *item, NSError *error) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        AddClassViewController *vc = [[AddClassViewController alloc] init];
        vc.phoneNum = self.accountView.text;
        vc.isThirdLogin = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

@end
