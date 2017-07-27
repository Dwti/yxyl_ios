//
//  BindPhoneViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/24.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "BindPhoneViewController.h"
#import "MinePhoneInputView.h"
#import "MineVerifyCodeInputView.h"
#import "MineActionView.h"

@interface BindPhoneViewController ()
@property (nonatomic, strong) MinePhoneInputView *accountView;
@property (nonatomic, strong) MineVerifyCodeInputView *verifyCodeView;
@property (nonatomic, strong) MineActionView *confirmView;
@end

@implementation BindPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.isRebind? @"绑定新手机":@"绑定手机";
    self.naviTheme = NavigationBarTheme_White;
    self.view.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    self.accountView = [[MinePhoneInputView alloc]init];
    WEAK_SELF
    [self.accountView setTextChangeBlock:^{
        STRONG_SELF
        [self refreshVerifyCodeView];
        [self refreshConfirmButton];
    }];
    [self.contentView addSubview:self.accountView];
    [self.accountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(75);
    }];
    UIView *seperatorView = [[UIView alloc]init];
    seperatorView.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    [self.contentView addSubview:seperatorView];
    [seperatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.accountView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    self.verifyCodeView = [[MineVerifyCodeInputView alloc]init];
    self.verifyCodeView.layer.shadowOffset = CGSizeMake(0, 1);
    self.verifyCodeView.layer.shadowRadius = 1;
    self.verifyCodeView.layer.shadowOpacity = 0.02;
    self.verifyCodeView.layer.shadowColor = [UIColor colorWithHexString:@"002c0f"].CGColor;
    self.verifyCodeView.isActive = NO;
    [self.verifyCodeView setTextChangeBlock:^{
        STRONG_SELF
        [self refreshConfirmButton];
    }];
    [self.verifyCodeView setSendAction:^{
        STRONG_SELF
        [self gotoGetVerifyCode];
    }];
    [self.contentView addSubview:self.verifyCodeView];
    [self.verifyCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(seperatorView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(75);
    }];
    self.confirmView = [[MineActionView alloc]init];
    self.confirmView.title = @"确定";
    [self.confirmView setActionBlock:^{
        STRONG_SELF
        [self gotoBindPhone];
    }];
    [self.contentView addSubview:self.confirmView];
    [self.confirmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.verifyCodeView.mas_bottom).mas_offset(30);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(250*kPhoneWidthRatio, 50));
        make.bottom.mas_equalTo(-40);
    }];
    
    [self refreshVerifyCodeView];
    [self refreshConfirmButton];
}

- (void)refreshConfirmButton {
    if (!isEmpty([self.accountView text])&&!isEmpty([self.verifyCodeView text])) {
        self.confirmView.isActive = YES;
    }else {
        self.confirmView.isActive = NO;
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
    [self.view nyx_startLoading];
    [self.verifyCodeView startTimer];
    [LoginDataManager getVerifyCodeByBindWithMobileNumber:self.accountView.text verifyType:@"0" completeBlock:^(HttpBaseRequestItem *item, NSError *error) {
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

- (void)gotoBindPhone {
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
    [LoginDataManager bindNewMobileWithNumber:self.accountView.text verifyCode:self.verifyCodeView.text completeBlock:^(HttpBaseRequestItem *item, NSError *error) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        [self.view.window nyx_showToast:@"绑定成功"];
    }];
}

@end
