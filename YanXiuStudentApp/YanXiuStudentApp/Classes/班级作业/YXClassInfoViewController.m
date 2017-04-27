//
//  YXClassInfoViewController.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/9/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "YXClassInfoViewController.h"
#import "YXAddToClassViewController.h"
#import "UIColor+YXColor.h"

#import "YXExitClassRequest.h"
#import "YXCancelReplyClassRequest.h"
#import "EEAlertView.h"
#import "ClassInfoView.h"
#import "UIView+YXScale.h"


@interface YXClassInfoViewController ()

@property (nonatomic, strong) ClassInfoView *classInfoView;
@property (nonatomic, strong) EEAlertView *infoView;
@property (nonatomic, strong) EEAlertView *alertView;
@property (nonatomic, strong) YXClassInfoMock *data;

@end

@implementation YXClassInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self yx_setupLeftCancelBarButtonItem];
    self.title = @"班级信息";
    self.data = [YXClassInfoMock mockItemFromRealData:self.rawData];
    
    [self setupSubviews];
}

- (void)setupSubviews
{
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"背景01"]];
    bgImageView.frame = self.view.bounds;
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bgImageView];
    
    self.infoView = [EEAlertView new];
    self.classInfoView = [ClassInfoView new];
    self.classInfoView.actionType = self.actionType;
    self.classInfoView.data = self.data;
    WEAK_SELF
    [[self.classInfoView.button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        switch (self.actionType) {
                case YXClassActionTypeJoin:
                [self askToJoinAction];
                break;
                case YXClassActionTypeCancelJoining:
                [self askToCancelJoiningAction];
                break;
                case YXClassActionTypeExit:
                [self askToExitAction];
                break;
        }
    }];

    self.infoView.contentView = self.classInfoView;
    [self.infoView showInView:self.view withLayout:^(AlertView *view) {
        [view.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset = 306 * [UIView scale];
            make.height.offset = 198;
            make.centerX.offset = 0;
            make.centerY.offset = 0;
        }];
    }];
}

- (void)askToJoinAction
{
    if ([self.rawData memberIsFull]) {
        [self yx_showToast:@"班级已满，不能申请"];
        return;
    }
    YXAddToClassViewController *vc = [[YXAddToClassViewController alloc] init];
    vc.data = self.rawData;
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)askToCancelJoiningAction
{
    self.alertView = [EEAlertView new];
    self.alertView.title = @"确定取消申请吗？";
    [self.alertView addButtonWithTitle:@"取消" action:nil];
    WEAK_SELF
    [self.alertView addButtonWithTitle:@"确定" action:^{
        STRONG_SELF
        [self cancelJoiningClass];
    }];
    [self.alertView showInView:self.view];
}

- (void)cancelJoiningClass
{
    [self yx_startLoading];
    WEAK_SELF
    [ClassHomeworkDataManager cancelJoiningClassWithClassID:self.rawData.gid completeBlock:^(HttpBaseRequestItem *item, NSError *error) {
        STRONG_SELF
        [self yx_stopLoading];
        if (error) {
            [self yx_showToast:error.localizedDescription];
            return;
        }
        [self yx_leftCancelButtonPressed:nil];
    }];
}

- (void)askToExitAction
{
    self.alertView = [EEAlertView new];
    self.alertView.title = @"确定退出班级吗？";
    [self.alertView addButtonWithTitle:@"取消" action:nil];
    WEAK_SELF
    [self.alertView addButtonWithTitle:@"确定" action:^{
        STRONG_SELF
        [self doExitClass];
    }];
    [self.alertView showInView:self.view];
}

- (void)doExitClass
{
    [self yx_startLoading];
    WEAK_SELF
    [ClassHomeworkDataManager exitClassWithClassID:self.rawData.gid completeBlock:^(HttpBaseRequestItem *item, NSError *error) {
        STRONG_SELF
        [self yx_stopLoading];
        if (error) {
            [self yx_showToast:error.localizedDescription];
            return;
        }
        [self yx_leftCancelButtonPressed:nil];
    }];
}

@end
