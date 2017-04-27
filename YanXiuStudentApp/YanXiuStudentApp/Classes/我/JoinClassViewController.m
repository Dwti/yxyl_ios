//
//  JoinClassViewController.m
//  YanXiuStudentApp
//
//  Created by FanYu on 11/1/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import "JoinClassViewController.h"
#import "YXClassInfoMock.h"
#import "YXCommonLabel.h"
#import "UIView+YXScale.h"
#import "UIColor+YXColor.h"
#import "UIImage+YXResize.h"
#import "YXDottedLineView+YXShadowLineMethod.h"
#import "YXLoginInputView.h"
#import "TextInputView.h"
#import "RegisterByJoinClassRequest.h"
#import "YXRecordManager.h"
#import "ThirdRegisterByJoinClassRequest.h"
#import "YXSSOAuthDefine.h"
#import "JoinClassPromptView.h"

@interface JoinClassViewController ()

@property (nonatomic, strong) UIScrollView *bottomScrollView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) EEAlertView *alertView;
@property (nonatomic, strong) JoinClassPromptView *promptView;
@property (nonatomic, strong) YXClassInfoMock *data;


@end

@implementation JoinClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"加入班级";
    
    [self yx_setupLeftBackBarButtonItem];
    [self setupUI];
    [self registerNotifications];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.promptView.inputView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.promptView.inputView resignFirstResponder];
}

- (void)registerNotifications {
    WEAK_SELF;
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
        STRONG_SELF;
        [self keyboardWillShow:x];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil] subscribeNext:^(id x) {
        STRONG_SELF;
        [self keyboardWillHide:x];
    }];
}

- (void)askToJoinAction {
    if ([self.rawData isMemeberFull]) {
        [self yx_showToast:@"班级已满，不能申请"];
        return;
    }
    
    if (self.isThirdLogin) {
        [self startThirdLogin];
    } else {
        [self startRegisterRequest];
    }
}

- (void)startRegisterRequest {
    RegisterByJoinClassModel *model = [[RegisterByJoinClassModel alloc]init];
    model.mobile = self.rawData.mobile;
    model.realname = self.promptView.inputView.text;
    model.provinceid = self.rawData.provinceid;
    model.cityid = self.rawData.cityid;
    model.areaid = self.rawData.areaid;
    model.stageid = self.rawData.stageid;
    model.schoolName = self.rawData.schoolname;
    model.schoolid = self.rawData.schoolid;
    model.classId = self.rawData.gid;
    model.validKey = [[NSString stringWithFormat:@"%@&%@", self.rawData.mobile, @"yxylmobile"] md5];

    WEAK_SELF
    [self yx_startLoading];
    [LoginDataManager registerByJoinClassWithModel:model completeBlock:^(RegisterRequestItem *item, NSError *error) {
        STRONG_SELF
        [self yx_stopLoading];
        if (error) {
            [self yx_showToast:error.localizedDescription];
            return;
        }
    }];
}

// 第三方登录注册
- (void)startThirdLogin {
    ThirdRegisterByJoinClassModel *model = [[ThirdRegisterByJoinClassModel alloc]init];
    model.openid = [self.thirdLoginParams objectForKey:YXSSOAuthOpenidKey];
    model.pltform = [self.thirdLoginParams objectForKey:YXSSOAuthPltformKey];
    model.sex = [self.thirdLoginParams objectForKey:YXSSOAuthSexKey];
    model.headimg = [self.thirdLoginParams objectForKey:YXSSOAuthHeadimgKey];
    model.realname = self.promptView.inputView.text;
    model.provinceid = self.rawData.provinceid;
    model.cityid = self.rawData.cityid;
    model.areaid = self.rawData.areaid;
    model.stageid = self.rawData.stageid;
    model.schoolname = self.rawData.schoolname;
    model.schoolid = self.rawData.schoolid;
    model.classId = self.rawData.gid;

    WEAK_SELF
    [self yx_startLoading];
    [LoginDataManager thirdRegisterByJoinClassWithModel:model completeBlock:^(ThirdRegisterRequestItem *item, NSError *error) {
        STRONG_SELF
        [self yx_stopLoading];
        if (error) {
            [self yx_showToast:error.localizedDescription];
            return;
        }
    }];
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
    
    self.promptView = [[JoinClassPromptView alloc] init];
    self.promptView.rawData = self.rawData;
    WEAK_SELF
    [self.promptView setJoinAction:^{
        STRONG_SELF
        [self.promptView.inputView resignFirstResponder];
        [self askToJoinAction];
    }];
    
    self.alertView.contentView = self.promptView;
    
    [self.alertView showInView:self.view withLayout:^(AlertView *view) {
        [self.alertView.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(306 * [UIView scale]);
            make.center.mas_equalTo(0);
        }];
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
        [self resetViewWithKeyboardHeight:CGRectGetHeight(keyboardFrame)/2.f - 230]; //230
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
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
        make.centerY.equalTo(self.view.mas_centerY).offset(keyboardHeight);
    }];
}

@end
