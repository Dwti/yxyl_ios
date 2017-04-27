//
//  YXLoginViewController.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/3.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXLoginViewController.h"
#import "YXPhoneInputView.h"
#import "YXPasswordInputView.h"
#import "YXCommonButton.h"
#import "YXThirdLoginButton.h"
#import "UIColor+YXColor.h"
#import "UIButton+YXButton.h"
#import "UIView+YXScale.h"
#import "YXVerifyCodeViewController.h"
#import "YXEditProfileViewController.h"
#import "AccountIDInputView.h"
#import "GlobalUtils.h"
#import "YXSSOAuthManager.h"
#import "YXInitRequest.h"
#import "YXLoginRequest.h"
#import "YXHistoryTableView.h"
#import "SearchClassViewController.h"
#import "JoinClassViewController.h"

@interface YXLoginViewController ()
@property (nonatomic, strong) AccountIDInputView *accountIDInput;
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
@property (nonatomic, strong) YXHistoryTableView *historyTableView;;
@end

@implementation YXLoginViewController

- (void)dealloc {
    [self removeNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [YXSSOAuthManager sharedManager].thirdRegisterBlock = ^(UIViewController *rootViewController, NSDictionary *params) {
        SearchClassViewController *vc = [[SearchClassViewController alloc] init];
        vc.thirdLoginParams = params;
        vc.isThirdLogin = YES;
        [rootViewController.navigationController pushViewController:vc animated:YES];
    };
    [self registerNotifications];
    [self setupUI];
    
#ifdef DEBUG
    [self debugHistoryView];
#endif
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self textFieldResignFirstResponder];
}

#pragma mark - UI
- (void)setupUI {
    [self setupTableHeaderView];
    [self setupInputAndLoginButton];
    [self setupForgotAndRegisterView];
    [self setupOtherLoginLabel];
    [self setupSocietyLoginView];
}

- (void)setupTableHeaderView {
    UIImage *image = [UIImage imageNamed:@"登录_logo"];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds) - 72.f * [UIView scale], 180)];
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

- (void)setupInputAndLoginButton {
    self.accountIDInput = [[AccountIDInputView alloc] init];
    WEAK_SELF
    [self.accountIDInput setTextChangeBlock:^(NSString *text) {
        STRONG_SELF
        if (text.length > 16) {
            self.accountIDInput.text = [text substringToIndex:16];
        }
    }];
    
    self.passwordInput = [[YXPasswordInputView alloc] init];
    self.passwordInput.placeholder = @"密码";
    [self.passwordInput setFrontImage:[UIImage imageNamed:@"密码"]];
    [self.passwordInput setShowPassword:YES];
    
    self.loginButton = [[YXCommonButton alloc] init];
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupSocietyLoginView {
    self.societyLoginView = [[UIView alloc] init];

    self.weixinLoginButton = [[YXThirdLoginButton alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"third-weixin"] title:@"微信"];
    self.weixinLoginButton.hidden = ![YXSSOAuthManager isWXAppSupport];
    [self.weixinLoginButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];

    self.qqLoginButton = [[YXThirdLoginButton alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"third-qq"] title:@"QQ"];
    [self.qqLoginButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];

    self.touristLoginButton = [[YXThirdLoginButton alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"third-guest"] title:@"游客"];
    self.touristLoginButton.hidden = ![[YXInitHelper sharedHelper] isAppleChecking];
    [self.touristLoginButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat width = (CGRectGetWidth([UIScreen mainScreen].bounds) - 72.f * [UIView scale] - 2 * 6.f) / 3; //间隔为6.f
    CGFloat height = 50.f;
    
    [self.societyLoginView addSubview:self.weixinLoginButton];
    [self.weixinLoginButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
        make.centerY.left.mas_equalTo(0);
    }];
    
    [self.societyLoginView addSubview:self.touristLoginButton];
    [self.touristLoginButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
        make.centerY.right.mas_equalTo(0);
    }];
    
    [self.societyLoginView addSubview:self.qqLoginButton];
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
}

