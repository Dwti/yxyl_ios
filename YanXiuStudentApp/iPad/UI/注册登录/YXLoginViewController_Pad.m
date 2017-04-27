//
//  YXLoginViewController_Pad.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/1/26.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXLoginViewController_Pad.h"
#import "YXPhoneInputView.h"
#import "YXPasswordInputView.h"
#import "YXCommonButton.h"
#import "YXThirdLoginButton.h"
#import "UIColor+YXColor.h"
#import "UIButton+YXButton.h"

#import "YXSSOAuthManager.h"
#import "YXInitRequest.h"
#import "YXLoginRequest.h"

#import "YXVerifyCodeViewController_Pad.h"
#import "YXEditProfileViewController_Pad.h"

static CGFloat kHeaderViewHeight = 180.f;

@interface YXLoginViewController_Pad ()

@property (nonatomic, strong) YXPhoneInputView *userInput;
@property (nonatomic, strong) YXPasswordInputView *passwordInput;
@property (nonatomic, strong) YXCommonButton *loginButton;
@property (nonatomic, strong) UIView *forgotAndRegisterView;
@property (nonatomic, strong) YXCommonButton *forgotButton;
@property (nonatomic, strong) UIButton *registerButton;
@property (nonatomic, strong) UILabel *otherLoginLabel;
@property (nonatomic, strong) UIView *societyLoginView;
@property (nonatomic, strong) YXThirdLoginButton *qqLoginButton;
@property (nonatomic, strong) YXThirdLoginButton *weixinLoginButton;
@property (nonatomic, strong) YXThirdLoginButton *touristLoginButton;

@property (nonatomic, strong) YXLoginRequest *request;

@end

@implementation YXLoginViewController_Pad

- (void)dealloc
{
    [self removeNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [YXSSOAuthManager sharedManager].thirdRegisterBlock = ^(UIViewController *rootViewController, NSDictionary *params) {
        YXEditProfileViewController_Pad *vc = [[YXEditProfileViewController_Pad alloc] init];
        vc.thirdLoginParams = params;
        [rootViewController.navigationController pushViewController:vc animated:YES];
    };
    [self registerNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
    
    UIImage *image = [UIImage imageNamed:@"登录_logo"];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kYXLoginCellWidth, kHeaderViewHeight)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [headerView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(20);
        make.height.mas_equalTo(image.size.height);
        make.width.mas_equalTo(image.size.width);
    }];
    self.tableView.tableHeaderView = headerView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self textFieldResignFirstResponder];
}

- (UIView *)viewForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0:
                    return self.userInput;
                case 1:
                    return self.passwordInput;
                default:
                    return nil;
            }
        }
        case 1:
            return self.loginButton;
        case 2:
            return self.forgotAndRegisterView;
        case 3:
            return self.otherLoginLabel;
        case 4:
            return self.societyLoginView;
        default:
            return nil;
    }
}

#pragma mark -

- (void)registerNotifications
{
    [self removeNotifications];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    //键盘显示通知
    [center addObserver:self
               selector:@selector(keyboardWillShow:)
                   name:UIKeyboardWillShowNotification
                 object:nil];
    [center addObserver:self
               selector:@selector(keyboardWillHide:)
                   name:UIKeyboardWillHideNotification
                 object:nil];
    [center addObserver:self
               selector:@selector(initSuccess:)
                   name:YXInitSuccessNotification
                 object:nil];
    [center addObserver:self
               selector:@selector(willEnterForeground:)
                   name:UIApplicationWillEnterForegroundNotification
                 object:nil];
}

- (void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self textFieldResignFirstResponder];
}

