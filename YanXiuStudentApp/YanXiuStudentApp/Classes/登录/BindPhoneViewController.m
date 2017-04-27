//
//  BindPhoneViewController.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 3/29/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "BindPhoneViewController.h"
#import "YXPhoneInputView.h"
#import "YXCommonButton.h"
#import "YXSettingViewController.h"

@interface BindPhoneViewController ()
@property (nonatomic, strong) YXPhoneInputView *phoneNumInput;
@property (nonatomic, strong) YXLoginInputView *verifyCodeInput;
@property (nonatomic, strong) YXCommonButton *submitButton;
@property (nonatomic, assign) BindMobileType type;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger seconds;
@property (nonatomic, strong) UILabel *tipsLabel;
@end

@implementation BindPhoneViewController

- (instancetype)initWithType:(BindMobileType)type {
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self resetButtonEnable];
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

#pragma mark - UI 
- (void)setupUI {
    [self setupTitle];
    [self yx_setupLeftBackBarButtonItem];
    [self setupPhoneInputView];
    [self setupSubmitButton];
    [self setupVerifyCodeView];
    [self setupTipsLabel];
}

- (void)setupTitle {
    if (self.type == BindMobileTypeVerify) {
        self.title = @"手机验证";
    } else if (self.type == BindMobileTypeBind) {
        self.title = @"绑定手机";
    } else if (self.type == BindMobileTypeRebind) {
        self.title = @"填写新手机";
    }
}

- (void)setupPhoneInputView {
    self.phoneNumInput = [[YXPhoneInputView alloc] init];
    
    if (self.type == BindMobileTypeVerify) {
        self.phoneNumInput.rightButton.hidden = YES;
        self.phoneNumInput.enabled = NO;
        self.phoneNumInput.text = [self mobileNumber];
    } else {
        self.phoneNumInput.rightButton.hidden = NO;
    }
    WEAK_SELF
    self.phoneNumInput.rightClick = ^{
        STRONG_SELF
        self.phoneNumInput.text = nil;
        [self resetButtonEnable];
    };
    
    self.phoneNumInput.textChangeBlock = ^(NSString *text) {
        STRONG_SELF
        [self resetButtonEnable];
    };
}

- (NSString *)mobileNumber {
    NSMutableString *mobile = [NSMutableString stringWithString:[YXUserManager sharedManager].userModel.mobile];
    [mobile insertString:@" " atIndex:3];
    [mobile insertString:@" " atIndex:8];
    return mobile;
}

- (void)setupSubmitButton {
    self.submitButton = [[YXCommonButton alloc] init];
    if (self.type == BindMobileTypeVerify) {
        [self.submitButton setTitle:@"下一步" forState:UIControlStateNormal];
    } else {
        [self.submitButton setTitle:@"确定" forState:UIControlStateNormal];
    }
    [self.submitButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    [self resetButtonEnable];
}

- (void)setupVerifyCodeView {
    self.verifyCodeInput = [[YXLoginInputView alloc] init];
    self.verifyCodeInput.keyboardType = UIKeyboardTypeNumberPad;
    //self.verifyCodeInput.rightButton.enabled = NO;
    self.verifyCodeInput.placeholder = @"请输入验证码";
    [self.verifyCodeInput setFrontImage:[UIImage imageNamed:@"密码"]];
    [self.verifyCodeInput setRightButtonBackgroundImage:[[UIImage imageNamed:@"获取验证码按钮"] resizableImageWithCapInsets:UIEdgeInsetsMake(12, 12, 12, 12)] forState:UIControlStateNormal];
    [self.verifyCodeInput setRightButtonBackgroundImage:[[UIImage imageNamed:@"获取验证码按钮-按下"] resizableImageWithCapInsets:UIEdgeInsetsMake(12, 12, 12, 12)] forState:UIControlStateHighlighted];
    [self.verifyCodeInput setRightButtonText:@"获取验证码"];
    @weakify(self);
    self.verifyCodeInput.rightClick = ^{
        @strongify(self);
        [self sendAgainAction:nil];
    };
    self.verifyCodeInput.textChangeBlock = ^(NSString *text) {
        @strongify(self)
        if (text.length > 4) {
            self.verifyCodeInput.text = [text substringToIndex:4];
        }
    };
    [self resetSendAgainButtonTitle];
}

- (void)setupTipsLabel {
    if (self.type == BindMobileTypeVerify) {
        self.tipsLabel = [[UILabel alloc] init];
        self.tipsLabel.text = @"若手机号不可用，请拨打客服电话：400-870-6696";
        self.tipsLabel.font = [UIFont systemFontOfSize:12];
        self.tipsLabel.textColor = [UIColor whiteColor];
        self.tipsLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:self.tipsLabel];
        [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(-10);
        }];
    }
}

