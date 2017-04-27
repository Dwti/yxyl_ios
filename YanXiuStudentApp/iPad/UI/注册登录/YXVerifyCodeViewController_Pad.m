//
//  YXVerifyCodeViewController_Pad.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/1/26.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXVerifyCodeViewController_Pad.h"
#import "YXPhoneInputView.h"
#import "YXCommonButton.h"
#import "UIImage+YXImage.h"
#import "UIButton+YXButton.h"

#import "YXProduceCodeRequest.h"
#import "YXVerifySMSCodeRequest.h"
#import "YXRecordManager.h"

#import "YXPasswordViewController_Pad.h"

@interface YXVerifyCodeViewController_Pad ()

@property (nonatomic, assign) YXLoginVerifyType type;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) YXPhoneInputView *phoneNumInput;
@property (nonatomic, strong) YXLoginInputView *verifyCodeInput;
@property (nonatomic, strong) YXCommonButton *submitButton;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger seconds;

@property (nonatomic, strong) YXProduceCodeRequest *produceCodeRequest;
@property (nonatomic, strong) YXVerifySMSCodeRequest *verifySMSCodeRequest;

@end

@implementation YXVerifyCodeViewController_Pad

- (instancetype)initWithType:(YXLoginVerifyType)type userName:(NSString *)userName
{
    if (self = [super init]) {
        self.type = type;
        self.userName = userName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self yx_setupLeftBackBarButtonItem];
    
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerNotifications];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.produceCodeRequest stopRequest];
    [self.verifySMSCodeRequest stopRequest];
    [self removeNotifications];
}

- (UIView *)viewForRowAtIndexPath:(NSIndexPath *)indexPath
{
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

#pragma mark -

- (void)registerNotifications
{
    [self removeNotifications];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    //UITextField文本变化通知
    [center addObserver:self
               selector:@selector(textDidChange)
                   name:UITextFieldTextDidChangeNotification
                 object:nil];
}

- (void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self textFieldResignFirstResponder];
}

- (void)textFieldResignFirstResponder
{
    [self.phoneNumInput resignFirstResponder];
    [self.verifyCodeInput resignFirstResponder];
}

- (void)textDidChange
{
    [self resetButtonEnable];
}

#pragma mark -

- (YXPhoneInputView *)phoneNumInput
{
    if (!_phoneNumInput) {
        _phoneNumInput = [[YXPhoneInputView alloc] init];
        if (self.userName.length > 0 && self.type == YXLoginVerifyTypeResetPassword) {
            _phoneNumInput.text = self.userName;
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
    }
    return _phoneNumInput;
}

- (YXLoginInputView *)verifyCodeInput
{
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
            if (text.length > 6) {
                self.verifyCodeInput.text = [text substringToIndex:6];
            }
        };
        [self resetSendAgainButtonTitle];
    }
    return _verifyCodeInput;
}

- (YXCommonButton *)submitButton
{
    if (!_submitButton) {
        _submitButton = [[YXCommonButton alloc] init];
        [_submitButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
        [self resetButtonEnable];
    }
    NSString *title = (self.type == YXLoginVerifyTypeRegister) ? @"提交":@"下一步";
    [_submitButton setTitle:title forState:UIControlStateNormal];
    return _submitButton;
}

- (void)sendAgainAction:(id)sender
{
    [self textFieldResignFirstResponder];
    if (![[self phoneNum] yx_isPhoneNum]) {
        [self yx_showToast:@"请输入正确手机号"];
        return;
    }
    [self getVerifyCodeRequest];
}

- (void)submitAction:(id)sender
{
    [self textFieldResignFirstResponder];
    if (![[self phoneNum] yx_isPhoneNum]) {
        [self yx_showToast:@"请输入正确手机号"];
        return;
    }
    [self verifySMSCode];
}

- (void)resetButtonEnable
{
    self.submitButton.enabled = [[self verifyCode] yx_isValidString] ? YES:NO;
    [self.verifyCodeInput setRightButtonEnabled:([[self phoneNum] yx_isValidString] ? YES:NO)];
}

//- (NSString *)verifyCode
//{
//    return [self.verifyCodeInput.text yx_stringByTrimmingCharacters];
//}

//- (NSString *)phoneNum
//{
//    NSString *phoneNum = [self.phoneNumInput.text yx_stringByTrimmingCharacters];
//    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@" " withString:@""];
//    return phoneNum;
//}

#pragma mark -

- (void)getVerifyCodeRequest
{
    if (self.timer) {
        return;
    }
    [self startTimer];
    
    if (self.produceCodeRequest) {
        [self.produceCodeRequest stopRequest];
    }
    self.produceCodeRequest = [[YXProduceCodeRequest alloc] init];
    self.produceCodeRequest.mobile = self.phoneNum;
    self.produceCodeRequest.type = [NSString stringWithFormat:@"%@", @(self.type)];
    @weakify(self);
    [self yx_startLoading];
    [self.produceCodeRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        @strongify(self);
        [self yx_stopLoading];
        if (error) {
            [self stopTimer];
            [self yx_showToast:error.localizedDescription];
        }
    }];
}

- (void)startTimer
{
    if (!self.timer) {
        self.seconds = 45;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdownTimer) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)countdownTimer
{
    if (self.seconds <= 0) {
        [self stopTimer];
    } else {
        [self.verifyCodeInput resetRightButtonText:[NSString stringWithFormat:@"%@秒", @(self.seconds)]];
        self.seconds--;
    }
}

- (void)stopTimer
{
    [self resetSendAgainButtonTitle];
    [self.timer invalidate];
    self.timer = nil;
    self.seconds = 0;
}

- (void)resetSendAgainButtonTitle
{
    if (self.timer) {
        [self.verifyCodeInput resetRightButtonText:@"再次发送"];
    } else {
        [self.verifyCodeInput resetRightButtonText:@"获取验证码"];
    }
}

- (void)verifySMSCode
{
    [self textFieldResignFirstResponder];
    if (self.verifySMSCodeRequest) {
        [self.verifySMSCodeRequest stopRequest];
    }
    self.verifySMSCodeRequest = [[YXVerifySMSCodeRequest alloc] init];
    self.verifySMSCodeRequest.mobile = self.phoneNum;
    self.verifySMSCodeRequest.code = self.verifyCode;
    self.verifySMSCodeRequest.type = [NSString stringWithFormat:@"%@", @(self.type)];
    @weakify(self);
    [self yx_startLoading];
    [self.verifySMSCodeRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        @strongify(self);
        [self yx_stopLoading];
        if (error) {
            [self yx_showToast:error.localizedDescription];
        } else {
            YXPasswordOperationType type = (self.type == YXLoginVerifyTypeRegister) ? YXPasswordOperationTypeFirstSet : YXPasswordOperationTypeReset;
            YXPasswordViewController_Pad *vc = [[YXPasswordViewController_Pad alloc] initWithType:type phoneNumber:self.phoneNum];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    return 1;
}

@end