- (void)setupForgotAndRegisterView {
    self.forgotButton = [[YXCommonButton alloc] init];
    [self.forgotButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    self.forgotButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [self.forgotButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.registerButton = [[UIButton alloc] init];
    [self.registerButton setTitle:@"快速注册" forState:UIControlStateNormal];
    [self.registerButton setBackgroundImage:[[UIImage imageNamed:@"快速注册"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 30, 20, 30)] forState:UIControlStateNormal];
    [self.registerButton setBackgroundImage:[[UIImage imageNamed:@"快速注册-按下"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 30, 20, 30)] forState:UIControlStateHighlighted];
    [self.registerButton yx_setTitleColor:[UIColor yx_colorWithHexString:@"006666"]];
    self.registerButton.titleLabel.layer.shadowColor = [UIColor yx_colorWithHexString:@"33ffff"].CGColor;
    self.registerButton.titleLabel.layer.shadowOffset = CGSizeMake(0, 1);
    self.registerButton.titleLabel.layer.shadowRadius = 0;
    self.registerButton.titleLabel.layer.shadowOpacity = 1;
    self.registerButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [self.registerButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.forgotAndRegisterView = [[UIView alloc] init];
    CGFloat width = (CGRectGetWidth([UIScreen mainScreen].bounds) - 72.f * [UIView scale] - 6.f) / 2.f;
    CGFloat height = 46.f;

    [self.forgotAndRegisterView addSubview:self.forgotButton];
    [self.forgotButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
        make.centerY.left.mas_equalTo(0);
    }];
    
    [self.forgotAndRegisterView addSubview:self.registerButton];
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
        make.centerY.right.mas_equalTo(0);
    }];
}

- (void)setupOtherLoginLabel {
    self.otherLoginLabel = [[UILabel alloc] init];
    self.otherLoginLabel.backgroundColor = [UIColor clearColor];
    self.otherLoginLabel.textAlignment = NSTextAlignmentCenter;
    self.otherLoginLabel.textColor = [UIColor whiteColor];
    self.otherLoginLabel.font = [UIFont systemFontOfSize:15.f];
    self.otherLoginLabel.text = @"其他帐号登录";
}

#pragma mark - Helper
- (UIView *)viewForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0:
                    return self.accountIDInput;
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

- (void)textFieldResignFirstResponder {
    [self.accountIDInput resignFirstResponder];
    [self.passwordInput resignFirstResponder];
}

#pragma mark - Notifications
- (void)registerNotifications {
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

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self textFieldResignFirstResponder];
}