#pragma mark - Helper
- (UIView *)viewForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0:
                    return self.phoneNumInput;
                case 1:
                    return self.verifyCodeInput;
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


#pragma mark - Notification
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
}


#pragma mark - Action
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
        [self verifySMSCode];
    }];
}


#pragma mark - Request
- (void)getVerifyCodeRequest {
    if (self.timer) {
        return;
    }
    [self startTimer];
    WEAK_SELF
    [self yx_startLoading];
    NSString *type = @"0";
    if (self.type == BindMobileTypeVerify) {
        type = @"1";
    }
    if (self.type == BindMobileTypeBind) {
        type = @"0";
    }
    if (self.type == BindMobileTypeRebind) {
        type = @"0";
    }
    
    [LoginDataManager getVerifyCodeByBindWithMobileNumber:self.phoneNumInput.text verifyType:type completeBlock:^(HttpBaseRequestItem *item, NSError *error) {
        STRONG_SELF
        [self yx_stopLoading];
        if (error) {
            [self stopTimer];
            [self yx_showToast:error.localizedDescription];
        }
    }];
}

- (void)verifySMSCode {
    WEAK_SELF
    [self yx_startLoading];
    if (self.type == BindMobileTypeVerify) {
        [LoginDataManager verifyBindedMobileNumber:self.phoneNumInput.text verifyCode:self.verifyCodeInput.text completeBlock:^(HttpBaseRequestItem *item, NSError *error) {
            STRONG_SELF
            [self yx_stopLoading];
            if (error) {
                [self yx_showToast:error.localizedDescription];
                return;
            }
            BindPhoneViewController *vc = [[BindPhoneViewController alloc] initWithType:BindMobileTypeRebind];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
    } else {
        [LoginDataManager bindNewMobileWithNumber:self.phoneNumInput.text verifyCode:self.verifyCodeInput.text completeBlock:^(HttpBaseRequestItem *item, NSError *error) {
            STRONG_SELF
            [self yx_stopLoading];
            if (error) {
                [self yx_showToast:error.localizedDescription];
                return;
            }
            if (self.type == BindMobileTypeBind) {
                [self yx_showToast:@"绑定成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"bind success" object:nil];
                [YXUserManager sharedManager].userModel.mobile = self.phoneNumInput.text;
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self.navigationController popViewControllerAnimated:YES];
//                });
            } else if (self.type == BindMobileTypeRebind) {
                [self yx_showToast:@"更换绑定成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"rebind success" object:nil];
                [YXUserManager sharedManager].userModel.mobile = self.phoneNumInput.text;
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self backToViewController:@"YXSettingViewController"];
//                });
            }
        }];
    }
}


#pragma mark - Timer
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


#pragma mark - Helper
- (void)resetButtonEnable {
    __block BOOL enableVerifyButton;
    [LoginUtils verifyMobileLength:self.phoneNumInput.text completeBlock:^(BOOL isEmpty, BOOL formatIsCorrect) {
        enableVerifyButton = !isEmpty && formatIsCorrect;
    }];
    
    [self.verifyCodeInput setRightButtonEnabled:enableVerifyButton];
    
    __block BOOL verifyCodeFormatIsCorrect;
    [LoginUtils verifySMSCodeFormat:self.verifyCodeInput.text completeBlock:^(BOOL isEmpty, BOOL formatIsCorrect) {
        verifyCodeFormatIsCorrect = !isEmpty && formatIsCorrect;
    }];
    
    self.submitButton.enabled =  enableVerifyButton && verifyCodeFormatIsCorrect;
}

- (void)resetSendAgainButtonTitle {
    if (self.timer) {
        [self.verifyCodeInput resetRightButtonText:@"再次发送"];
    } else {
        [self.verifyCodeInput resetRightButtonText:@"获取验证码"];
    }
}

- (void)backToViewController:(NSString *)controllerName {
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:NSClassFromString(controllerName)]) {
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    return 1;
}

@end
