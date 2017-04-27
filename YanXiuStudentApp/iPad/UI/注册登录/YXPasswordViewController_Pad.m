//
//  YXPasswordViewController_Pad.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/1/26.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXPasswordViewController_Pad.h"
#import "YXPasswordInputView.h"
#import "YXCommonButton.h"
#import "YXEditProfileViewController_Pad.h"
#import "YXResetPasswordRequest.h"

@interface YXPasswordViewController_Pad ()

@property (nonatomic, strong) YXPasswordInputView *passwordInput;
@property (nonatomic, strong) YXPasswordInputView *confirmPasswordInput;
@property (nonatomic, strong) YXCommonButton *submitButton;

@property (nonatomic, assign) YXPasswordOperationType type;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) YXResetPasswordRequest *request;

@end

@implementation YXPasswordViewController_Pad

- (instancetype)initWithType:(YXPasswordOperationType)type phoneNumber:(NSString *)phoneNumber
{
    if (self = [super init]) {
        self.type = type;
        self.phoneNumber = phoneNumber;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self yx_setupLeftBackBarButtonItem];
    
    switch (self.type) {
        case YXPasswordOperationTypeFirstSet:
        {
            self.title = @"设置密码";
            [self setHeaderView];
        }
            break;
        case YXPasswordOperationTypeReset:
            self.title = @"重置密码";
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
    [self removeNotifications];
    [self.request stopRequest];
}

- (UIView *)viewForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0:
                    return self.passwordInput;
                case 1:
                    return self.confirmPasswordInput;
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
    [[NSNotificationCenter defaultCenter] addObserver:self
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
    if ([[self password] yx_isValidString]
        && [[self confirmPassword] yx_isValidString]) {
        self.submitButton.enabled = YES;
    } else {
        self.submitButton.enabled = NO;
    }
}

#pragma mark -

- (void)setHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kYXLoginCellWidth, 60)];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = [UIFont systemFontOfSize:15.f];
    NSString *normalText = @"加油童鞋！还差%@完成注册";
    NSString *highlightText = @"两步";
    NSString *text = [NSString stringWithFormat:normalText, highlightText];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
    [string setAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:16.f]} range:[text rangeOfString:highlightText]];
    tipLabel.attributedText = string;
    [headerView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.left.right.bottom.mas_equalTo(0);
    }];
    self.tableView.tableHeaderView = headerView;
}

- (YXPasswordInputView *)passwordInput
{
    if (!_passwordInput) {
        _passwordInput = [[YXPasswordInputView alloc] init];
        _passwordInput.placeholder = @"请输入6~18位密码";
        [_passwordInput setShowPassword:NO];
    }
    return _passwordInput;
}

- (YXPasswordInputView *)confirmPasswordInput
{
    if (!_confirmPasswordInput) {
        _confirmPasswordInput = [[YXPasswordInputView alloc] init];
        _confirmPasswordInput.placeholder = @"再次输入密码";
        [_confirmPasswordInput setShowPassword:NO];
    }
    return _confirmPasswordInput;
}

- (YXCommonButton *)submitButton
{
    if (!_submitButton) {
        _submitButton = [[YXCommonButton alloc] init];
        NSString *title = (self.type == YXPasswordOperationTypeFirstSet) ? @"下一步":@"确认重置密码";
        [_submitButton setTitle:title forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
        [self resetButtonEnable];
    }
    return _submitButton;
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
    switch (self.type) {
        case YXPasswordOperationTypeReset:
        default:
            [self resetPasswordRequest];
            break;
        case YXPasswordOperationTypeFirstSet:
            [self presentEditProfileViewController];
            break;
    }
}

- (NSString *)password
{
    return [self.passwordInput.text yx_stringByTrimmingCharacters];
}

- (NSString *)confirmPassword
{
    return [self.confirmPasswordInput.text yx_stringByTrimmingCharacters];
}

- (void)presentEditProfileViewController
{
    YXEditProfileViewController_Pad *vc = [[YXEditProfileViewController_Pad alloc] init];
    [vc setMobile:self.phoneNumber password:[self password]];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -

- (void)resetPasswordRequest
{
    if (self.request) {
        [self.request stopRequest];
    }
    self.request = [[YXResetPasswordRequest alloc] init];
    self.request.mobile = self.phoneNumber;
    self.request.password = [self password];
    @weakify(self);
    [self yx_startLoading];
    [self.request startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        @strongify(self);
        [self yx_stopLoading];
        if (error) {
            [self yx_showToast:error.localizedDescription];
        } else {
            [self yx_showToast:@"重置密码成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
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
