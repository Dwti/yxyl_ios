//
//  YXVerifyCodeViewController.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/3.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXVerifyCodeViewController.h"
#import "YXPhoneInputView.h"
#import "YXCommonButton.h"
#import "YXResetPasswordViewController.h"
#import "UIImage+YXImage.h"
#import "UIButton+YXButton.h"
#import "YXRecordManager.h"
#import "YXPasswordInputView.h"
#import "YXProduceCodeRequest.h"
#import "YXVerifySMSCodeRequest.h"
#import "SearchClassViewController.h"
#import "YXSearchClassViewController.h"
#import "RegisterAccountRequest.h"


@interface YXVerifyCodeViewController ()

@property (nonatomic, assign) YXLoginVerifyType type;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) YXPhoneInputView *phoneNumInput;
@property (nonatomic, strong) YXLoginInputView *verifyCodeInput;
@property (nonatomic, strong) YXPasswordInputView *passwordInput;
@property (nonatomic, strong) YXCommonButton *submitButton;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger seconds;

@end

@implementation YXVerifyCodeViewController

- (instancetype)initWithType:(YXLoginVerifyType)type userName:(NSString *)userName {
    if (self = [super init]) {
        self.type = type;
        self.userName = userName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch (self.type) {
        case YXLoginVerifyTypeResetPassword:
            self.title = @"忘记密码";
            break;
        case YXLoginVerifyTypeRegister:
            self.title = @"注册";
            break;
        default:
            break;
    }
    [self yx_setupLeftBackBarButtonItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeNotifications];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.phoneNumInput becomeFirstResponder];
}

- (UIView *)viewForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0:
                    return self.phoneNumInput;
                case 1:
                    return self.verifyCodeInput;
                case 2:
                    return self.passwordInput;
                default:
                    return nil;
            }
        }
        case 1: {
            return self.submitButton;
        }
        default:
            return nil;
    }
}

#pragma mark -

- (void)registerNotifications {
    [self removeNotifications];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    //键盘显示通知
    [center addObserver:self
               selector:@selector(keyboardWillShow:)
                   name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self
               selector:@selector(keyboardWillHide:)
                   name:UIKeyboardWillHideNotification
                 object:nil];
    //UITextField文本变化通知
    [center addObserver:self
               selector:@selector(textDidChange)
                   name:UITextFieldTextDidChangeNotification
                 object:nil];
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self textFieldResignFirstResponder];
}

- (void)textFieldResignFirstResponder {
    [self.phoneNumInput resignFirstResponder];
    [self.verifyCodeInput resignFirstResponder];
    [self.passwordInput resignFirstResponder];
}

