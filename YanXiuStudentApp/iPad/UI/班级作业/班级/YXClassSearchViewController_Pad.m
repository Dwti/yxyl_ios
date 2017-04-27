//
//  YXClassSearchViewController_Pad.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/2/1.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXClassSearchViewController_Pad.h"
#import "YXAlertView.h"
#import "YXNumberField.h"
#import "UIView+YXScale.h"
#import "YXSearchClassRequest.h"
#import "YXClassInfoViewController_Pad.h"
#import "YXNavigationController_Pad.h"
#import "UIViewController+YXPresent.h"

@interface YXClassSearchViewController_Pad ()

@property (nonatomic, strong) YXNumberField *groupFiled;
@property (nonatomic, strong) YXAlertView *alertView;
@property (nonatomic, strong) YXSearchClassRequest *searchRequest;

@end

@implementation YXClassSearchViewController_Pad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"班级搜索";
    [self yx_setupLeftBackBarButtonItem];
    [self _setupUI];
    
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.groupFiled becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.groupFiled resignFirstResponder];
}

- (void)_setupUI {
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"作业背景"]];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    _groupFiled = [[YXNumberField alloc] initWithFrame:CGRectMake(0, 0, 266 * [UIView scale], 36 * [UIView scale])];
    _groupFiled.numberCount = 8;
    [[[_groupFiled.textField.rac_textSignal filter:^BOOL(id value) {
        return [value length] > 8;
    }] map:^id(id value) {
        return [value substringToIndex:8];
    }] subscribeNext:^(id x) {
        _groupFiled.text = x;
    }];
    
    _alertView = [YXAlertView alertWithMessage:@"请输入 8 位数字班级号码 ^_^" style:YXAlertStyleAlert contentSize:CGSizeMake(306, 166)];
    _alertView.keepInSuperview = YES;
    @weakify(self);
    [_alertView addButtonWithTitle:@"确认" action:^{
        @strongify(self);
        [self.view packUpKeyboard];
        [self okAction];
    }];
    [_alertView addContainerView:_groupFiled];
    [_alertView showInView:self.view];
}

- (void)okAction {
    NSString *classId = [self.groupFiled.text yx_stringByTrimmingCharacters];
    if ([classId stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]].length) {
        [self yx_showToast:@"班级号码格式错误"];
        return;
    }
    if (![classId yx_isValidString] || classId.length > 8 || classId.length < 6) {
        [self yx_showToast:@"请输入8位数字班级号码"];
        return;
    }
    @weakify(self);
    [self yx_startLoading];
    [self.searchRequest stopRequest];
    self.searchRequest = [[YXSearchClassRequest alloc] init];
    self.searchRequest.classId = classId;
    [self.searchRequest startRequestWithRetClass:[YXSearchClassItem class]
                            andCompleteBlock:^(id retItem, NSError *error) {
                                @strongify(self); if (!self) return;
                                [self yx_stopLoading];
                                if (error) {
                                    if (error.code == 2) {
                                        [self yx_showToast:@"不存在的班级号码"];
                                    } else {
                                        [self yx_showToast:error.localizedDescription];
                                    }
                                    return;
                                }
                                
                                YXSearchClassItem *ret = retItem;
                                if (![ret.data count]) {
                                    [self yx_showToast:@"不存在的班级号码"];
                                    return;
                                }
                                
                                YXSearchClassItem_Data *data = ret.data[0];
                                if ([data.status isEqual: @"2"]) {
                                    [self yx_showToast:@"该班级不允许加入"];
                                    return;
                                }
                                
                                YXClassInfoViewController_Pad *vc = [[YXClassInfoViewController_Pad alloc] init];
                                vc.actionType = YXClassActionTypeJoin;
                                vc.rawData = ret.data.firstObject;
                                YXNavigationController_Pad *nav = [[YXNavigationController_Pad alloc] initWithRootViewController:vc];
                                [self yx_presentViewController:nav completion:^{
                                    [self.groupFiled resignFirstResponder];
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
