//
//  ChangePasswordViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/24.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "MinePasswordInputView.h"
#import "MineActionView.h"

@interface ChangePasswordViewController ()
@property (nonatomic, strong) MinePasswordInputView *oldPasswordView;
@property (nonatomic, strong) MinePasswordInputView *currentPasswordView;
@property (nonatomic, strong) MinePasswordInputView *confirmPasswordView;
@property (nonatomic, strong) MineActionView *confirmView;
@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"修改密码";
    self.naviTheme = NavigationBarTheme_White;
    self.view.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    self.oldPasswordView = [[MinePasswordInputView alloc]init];
    self.oldPasswordView.inputView.placeHolder = @"请输入原密码";
    WEAK_SELF
    [self.oldPasswordView setTextChangeBlock:^{
        STRONG_SELF
        [self refreshConfirmButton];
    }];
    [self.contentView addSubview:self.oldPasswordView];
    [self.oldPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(75);
    }];
    UIView *seperatorView = [[UIView alloc]init];
    seperatorView.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    [self.contentView addSubview:seperatorView];
    [seperatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.oldPasswordView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    self.currentPasswordView = [[MinePasswordInputView alloc]init];
    self.currentPasswordView.inputView.placeHolder = @"请输入6-18位新密码";
    [self.currentPasswordView setTextChangeBlock:^{
        STRONG_SELF
        [self refreshConfirmButton];
    }];
    [self.contentView addSubview:self.currentPasswordView];
    [self.currentPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(seperatorView.mas_bottom);
        make.height.mas_equalTo(75);
    }];
    UIView *seperatorView2 = [[UIView alloc]init];
    seperatorView2.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    [self.contentView addSubview:seperatorView2];
    [seperatorView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.currentPasswordView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    self.confirmPasswordView = [[MinePasswordInputView alloc]init];
    self.confirmPasswordView.inputView.placeHolder = @"请确认新密码";
    [self.confirmPasswordView setTextChangeBlock:^{
        STRONG_SELF
        [self refreshConfirmButton];
    }];
    [self.contentView addSubview:self.confirmPasswordView];
    [self.confirmPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(seperatorView2.mas_bottom);
        make.height.mas_equalTo(75);
    }];

    self.confirmView = [[MineActionView alloc]init];
    self.confirmView.title = @"确认修改";
    [self.confirmView setActionBlock:^{
        STRONG_SELF
        [self gotoChangePassowrd];
    }];
    [self.contentView addSubview:self.confirmView];
    [self.confirmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.confirmPasswordView.mas_bottom).mas_offset(30);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(250*kPhoneWidthRatio, 50));
        make.bottom.mas_equalTo(-40);
    }];
    
    [self refreshConfirmButton];
}

- (void)refreshConfirmButton {
    if (!isEmpty(self.oldPasswordView.text)&&!isEmpty(self.currentPasswordView.text)&&!isEmpty(self.confirmPasswordView.text)) {
        self.confirmView.isActive = YES;
    }else {
        self.confirmView.isActive = NO;
    }
}

- (void)gotoChangePassowrd {
    if (![[self.oldPasswordView.text md5] isEqualToString:[YXUserManager sharedManager].userModel.passport.password]) {
        [self.view nyx_showToast:@"原密码错误"];
        return;
    }
    if (![self.currentPasswordView.text isEqualToString:self.confirmPasswordView.text]) {
        [self.view nyx_showToast:@"两次输入密码不一致"];
        return;
    }
    if (![LoginUtils isPasswordValid:self.currentPasswordView.text]) {
        [self.view nyx_showToast:@"新密码不符合要求"];
        return;
    }
    
    WEAK_SELF
    [self.view nyx_startLoading];
    [LoginDataManager modifyPasswordWithOldPassword:[self.oldPasswordView.text md5] newPassword:[self.currentPasswordView.text md5]completeBlock:^(YXModifyPasswordItem *item, NSError *error) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        [self.view.window nyx_showToast:@"修改成功"];
        [self backAction];
    }];
}

@end