- (void)textDidChange {
    [self resetButtonEnable];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    if (CGRectGetHeight([UIScreen mainScreen].bounds) <= 480) {
        CGRect frame = self.tableView.frame;
        frame.origin.y = -25.f;
        [UITableView beginAnimations:nil context:nil];
        [UITableView setAnimationDuration:0.3f];
        self.tableView.frame = frame;
        [UITableView commitAnimations];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if (CGRectGetHeight([UIScreen mainScreen].bounds) <= 480) {
        CGRect frame = self.tableView.frame;
        frame.origin.y = 0;
        [UITableView beginAnimations:nil context:nil];
        [UITableView setAnimationDuration:0.3f];
        self.tableView.frame = frame;
        [UITableView commitAnimations];
    }
}

#pragma mark -

- (YXPhoneInputView *)phoneNumInput {
    if (!_phoneNumInput) {
        _phoneNumInput = [[YXPhoneInputView alloc] init];
        if (self.userName.length > 0 && self.type == YXLoginVerifyTypeResetPassword) {
            if ([self.userName yx_isPhoneNum]) {
                _phoneNumInput.text = self.userName;
            };
        }
        @weakify(self);
        _phoneNumInput.rightClick = ^{
            @strongify(self);
            if (!self) {
                return;
            }
            self.phoneNumInput.text = nil;
            [self resetButtonEnable];
        };
        
        _phoneNumInput.textChangeBlock = ^(NSString *text) {
            @strongify(self);
            if (!self) {
                return;
            }
            [self resetButtonEnable];
        };
    }
    return _phoneNumInput;
}

- (YXLoginInputView *)verifyCodeInput {
    if (!_verifyCodeInput) {
        _verifyCodeInput = [[YXLoginInputView alloc] init];
        _verifyCodeInput.keyboardType = UIKeyboardTypeNumberPad;
        _verifyCodeInput.placeholder = @"请输入验证码";
        [_verifyCodeInput setFrontImage:[UIImage imageNamed:@"密码"]];
        [_verifyCodeInput setRightButtonBackgroundImage:[[UIImage imageNamed:@"获取验证码按钮"] resizableImageWithCapInsets:UIEdgeInsetsMake(12, 12, 12, 12)] forState:UIControlStateNormal];
        [_verifyCodeInput setRightButtonBackgroundImage:[[UIImage imageNamed:@"获取验证码按钮-按下"] resizableImageWithCapInsets:UIEdgeInsetsMake(12, 12, 12, 12)] forState:UIControlStateHighlighted];
        [_verifyCodeInput setRightButtonText:@"获取验证码"];
        @weakify(self);
        _verifyCodeInput.rightClick = ^{
            @strongify(self);
            [self sendAgainAction:nil];
        };
        _verifyCodeInput.textChangeBlock = ^(NSString *text) {
            @strongify(self);
            if (text.length > 4) {
                self.verifyCodeInput.text = [text substringToIndex:4];
            }
        };
        [self resetSendAgainButtonTitle];
    }
    return _verifyCodeInput;
}


- (YXPasswordInputView *)passwordInput
{
    if (!_passwordInput) {
        _passwordInput = [[YXPasswordInputView alloc] init];
        _passwordInput.placeholder = @"请输入6~18位密码";
        [_passwordInput setShowPassword:YES];
    }
    return _passwordInput;
}

- (YXCommonButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [[YXCommonButton alloc] init];
        [_submitButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
        [self resetButtonEnable];
    }
    NSString *title = (self.type == YXLoginVerifyTypeRegister) ? @"注册":@"下一步";
    [_submitButton setTitle:title forState:UIControlStateNormal];
    return _submitButton;
}

- (void)sendAgainAction:(id)sender {
    [LoginUtils verifyMobileNumberFormat:self.phoneNumInput.text completeBlock:^(BOOL isEmpty, BOOL formatIsCorrect) {
        if (!formatIsCorrect) {
            [self yx_showToast:@"请输入正确的手机号码"];
            return;
        }
        [self getVerifyCodeRequest];
    }];
}

- (void)submitAction:(id)sender {
    [LoginUtils verifyMobileNumberFormat:self.phoneNumInput.text completeBlock:^(BOOL isEmpty, BOOL formatIsCorrect) {
        if (!formatIsCorrect) {
            [self yx_showToast:@"请输入正确的手机号码"];
            return;
        }
        if (self.type == YXLoginVerifyTypeRegister) {
            [self verifyPassword];
        } else {
            [self verifySMSCode];
        }
    }];
}

- (void)resetButtonEnable {
    
    __block BOOL enableVerifyButton;
    [LoginUtils verifyMobileNumberFormat:self.phoneNumInput.text completeBlock:^(BOOL isEmpty, BOOL formatIsCorrect) {
        enableVerifyButton = !isEmpty && formatIsCorrect;
    }];
    [self.verifyCodeInput setRightButtonEnabled:enableVerifyButton];
    
    __block BOOL verifyCodeFormatIsCorrect;
    [LoginUtils verifySMSCodeFormat:self.verifyCodeInput.text completeBlock:^(BOOL isEmpty, BOOL formatIsCorrect) {
        verifyCodeFormatIsCorrect = !isEmpty && formatIsCorrect;
    }];
    
    __block BOOL passwordFormatIsCorrect;
    [LoginUtils verifyPasswordFormat:self.passwordInput.text completeBlock:^(BOOL isEmpty, BOOL formatIsCorrect) {
        passwordFormatIsCorrect = !isEmpty && formatIsCorrect;
    }];
    
    BOOL enableRegisterButton;
    
    if (self.type == YXLoginVerifyTypeRegister) {
        enableRegisterButton = enableVerifyButton &&
        verifyCodeFormatIsCorrect &&
        passwordFormatIsCorrect;
    } else {
        enableRegisterButton = enableVerifyButton &&
        verifyCodeFormatIsCorrect;
    }
    
    self.submitButton.enabled =  enableRegisterButton;
}

#pragma mark -

- (void)getVerifyCodeRequest {
    if (self.timer) {
        return;
    }
    [self startTimer];
    NSString *type = [NSString stringWithFormat:@"%@", @(self.type)];
    WEAK_SELF
    [self yx_startLoading];
    [LoginDataManager getVerifyCodeWithMobileNumber:self.phoneNumInput.text verifyType:type completeBlock:^(HttpBaseRequestItem *item, NSError *error) {
        STRONG_SELF
        [self yx_stopLoading];
        if (error) {
            [self stopTimer];
            [self yx_showToast:error.localizedDescription];
        }
    }];
}

- (void)startTimer {
    if (!self.timer) {
        self.seconds = 45;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdownTimer) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)countdownTimer {
    if (self.seconds <= 0) {
        [self stopTimer];
    } else {
        [self.verifyCodeInput resetRightButtonText:[NSString stringWithFormat:@"%@秒", @(self.seconds)]];
        self.seconds--;
    }
}

- (void)stopTimer {
    [self resetSendAgainButtonTitle];
    [self.timer invalidate];
    self.timer = nil;
    self.seconds = 0;
}

- (void)resetSendAgainButtonTitle {
    if (self.timer) {
        [self.verifyCodeInput resetRightButtonText:@"再次发送"];
    } else {
        [self.verifyCodeInput resetRightButtonText:@"获取验证码"];
    }
}

- (void)registerAccount {
    
    AccountRegisterModel *model = [[AccountRegisterModel alloc]init];
    model.mobile = self.phoneNumInput.text;
    model.password = self.passwordInput.text;
    model.code = self.verifyCodeInput.text;
    model.type = [NSString stringWithFormat:@"%@", @(self.type)];
    WEAK_SELF
    [self yx_startLoading];
    [LoginDataManager registerAccountWithModel:model completeBlock:^(HttpBaseRequestItem *item, NSError *error) {
        STRONG_SELF
        [self yx_stopLoading];
        if (error) {
            [self yx_showToast:error.localizedDescription];
            return;
        }
        SearchClassViewController *vc = [[SearchClassViewController alloc] init];
        vc.phoneNum = self.phoneNumInput.text;
        vc.isThirdLogin = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)verifySMSCode {
    WEAK_SELF
    [self yx_startLoading];
    NSString *type = [NSString stringWithFormat:@"%@", @(self.type)];
    [LoginDataManager verifySMSCodeWithMobileNumber:self.phoneNumInput.text verifyCode:self.verifyCodeInput.text codeType:type completeBlock:^(HttpBaseRequestItem *item, NSError *error) {
        STRONG_SELF
        [self yx_stopLoading];
        if (error) {
            [self yx_showToast:error.localizedDescription];
            return;
        }
        if (self.type == YXLoginVerifyTypeRegister) {
            [self registerAccount];
        } else {
            [self resetPassword];
        }
    }];
}

- (void)verifyPassword {
    [LoginUtils verifyPasswordFormat:self.passwordInput.text completeBlock:^(BOOL isEmpty, BOOL formatIsCorrect) {
        if (!formatIsCorrect) {
            [self yx_showToast:@"请输入6~18位数字、字母或符号"];
            return;
        }
        [self verifySMSCode];
    }];
}

- (void)resetPassword {
    YXResetPasswordViewController *vc = [[YXResetPasswordViewController alloc] initWithType:YXPasswordOperationTypeReset phoneNumber:self.phoneNumInput.text];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.type == YXLoginVerifyTypeResetPassword) {
            return 2;
        } else {
            return 3;
        }
    }
    return 1;
}

@end
