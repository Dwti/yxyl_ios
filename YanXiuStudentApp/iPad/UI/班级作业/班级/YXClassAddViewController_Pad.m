//
//  YXClassAddViewController_Pad.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/2/1.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXClassAddViewController_Pad.h"
#import "YXAlertView.h"
#import "UIView+YXScale.h"
#import "UIColor+YXColor.h"
#import "YXJoinClassRequest.h"
#import "YXUpdateUserInfoRequest.h"
#import "UIViewController+YXPresent.h"

@interface YXClassAddViewController_Pad ()

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) YXAlertView *alertView;

@property (nonatomic, strong) YXJoinClassRequest *joinRequest;
@property (nonatomic, strong) YXUpdateUserInfoRequest *updateRequest;

@end

@implementation YXClassAddViewController_Pad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"姓名";
    [self yx_setupLeftCancelBarButtonItem];
    [self setupUI];
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self keyboardWillShow:x];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self keyboardWillHidden:x];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)yx_leftCancelButtonPressed:(id)sender
{
    [self.parentViewController.navigationController popToRootViewControllerAnimated:NO];
    [self yx_dismiss];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.textField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.textField resignFirstResponder];
}

- (void)setupUI
{
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"作业背景"]];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 266 * [UIView scale], 36 * [UIView scale])];
    
    UIImageView *inputBGView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"输入框"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 6, 8, 6)]];
    inputBGView.frame = self.containerView.bounds;
    [self.containerView addSubview:inputBGView];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectInset(self.containerView.bounds, 10, 0)];
    self.textField.tintColor = [UIColor whiteColor];
    self.textField.defaultTextAttributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.f],
                                             NSForegroundColorAttributeName: [UIColor whiteColor],
                                             NSShadowAttributeName: [self textShadow]};
    [self.containerView addSubview:self.textField];
    
    self.alertView = [YXAlertView alertWithMessage:@"请输入真实姓名，确保通过老师审核" style:YXAlertStyleAlert contentSize:CGSizeMake(306, 166)];
    self.alertView.keepInSuperview = YES;
    @weakify(self);
    self.textField.text = [YXUserManager sharedManager].userModel.realname;
    [self.alertView addButtonWithTitle:@"确定" action:^{
        @strongify(self);
        [self okAction];
    }];
    [self.alertView addContainerView:self.containerView];
    [self.alertView showInView:self.view];
}

- (NSShadow *)textShadow
{
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0, 1); //垂直投影
    shadow.shadowColor = [UIColor yx_colorWithHexString:@"a37a00"];
    return shadow;
}

- (void)okAction
{
    if (isEmpty(self.textField.text) && [self.data.status boolValue]) {
        [self yx_showToast:@"此班级需要审核，请填写真实姓名"];
        return;
    }
    [self.joinRequest stopRequest];
    self.joinRequest = [[YXJoinClassRequest alloc] init];
    self.joinRequest.classId = self.data.gid;
    self.joinRequest.needCheck = self.data.status;
    self.joinRequest.validMsg = self.textField.text;
    @weakify(self);
    [self yx_startLoading];
    [self.joinRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        @strongify(self);
        [self yx_stopLoading];
        HttpBaseRequestItem *item = retItem;
        if (error && !item) {
            [self yx_showToast:error.localizedDescription];
        } else {
            if ([self.data.status boolValue]) {
                [self yx_showTipsWithTitle:@"\\(^o^)/" text:@"提交成功，请等待老师审核" detailText:nil];
            }
            self.updateRequest = [YXUpdateUserInfoRequest new];
            self.updateRequest.realname = self.textField.text;
            [self.updateRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
                HttpBaseRequestItem *item = retItem;
                if (error && !item) {
                    [self yx_showToast:error.localizedDescription];
                }else{
                    [YXUserManager sharedManager].userModel.realname = self.textField.text;
                    [[YXUserManager sharedManager] saveUserData];
                    [self yx_leftCancelButtonPressed:nil];
                }
            }];
            [[NSNotificationCenter defaultCenter] postNotificationName:YXJoinClassSuccessNotification object:nil];
        }
    }];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardFrame;
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    
    UIViewAnimationCurve curve = (UIViewAnimationCurve)((NSNumber *)[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey]).intValue;
    NSTimeInterval duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = curve << 16;
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        [self resetViewWithKeyboardHeight:CGRectGetHeight(keyboardFrame)/2.f];
    } completion:nil];
}

- (void)keyboardWillHidden:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    UIViewAnimationCurve curve = (UIViewAnimationCurve)((NSNumber *)[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey]).intValue;
    NSTimeInterval duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = curve << 16;
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        [self resetViewWithKeyboardHeight:0];
    } completion:nil];
}

- (void)resetViewWithKeyboardHeight:(CGFloat)keyboardHeight
{
    CGRect frame = self.alertView.frame;
    frame.origin.y = -keyboardHeight;
    self.alertView.frame = frame;
}

@end
