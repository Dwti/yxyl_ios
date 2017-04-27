//
//  YXModifyPasswordViewController.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/13.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXModifyPasswordViewController.h"
#import "YXPasswordInputView.h"
#import "YXCommonButton.h"
#import "YXModifyPasswordRequest.h"
#import "YXLoginCell.h"

@interface YXModifyPasswordViewController ()

@property (nonatomic, strong) YXPasswordInputView *oldPasswordInput;
@property (nonatomic, strong) YXPasswordInputView *passwordInput;
@property (nonatomic, strong) YXPasswordInputView *confirmPasswordInput;
@property (nonatomic, strong) YXCommonButton *submitButton;

@end

@implementation YXModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改密码";
    [self yx_setupLeftBackBarButtonItem];
    [self.tableView registerClass:[YXLoginCell class] forCellReuseIdentifier:kYXLoginCellIdentifier];
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
    [self removeNotifications];
}

- (YXPasswordInputView *)oldPasswordInput
{
    if (!_oldPasswordInput) {
        _oldPasswordInput = [[YXPasswordInputView alloc] init];
        _oldPasswordInput.placeholder = @"请输入当前密码";
        [_oldPasswordInput setShowPassword:NO];
    }
    return _oldPasswordInput;
}

- (YXPasswordInputView *)passwordInput
{
    if (!_passwordInput) {
        _passwordInput = [[YXPasswordInputView alloc] init];
        _passwordInput.placeholder = @"请输入新的密码";
        [_passwordInput setShowPassword:NO];
    }
    return _passwordInput;
}

- (YXPasswordInputView *)confirmPasswordInput
{
    if (!_confirmPasswordInput) {
        _confirmPasswordInput = [[YXPasswordInputView alloc] init];
        _confirmPasswordInput.placeholder = @"请确认新的密码";
        [_confirmPasswordInput setShowPassword:NO];
    }
    return _confirmPasswordInput;
}

- (YXCommonButton *)submitButton
{
    if (!_submitButton) {
        _submitButton = [[YXCommonButton alloc] init];
        [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
        [self resetButtonEnable];
    }
    return _submitButton;
}


#pragma mark -

- (void)registerNotifications
{
    [self removeNotifications];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(keyboardWillShow:)
                   name:UIKeyboardWillShowNotification
                 object:nil];
    [center addObserver:self
               selector:@selector(keyboardWillHide:)
                   name:UIKeyboardWillHideNotification
                 object:nil];
    [center addObserver:self
               selector:@selector(textDidChange)
                   name:UITextFieldTextDidChangeNotification
                 object:nil];
}

- (void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.passwordInput resignFirstResponder];
    [self.confirmPasswordInput resignFirstResponder];
}

- (void)textDidChange
{
    [self resetButtonEnable];
}

- (void)resetButtonEnable
{
    if ([[self oldPassword] yx_isValidString]
        && [[self password] yx_isValidString]
        && [[self confirmPassword] yx_isValidString]) {
        self.submitButton.enabled = YES;
    } else {
        self.submitButton.enabled = NO;
    }
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    if (CGRectGetHeight([UIScreen mainScreen].bounds) <= 480) {
        self.tableView.contentSize = CGSizeMake(0, CGRectGetHeight(self.view.bounds) + 100);
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if (CGRectGetHeight([UIScreen mainScreen].bounds) <= 480) {
        self.tableView.contentSize = CGSizeMake(0, CGRectGetHeight(self.view.bounds));
    }
}

#pragma mark -

- (void)submitAction:(id)sender
{
    NSString *password = [self password];
    NSString *confirmPassword = [self confirmPassword];
    if (password.length < 6 || password.length > 18) {
        [self yx_showToast:@"请输入6~18位密码"];
        return;
    }
    if (![password isEqualToString:confirmPassword]) {
        [self yx_showToast:@"两次密码不一致"];
        return;
    }
    
    [self resetPasswordRequest];
}

- (UIView *)viewForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                    return self.oldPasswordInput;
                case 1:
                    return self.passwordInput;
                case 2:
                    return self.confirmPasswordInput;
                default:
                    return nil;
            }
        }
        case 1:
            return self.submitButton;
        default:
            return nil;
    }
    
}

- (NSString *)oldPassword
{
    return [self.oldPasswordInput.text yx_stringByTrimmingCharacters];
}

- (NSString *)password
{
    return [self.passwordInput.text yx_stringByTrimmingCharacters];
}

- (NSString *)confirmPassword
{
    return [self.confirmPasswordInput.text yx_stringByTrimmingCharacters];
}

#pragma mark -

- (void)resetPasswordRequest
{
    WEAK_SELF
    [self yx_startLoading];
    [LoginDataManager modifyPasswordWithOldPassword:[self oldPassword] newPassword:[self password] completeBlock:^(YXModifyPasswordItem *item, NSError *error) {
        STRONG_SELF
        [self yx_stopLoading];
        if (error) {
            [self yx_showToast:error.localizedDescription];
            return;
        }
        if (item.data.count > 0) {
            [self yx_leftBackButtonPressed:nil];
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
        return 3;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YXLoginCell *cell = [tableView dequeueReusableCellWithIdentifier:kYXLoginCellIdentifier];
    cell.containerView = [self viewForRowAtIndexPath:indexPath];
    cell.showLine = [self showLineAtIndexPath:indexPath];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat defaultHeight = 60.f;
    if ([self showLineAtIndexPath:indexPath]) {
        defaultHeight += 2.f;
    }
    return defaultHeight;
}


@end
