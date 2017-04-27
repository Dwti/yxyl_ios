//
//  YXSearchClassViewController.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/9/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "YXSearchClassViewController.h"
#import "YXClassInfoViewController.h"
#import "EEAlertView.h"
#import "UIView+YXScale.h"
#import "YXSearchClassRequest.h"
#import "ClassHomeworkUtils.h"
#import "SearchClassView.h"

@interface YXSearchClassViewController ()

@property (nonatomic, strong) EEAlertView *alertView;

@property (nonatomic, strong) SearchClassView *containerView;


@end

@implementation YXSearchClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self yx_setupLeftBackBarButtonItem];
    self.title = @"班级搜索";
    
    [self _setupUI];
    
    @weakify(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
        @strongify(self)
        [self keyboardWillShow:x];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil] subscribeNext:^(id x) {
        @strongify(self)
        [self keyboardWillHidden:x];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self.containerView.groupFiled becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)_setupUI {
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"背景01"]];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.alertView = [[EEAlertView alloc] init];
    self.alertView.maskColor = [UIColor clearColor];
    
    self.containerView = [[SearchClassView alloc] init];
    self.alertView.contentView = self.containerView;
    
    [self.containerView.nextStepButton addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];

    [self setupLayout];
}

- (void)setupLayout{
    [self.alertView showInView:self.view withLayout:^(AlertView *view) {
        [view.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(306 * [UIView scale]);
            make.height.mas_equalTo(170);
            make.center.mas_equalTo(0);
        }];
        [view layoutIfNeeded];
    }];
}

- (void)okAction {
    if (![ClassHomeworkUtils classNumberFormatIsCorrect:self.containerView.text]) {
        [self yx_showToast:@"班级号码格式错误"];
        return;
    }
    if (![ClassHomeworkUtils classNumberLengthIsCorrect:self.containerView.text]) {
        [self yx_showToast:@"请输入8位数字班级号码"];
        return;
    }
    [self yx_startLoading];
    WEAK_SELF
    [ClassHomeworkDataManager searchClassWithClassID:self.containerView.text completeBlock:^(YXSearchClassItem *item, NSError *error) {
        STRONG_SELF
        [self yx_stopLoading];
        if (error) {
            [self yx_showToast:error.localizedDescription];
            return;
        }
        YXClassInfoViewController *vc = [[YXClassInfoViewController alloc] init];
        vc.actionType = YXClassActionTypeJoin;
        vc.rawData = item.data.firstObject;
        [self.parentViewController presentViewController:[[YXNavigationController alloc] initWithRootViewController:vc] animated:YES completion:^{
            // 跳转到作业首页
            [self.navigationController popViewControllerAnimated:NO];
        }];
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
        make.width.mas_equalTo(306 * [UIView scale]);
        make.height.mas_equalTo(170);
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-keyboardHeight);
    }];
}

@end
