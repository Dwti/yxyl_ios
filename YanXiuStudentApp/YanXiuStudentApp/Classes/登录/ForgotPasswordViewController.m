//
//  ForgotPasswordViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/9.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "AccountInputView.h"
#import "VerifyCodeInputView.h"
#import "LoginActionView.h"
#import "ResetPasswordViewController.h"
#import "LoginDataManager.h"

@interface ForgotPasswordViewController ()
@property (nonatomic, strong) AccountInputView *accountView;
@property (nonatomic, strong) VerifyCodeInputView *verifyCodeView;
@property (nonatomic, strong) LoginActionView *nextStepView;
@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"忘记密码?";
    [self setupUI];
    WEAK_SELF
    [self nyx_setupLeftWithImageName:@"关闭当前页面icon正常态" highlightImageName:@"关闭当前页面icon点击态" action:^{
        STRONG_SELF
        [self backAction];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    UIImageView *topImageView = [[UIImageView alloc]init];
    topImageView.image = [UIImage imageNamed:@"忘记密码头图"];
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
    self.accountView.inputView.textField.text = self.phoneNum;
    self.accountView.inputView.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.accountView.inputView.placeHolder = @"请输入绑定或注册的手机号";
    WEAK_SELF
    [self.accountView setTextChangeBlock:^{
        STRONG_SELF
        if (self.accountView.text.length>11) {
            self.accountView.inputView.textField.text = [self.accountView.text substringToIndex:11];
        }
        [self refreshVerifyCodeView];
        [self refreshNextStepButton];
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
        [self refreshNextStepButton];
    }];
    [self.verifyCodeView setSendAction:^{
        STRONG_SELF
        [self gotoGetVerifyCode];
    }];
    [containerView addSubview:self.verifyCodeView];
    [self.verifyCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.accountView.mas_bottom).mas_offset(1);
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    LoginActionView *nextStepView = [[LoginActionView alloc]init];
    nextStepView.title = @"下一步";
    [nextStepView setActionBlock:^{
        STRONG_SELF
        [self gotoNextStep];
    }];
    [self.contentView addSubview:nextStepView];
    [nextStepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(containerView.mas_left);
        make.right.mas_equalTo(containerView.mas_right);
        make.top.mas_equalTo(containerView.mas_bottom).mas_offset(15);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(-40);
    }];
    self.nextStepView = nextStepView;
    
    [self refreshVerifyCodeView];
    [self refreshNextStepButton];
}

- (void)refreshNextStepButton {
    if (!isEmpty([self.accountView text])&&!isEmpty([self.verifyCodeView text])) {
        self.nextStepView.isActive = YES;
    }else {
        self.nextStepView.isActive = NO;
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
    NSString *type = [NSString stringWithFormat:@"%@", @(YXLoginVerifyTypeResetPassword)];
    [self.view nyx_startLoading];
    [self.verifyCodeView startTimer];
    [LoginDataManager getVerifyCodeWithMobileNumber:self.accountView.text verifyType:type completeBlock:^(HttpBaseRequestItem *item, NSError *error) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.verifyCodeView stopTimer];
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        [self.view nyx_showToast:@"验证码已发送，请注意查收"];
    }];
}

- (void)gotoNextStep {
    if (![LoginUtils isPhoneNumberValid:self.accountView.text]) {
        [self.view nyx_showToast:@"请输入正确的手机号码"];
        return;
    }
    if (![LoginUtils isVerifyCodeValid:self.verifyCodeView.text]) {
        [self.view nyx_showToast:@"请输入正确的验证码"];
        return;
    }
    WEAK_SELF
    [self.view nyx_startLoading];
    NSString *type = [NSString stringWithFormat:@"%@", @(YXLoginVerifyTypeResetPassword)];
    [LoginDataManager verifySMSCodeWithMobileNumber:self.accountView.text verifyCode:self.verifyCodeView.text codeType:type completeBlock:^(HttpBaseRequestItem *item, NSError *error) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        ResetPasswordViewController *vc = [[ResetPasswordViewController alloc]init];
        vc.phoneNum = self.accountView.text;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

@end