#pragma mark - Action
- (void)buttonAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    YXLoginBaseViewController *vc = nil;
    if (button == self.registerButton) {
        vc = [[YXVerifyCodeViewController alloc] initWithType:YXLoginVerifyTypeRegister userName:nil];
    } else if (button == self.forgotButton) {
        vc = [[YXVerifyCodeViewController alloc] initWithType:YXLoginVerifyTypeResetPassword userName:self.accountIDInput.originalText];
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

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect frame = self.tableView.frame;
    frame.origin.y = -140.f;
    [UITableView beginAnimations:nil context:nil];
    [UITableView setAnimationDuration:0.3f];
    self.tableView.frame = frame;
    [UITableView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGRect frame = self.tableView.frame;
    frame.origin.y = 0;
    [UITableView beginAnimations:nil context:nil];
    [UITableView setAnimationDuration:0.3f];
    self.tableView.frame = frame;
    [UITableView commitAnimations];
}

- (void)initSuccess:(NSNotification *)notification {
    [self.tableView reloadData];
}

- (void)willEnterForeground:(NSNotification *)notification {
    [self.tableView reloadData];
}

- (void)startWeixinLogin {
    if (![self isNetworkReachable]) {
        [self showMessage:@"网络异常，请稍后重试"];
        return;
    }
    [[YXSSOAuthManager sharedManager] weixinLoginWithRootViewController:self];
}

- (void)startQQLogin {
    if (![self isNetworkReachable]) {
        [self showMessage:@"网络异常，请稍后重试"];
        return;
    }
    [[YXSSOAuthManager sharedManager] qqLoginWithRootViewController:self];
}

- (void)startTouristLogin {
    [self yx_startLoading];
    WEAK_SELF
    [LoginDataManager touristLoginWithCompleteBlock:^(YXLoginRequestItem *item, NSError *error, BOOL isBind) {
        STRONG_SELF
        [self yx_stopLoading];
        if (error) {
            [self yx_showToast:error.localizedDescription];
            return;
        }
    }];
}

- (void)showMessage:(NSString *)message {
    [self yx_showToast:message];
}

- (void)exitLogin {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Request
- (void)startLoginRequest {
    NSString *accountID = self.accountIDInput.text;
    NSString *password = self.passwordInput.text;
    
    [LoginUtils verifyAccountID:accountID completeBlock:^(BOOL isEmpty, BOOL formatIsCorrect) {
        if (isEmpty) {
            [self showMessage:@"账号不能为空"];
            return;
        }
        if (!formatIsCorrect) {
            [self showMessage:@"请输入正确的账号"];
            return;
        }
        [LoginUtils verifyPasswordFormat:password completeBlock:^(BOOL isEmptyy, BOOL formatIsCorrect) {
            if (isEmptyy) {
                [self showMessage:@"密码不能为空"];
                return;
            }
        }];
        [self textFieldResignFirstResponder];
        [self loginWithMobileNumber:accountID password:password];
    }];
}

- (void)loginWithMobileNumber:(NSString *)mobileNumber password:(NSString *)password {
    [self yx_startLoading];
    WEAK_SELF
    [LoginDataManager loginWithMobileNumber:mobileNumber password:password isThirdLogin:NO completeBlock:^(YXLoginRequestItem *item, NSError *error, BOOL isBind) {
        STRONG_SELF
        [self yx_stopLoading];
        if (error) {
            [self yx_showToast:error.localizedDescription];
            return;
        }else {
            if (!isBind) { //未绑定用户信息
                SearchClassViewController *vc = [[SearchClassViewController alloc] init];
                vc.phoneNum = mobileNumber;
                [self.navigationController pushViewController:vc animated:YES];
                return;
            }
            if (item.data.count > 0) {
                [self showMessage:@"登录成功"];
            }
        }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    return 1;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 8.f;
    }
    if (section == 3) {
        return 0.1f;
    }
    return [super tableView:tableView heightForFooterInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        return 32.f;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self textFieldResignFirstResponder];
}

#pragma mark - Debug
- (void)debugHistoryView {
    self.historyTableView = [YXHistoryTableView new];
    WEAK_SELF
    [[self.historyTableView rac_signalForSelector:@selector(tableView:didSelectRowAtIndexPath:)] subscribeNext:^(RACTuple *x) {
        STRONG_SELF
        NSIndexPath *indexPath = x.second;
        YXHistoryTableView *tableView = x.first;
        self.accountIDInput.text = tableView.datas[indexPath.row][0];
        self.passwordInput.text = tableView.datas[indexPath.row][1];
        [self.historyTableView removeFromSuperview];
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UITextFieldTextDidBeginEditingNotification object:nil] subscribeNext:^(id x) {
        STRONG_SELF
        UITextField *textFiled = [x object];
        if ([textFiled.placeholder isEqualToString:@"密码"]){
            [self.historyTableView removeFromSuperview];
        }else if (!self.historyTableView.superview && self.historyTableView.datas.count) {
            [self.view addSubview:self.historyTableView];
            [self.historyTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                UIView *view = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                make.top.mas_equalTo(view.mas_bottom);
                make.left.right.mas_equalTo(view);
                make.height.offset = 200;
            }];
        }
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UITextFieldTextDidEndEditingNotification object:nil] subscribeNext:^(id x) {
        STRONG_SELF
        [self.historyTableView removeFromSuperview];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UITextFieldTextDidChangeNotification object:nil] subscribeNext:^(id x) {
        STRONG_SELF
        if ([[[x object] text] length] == 13) {
            [self.historyTableView removeFromSuperview];
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.historyTableView removeFromSuperview];
}

@end
