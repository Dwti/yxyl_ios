//
//  YXAddToClassViewController.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/9/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "YXAddToClassViewController.h"
#import "UIColor+YXColor.h"
#import "YXJoinClassRequest.h"
#import "YXUserManager.h"
#import "YXUpdateUserInfoRequest.h"
#import "EEAlertView.h"
#import "NameView.h"
#import "UIView+YXScale.h"


@interface YXAddToClassViewController () <UITextFieldDelegate>

@property (nonatomic, strong) EEAlertView *alertView;
@property (nonatomic, strong) YXJoinClassRequest *joinRequest;
@property (nonatomic, strong) YXUpdateUserInfoRequest *updateRequest;
@property (nonatomic, strong) NameView *contentView;
@property (nonatomic, assign) BOOL isRequesting;

@end

@implementation YXAddToClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self yx_setupLeftCancelBarButtonItem];
    self.title = @"姓名";
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

- (void)setupUI
{
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"背景01"]];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    NameView *contentView = [NameView new];
    contentView.textField.delegate = self;
    self.contentView = contentView;
    
    self.alertView = [EEAlertView new];
    self.alertView.contentView = contentView;
    WEAK_SELF
    [[contentView.button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        [self okAction];
    }];

    [self.alertView showInView:self.view withLayout:^(AlertView *view) {
        [view.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset = 306 * [UIView scale];
            make.height.offset = 166;
            make.center.mas_equalTo(self.view);
        }];
    }];
    
    self.isRequesting = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self.contentView.textField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.contentView.textField resignFirstResponder];
}

- (void)okAction
{
    if (isEmpty(self.contentView.textField.text) && [self.data.status boolValue]) {
        [self yx_showToast:@"此班级需要审核，请填写真实姓名"];
        return;
    }
    
    if (!self.isRequesting) {
        [self yx_startLoading];
        self.isRequesting = YES;
        WEAK_SELF
        [ClassHomeworkDataManager joinClassWithClassID:self.data.gid verifyStatus:self.data.status verifyMessage:self.contentView.textField.text completeBlock:^(HttpBaseRequestItem *item, NSError *error) {
            STRONG_SELF
            [self yx_stopLoading];
            self.isRequesting = NO;
            if (error) {
                [self yx_showToast:error.localizedDescription];
                return;
            }else {
                if ([self.data needToVerify]) {
                    [self yx_showToast:@"\\(^o^)/ 提交成功，请等待老师审核"];
                }
                [self yx_leftCancelButtonPressed:nil];
            }
        }];
    }
}
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardFrame;
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    
    UIViewAnimationCurve curve = (UIViewAnimationCurve)((NSNumber *)[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey]).intValue;
    NSTimeInterval duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = curve << 16;
    [self.alertView layoutIfNeeded];
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        [self resetViewWithKeyboardHeight:CGRectGetHeight(keyboardFrame)/2.f];
        [self.alertView layoutIfNeeded];
    } completion:nil];
}

- (void)keyboardWillHidden:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    UIViewAnimationCurve curve = (UIViewAnimationCurve)((NSNumber *)[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey]).intValue;
    NSTimeInterval duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = curve << 16;
    [self.alertView layoutIfNeeded];
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        [self resetViewWithKeyboardHeight:0];
        [self.alertView layoutIfNeeded];
    } completion:nil];
}

- (void)resetViewWithKeyboardHeight:(CGFloat)keyboardHeight
{
    [self.alertView.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset = 306 * [UIView scale];
        make.height.offset = 166;
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-keyboardHeight);
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger textLength = textField.text.length;
    if (range.length == 0) {
        if (textLength > 24) {
            return NO;
        }
    }
    return YES;
}


@end
