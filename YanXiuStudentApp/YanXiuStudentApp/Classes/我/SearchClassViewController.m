//
//  SearchClassViewController.m
//  YanXiuStudentApp
//
//  Created by FanYu on 11/1/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import "SearchClassViewController.h"
#import "YXNumberField.h"
#import "UIView+YXScale.h"
#import "YXSearchClassRequest.h"
#import "YXEditProfileViewController.h"
#import "JoinClassViewController.h"
#import "SearchClassPromptView.h"
#import "ClassHomeworkUtils.h"
@interface SearchClassViewController ()

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) EEAlertView *alertView;
@property (nonatomic, strong) SearchClassPromptView *promptView;

@end

@implementation SearchClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"加入班级";
    
    [self yx_setupLeftBackBarButtonItem];
    [self registerNotification];
    [self setupUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.promptView.groupFiled becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.promptView.groupFiled resignFirstResponder];
    [self.promptView endEditing:YES];
}

- (void)setupUI {    
    self.bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"桌面"]];
    self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.alertView = [[EEAlertView alloc] init];
    self.alertView.maskColor = [UIColor clearColor];
    
    self.promptView = [[SearchClassPromptView alloc] init];
    WEAK_SELF
    [self.promptView setNextAction:^{
        STRONG_SELF
        [self.view packUpKeyboard];
        [self nextStepAction];
    }];
    
    [self.promptView setSkipAction:^{
        STRONG_SELF
        [self.promptView.groupFiled resignFirstResponder];
        
        YXEditProfileViewController *vc = [[YXEditProfileViewController alloc] init];
        vc.mobile = self.phoneNum;
        vc.isThirdLogin = self.isThirdLogin;
        if (self.isThirdLogin) {
            vc.thirdLoginParams = self.thirdLoginParams;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    self.alertView.contentView = self.promptView;
    
    [self.alertView showInView:self.view withLayout:^(AlertView *view) {
        [view.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(306 * [UIView scale]);
            make.center.mas_equalTo(0);
        }];
        [view layoutIfNeeded];
    }];
}

- (void)registerNotification {
    WEAK_SELF;
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
        STRONG_SELF;
        [self keyboardWillShow:x];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil] subscribeNext:^(id x) {
        STRONG_SELF;
        [self keyboardWillHidden:x];
    }];
}

- (void)nextStepAction {
    [self.promptView.groupFiled resignFirstResponder];
    
    if (![ClassHomeworkUtils classNumberFormatIsCorrect:self.promptView.text]) {
        [self yx_showToast:@"班级号码格式错误"];
        return;
    }
    if (![ClassHomeworkUtils classNumberLengthIsCorrect:self.promptView.text]) {
        [self yx_showToast:@"请输入8位数字班级号码"];
        return;
    }
    
    NSString *classId = [self.promptView.text yx_stringByTrimmingCharacters];
    WEAK_SELF
    [self yx_startLoading];
    [ClassHomeworkDataManager searchClassWithClassID:classId completeBlock:^(YXSearchClassItem *item, NSError *error) {
        STRONG_SELF
        [self yx_stopLoading];
        if (error) {
            [self yx_showToast:error.localizedDescription];
            return;
        }
        YXSearchClassItem_Data *data = item.data[0];
        data.mobile = self.phoneNum;
        JoinClassViewController *vc = [[JoinClassViewController alloc] init];
        vc.actionType = YXClassActionTypeJoin;
        vc.rawData = data;
        vc.isThirdLogin = self.isThirdLogin;
        if (self.isThirdLogin) {
            vc.thirdLoginParams = self.thirdLoginParams;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)setThirdLoginParams:(NSDictionary *)params {
    _thirdLoginParams = params;
}

- (void)keyboardWillShow:(NSNotification *)notification {
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

- (void)keyboardWillHidden:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    UIViewAnimationCurve curve = (UIViewAnimationCurve)((NSNumber *)[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey]).intValue;
    NSTimeInterval duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = curve << 16;
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        [self resetViewWithKeyboardHeight:0];
    } completion:nil];
}

- (void)resetViewWithKeyboardHeight:(CGFloat)keyboardHeight {
    [self.alertView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(306 * [UIView scale]);
        make.height.mas_equalTo(208);
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-keyboardHeight);
        
    }];
}

@end