- (void)textFieldResignFirstResponder
{
    [self.userInput resignFirstResponder];
    [self.passwordInput resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect frame = self.tableView.frame;
    frame.origin.y = -kHeaderViewHeight;
    [UITableView beginAnimations:nil context:nil];
    [UITableView setAnimationDuration:0.3f];
    self.tableView.frame = frame;
    [UITableView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    CGRect frame = self.tableView.frame;
    frame.origin.y = 0;
    [UITableView beginAnimations:nil context:nil];
    [UITableView setAnimationDuration:0.3f];
    self.tableView.frame = frame;
    [UITableView commitAnimations];
}

- (void)initSuccess:(NSNotification *)notification
{
    [self.tableView reloadData];
}

- (void)willEnterForeground:(NSNotification *)notification
{
    [self.tableView reloadData];
}

#pragma mark -

- (void)startLoginRequest
{
    [self textFieldResignFirstResponder];
    
    NSString *mobile = [self.userInput.text yx_stringByTrimmingCharacters];
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *password = [self.passwordInput.text yx_stringByTrimmingCharacters];
    if (![mobile yx_isValidString]) {
        [self showMessage:@"手机号不能为空"];
        return;
    }
    if (![password yx_isValidString]) {
        [self showMessage:@"密码不能为空"];
        return;
    }
    if (![mobile yx_isPhoneNum]) {
        [self showMessage:@"请输入正确手机号"];
        return;
    }
    
    if (self.request) {
        [self.request stopRequest];
    }
    self.request = [[YXLoginRequest alloc] init];
    self.request.mobile = mobile;
    self.request.password = password;//[password yx_md5];
    @weakify(self);
    [self yx_startLoading];
    [self.request startRequestWithRetClass:[YXLoginRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        @strongify(self);
        [self yx_stopLoading];
        YXLoginRequestItem *item = retItem;
        if (item.data.count > 0 && !error) {
            [self showMessage:@"登录成功"];
            [self saveUserDataWithUserModel:item.data[0] isThirdLogin:NO];
        } else {
            [self yx_showToast:error.localizedDescription];
        }
    }];
}

// 保存用户信息并发送登录成功通知
- (void)saveUserDataWithUserModel:(YXUserModel *)model
                     isThirdLogin:(BOOL)isThirdLogin
{
    [YXUserManager sharedManager].userModel = model;
    [[YXUserManager sharedManager] setIsThirdLogin:isThirdLogin];
    [[YXUserManager sharedManager] login];
}

- (void)showMessage:(NSString *)message
{
    [self yx_showToast:message];
}

- (void)startWeixinLogin
{
    if (![self isNetworkReachable]) {
        [self showMessage:@"网络异常，请稍后重试"];
        return;
    }
    [[YXSSOAuthManager sharedManager] weixinLoginWithRootViewController:self];
}

- (void)startQQLogin
{
    if (![self isNetworkReachable]) {
        [self showMessage:@"网络异常，请稍后重试"];
        return;
    }
    [[YXSSOAuthManager sharedManager] qqLoginWithRootViewController:self];
}

- (void)startTouristLogin
{
    if (self.request) {
        [self.request stopRequest];
    }
    self.request = [[YXLoginRequest alloc] init];
    self.request.mobile = @"15652513352";
    self.request.password = @"123456";
    @weakify(self);
    [self yx_startLoading];
    [self.request startRequestWithRetClass:[YXLoginRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        @strongify(self);
        [self yx_stopLoading];
        YXLoginRequestItem *item = retItem;
        if (item.data.count > 0 && !error) {
            [self saveUserDataWithUserModel:item.data[0] isThirdLogin:YES];
        } else {
            [self yx_showToast:error.localizedDescription];
        }
    }];
}

#pragma mark -

- (YXPhoneInputView *)userInput
{
    if (!_userInput) {
        _userInput = [[YXPhoneInputView alloc] init];
    }
    return _userInput;
}

- (YXPasswordInputView *)passwordInput
{
    if (!_passwordInput) {
        _passwordInput = [[YXPasswordInputView alloc] init];
        _passwordInput.placeholder = @"密码";
        [_passwordInput setFrontImage:[UIImage imageNamed:@"密码"]];
        [_passwordInput setShowPassword:YES];
    }
    return _passwordInput;
}

- (YXCommonButton *)loginButton
{
    if (!_loginButton) {
        _loginButton = [[YXCommonButton alloc] init];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

- (UIView *)forgotAndRegisterView
{
    if (!_forgotAndRegisterView) {
        _forgotAndRegisterView = [[UIView alloc] init];
        [_forgotAndRegisterView addSubview:self.forgotButton];
        [_forgotAndRegisterView addSubview:self.registerButton];
        CGFloat width = (kYXLoginCellWidth - 6.f) / 2.f;
        CGFloat height = 46.f;
        [self.forgotButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
            make.centerY.left.mas_equalTo(0);
        }];
        [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
            make.centerY.right.mas_equalTo(0);
        }];
    }
    return _forgotAndRegisterView;
}

- (YXCommonButton *)forgotButton
{
    if (!_forgotButton) {
        _forgotButton = [[YXCommonButton alloc] init];
        [_forgotButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
        _forgotButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_forgotButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgotButton;
}

- (UIButton *)registerButton
{
    if (!_registerButton) {
        _registerButton = [[UIButton alloc] init];
        [_registerButton setTitle:@"快速注册" forState:UIControlStateNormal];
        [_registerButton setBackgroundImage:[[UIImage imageNamed:@"快速注册"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 30, 20, 30)] forState:UIControlStateNormal];
        [_registerButton setBackgroundImage:[[UIImage imageNamed:@"快速注册-按下"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 30, 20, 30)] forState:UIControlStateHighlighted];
        [_registerButton yx_setTitleColor:[UIColor yx_colorWithHexString:@"006666"]];
        _registerButton.titleLabel.layer.shadowColor = [UIColor yx_colorWithHexString:@"33ffff"].CGColor;
        _registerButton.titleLabel.layer.shadowOffset = CGSizeMake(0, 1);
        _registerButton.titleLabel.layer.shadowRadius = 0;
        _registerButton.titleLabel.layer.shadowOpacity = 1;
        _registerButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_registerButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
}

- (UILabel *)otherLoginLabel
{
    if (!_otherLoginLabel) {
        _otherLoginLabel = [[UILabel alloc] init];
        _otherLoginLabel.backgroundColor = [UIColor clearColor];
        _otherLoginLabel.textAlignment = NSTextAlignmentCenter;
        _otherLoginLabel.textColor = [UIColor whiteColor];
        _otherLoginLabel.font = [UIFont systemFontOfSize:15.f];
        _otherLoginLabel.text = @"其他帐号登录";
    }
    return _otherLoginLabel;
}

- (UIView *)societyLoginView
{
    if (!_societyLoginView) {
        _societyLoginView = [[UIView alloc] init];
        [_societyLoginView addSubview:self.weixinLoginButton];
        [_societyLoginView addSubview:self.qqLoginButton];
        [_societyLoginView addSubview:self.touristLoginButton];
    }
    
    self.touristLoginButton.hidden = ![[YXInitHelper sharedHelper] isAppleChecking];
    self.weixinLoginButton.hidden = ![YXSSOAuthManager isWXAppSupport] || !self.touristLoginButton.hidden;
    
    CGFloat width = (kYXLoginCellWidth - 2 * 6.f) / 3; //间隔为6.f
    CGFloat height = 50.f;
    [self.weixinLoginButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
        make.centerY.left.mas_equalTo(0);
    }];
    [self.touristLoginButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
        make.centerY.right.mas_equalTo(0);
    }];
    
    if (!self.weixinLoginButton.hidden && self.touristLoginButton.hidden) {
        [self.qqLoginButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
            make.centerY.right.mas_equalTo(0);
        }];
    } else if (self.weixinLoginButton.hidden && !self.touristLoginButton.hidden) {
        [self.qqLoginButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
            make.centerY.left.mas_equalTo(0);
        }];
    } else {
        [self.qqLoginButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
            make.centerY.centerX.mas_equalTo(0);
        }];
    }
    
    return _societyLoginView;
}

- (YXThirdLoginButton *)weixinLoginButton
{
    if (!_weixinLoginButton) {
        _weixinLoginButton = [[YXThirdLoginButton alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"third-weixin"] title:@"微信"];
        [_weixinLoginButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _weixinLoginButton;
}

- (YXThirdLoginButton *)qqLoginButton
{
    if (!_qqLoginButton) {
        _qqLoginButton = [[YXThirdLoginButton alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"third-qq"] title:@"QQ"];
        [_qqLoginButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _qqLoginButton;
}

- (YXThirdLoginButton *)touristLoginButton
{
    if (!_touristLoginButton) {
        _touristLoginButton = [[YXThirdLoginButton alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"third-guest"] title:@"游客"];
        [_touristLoginButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _touristLoginButton;
}

- (void)buttonAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    YXLoginBaseViewController_Pad *vc = nil;
    if (button == self.registerButton) {
        vc = [[YXVerifyCodeViewController_Pad alloc] initWithType:YXLoginVerifyTypeRegister userName:nil];
    } else if (button == self.forgotButton) {
        vc = [[YXVerifyCodeViewController_Pad alloc] initWithType:YXLoginVerifyTypeResetPassword userName:self.userInput.text];
    } else if (button == self.loginButton) {
        [self startLoginRequest];
    } else if (button == self.qqLoginButton) {
        [self startQQLogin];
    } else if (button == self.weixinLoginButton) {
        [self startWeixinLogin];
    } else if (button == self.touristLoginButton) {
        [self startTouristLogin];
    }
    
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    return 1;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 8.f;
    }
    if (section == 3) {
        return 0.1f;
    }
    return [super tableView:tableView heightForFooterInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        return 32.f;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self textFieldResignFirstResponder];
}

@end
