//
//  YXClassInfoViewController_Pad.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/2/1.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXClassInfoViewController_Pad.h"
#import "YXAlertView.h"
#import "UIView+YXScale.h"
#import "YXCommonLabel.h"
#import "UIColor+YXColor.h"

#import "YXExitClassRequest.h"
#import "YXCancelReplyClassRequest.h"

#import "YXClassAddViewController_Pad.h"
#import "UIViewController+YXPresent.h"
#import "YXNavigationController_Pad.h"

@interface YXClassInfoViewController_Pad ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) YXAlertView *infoView;
@property (nonatomic, strong) YXAlertView *alertView;
@property (nonatomic, strong) YXExitClassRequest *exitRequest;
@property (nonatomic, strong) YXCancelReplyClassRequest *cancelRequest;
@property (nonatomic, strong) YXClassInfoMock *data;

@end

@implementation YXClassInfoViewController_Pad

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self yx_setupLeftCancelBarButtonItem];
    self.title = @"班级信息";
    self.data = [YXClassInfoMock mockItemFromRealData:self.rawData];
    
    [self setupSubviews];
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

- (void)setupSubviews
{
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"作业背景"]];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 266 * [UIView scale], 82 * [UIView scale])];
    
    UIImageView *headerBGView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80 * [UIView scale], 80 * [UIView scale])];
    headerBGView.image = [[UIImage imageNamed:@"班级缩略图默认边框"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectInset(headerBGView.frame, 4.f, 4.f)];
    [headerView sd_setImageWithURL:self.data.iconUrl placeholderImage:[UIImage imageNamed:@"班级默认头像"]];
    [self.containerView addSubview:headerView];
    [self.containerView addSubview:headerBGView];
    
    CGFloat originX = CGRectGetMaxX(headerBGView.frame) + 15 * [UIView scale];
    YXCommonLabel *classNameLabel = [[YXCommonLabel alloc] initWithFrame:CGRectMake(originX, 0, CGRectGetWidth(self.containerView.bounds) - originX, 32 * [UIView scale])];
    classNameLabel.font = [UIFont boldSystemFontOfSize:17.f];
    classNameLabel.text = self.data.name;
    [self.containerView addSubview:classNameLabel];
    
    YXCommonLabel *classIdLabel = [[YXCommonLabel alloc] initWithFrame:CGRectMake(originX, CGRectGetMaxY(classNameLabel.frame), CGRectGetWidth(classNameLabel.frame), 20 * [UIView scale])];
    classIdLabel.font = [UIFont systemFontOfSize:12.f];
    classIdLabel.text = [NSString stringWithFormat:@"班级号码：%@", self.data.gid];
    [self.containerView addSubview:classIdLabel];
    
    UIImage *textBGImage = [[UIImage imageNamed:@"标签背景"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 6, 10, 6)];
    UIImageView *teacherView = [[UIImageView alloc] initWithFrame:CGRectMake(originX, CGRectGetMaxY(classIdLabel.frame) + 8 * [UIView scale], 32 * [UIView scale], 18 * [UIView scale])];
    teacherView.image = textBGImage;
    [self.containerView addSubview:teacherView];
    
    UILabel *teacherLabel = [[UILabel alloc] initWithFrame:teacherView.bounds];
    teacherLabel.textAlignment = NSTextAlignmentCenter;
    teacherLabel.text = @"老师";
    teacherLabel.textColor = [UIColor yx_colorWithHexString:@"ffdb4d"];
    teacherLabel.font = [UIFont systemFontOfSize:11.f];
    [teacherView addSubview:teacherLabel];
    
    YXCommonLabel *teacherNameLabel = [[YXCommonLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(teacherView.frame) + 10 * [UIView scale], CGRectGetMinY(teacherView.frame), 50 * [UIView scale], CGRectGetHeight(teacherView.frame))];
    teacherNameLabel.font = [UIFont boldSystemFontOfSize:13.f];
    teacherNameLabel.text = self.data.teacher;
    [self.containerView addSubview:teacherNameLabel];
    
    UIImageView *numberView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(teacherNameLabel.frame) + 10 * [UIView scale], CGRectGetMinY(teacherView.frame), 32 * [UIView scale], CGRectGetHeight(teacherView.frame))];
    numberView.image = textBGImage;
    [self.containerView addSubview:numberView];
    
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:numberView.bounds];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.text = @"人数";
    numberLabel.textColor = teacherLabel.textColor;
    numberLabel.font = teacherLabel.font;
    [numberView addSubview:numberLabel];
    
    YXCommonLabel *studentNumberLabel = [[YXCommonLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(numberView.frame) + 10 * [UIView scale], CGRectGetMinY(teacherView.frame), CGRectGetWidth(self.containerView.frame) - CGRectGetMaxX(numberView.frame) - 10 * [UIView scale], CGRectGetHeight(teacherView.frame))];
    studentNumberLabel.font = [UIFont boldSystemFontOfSize:13.f];
    studentNumberLabel.text = self.data.headcount;
    [self.containerView addSubview:studentNumberLabel];
    
    NSString *actionText = nil;
    switch (self.actionType) {
        case YXClassActionTypeJoin:
            actionText = @"申请加入";
            break;
        case YXClassActionTypeCancelJoining:
            actionText = @"取消申请";
            break;
        case YXClassActionTypeExit:
            actionText = @"退出班级";
            break;
    }
    self.infoView = [YXAlertView alertWithMessage:nil style:YXAlertStyleAlert contentSize:CGSizeMake(306, 198)];
    self.infoView.keepInSuperview = YES;
    @weakify(self);
    [self.infoView addButtonWithTitle:actionText action:^{
        @strongify(self);
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
    [self.infoView addContainerView:self.containerView];
    [self.infoView showInView:self.view];
}

- (void)askToJoinAction
{
    if ([self.rawData.isMemeberFull integerValue] == 1) {
        [self yx_showToast:@"班级已满，不能申请"];
        return;
    }
    YXClassAddViewController_Pad *vc = [[YXClassAddViewController_Pad alloc] init];
    vc.data = self.rawData;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)askToCancelJoiningAction
{
    self.alertView = [YXAlertView alertWithMessage:@"确定取消申请吗？"];
    [self.alertView addCancelButton];
    @weakify(self);
    [self.alertView addButtonWithTitle:@"确定" action:^{
        @strongify(self);
        [self cancelJoiningClass];
    }];
    [self.alertView showInView:self.view];
}

- (void)cancelJoiningClass
{
    [self.cancelRequest stopRequest];
    self.cancelRequest = [[YXCancelReplyClassRequest alloc] init];
    self.cancelRequest.classId = self.rawData.gid;
    @weakify(self);
    [self yx_startLoading];
    [self.cancelRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        @strongify(self);
        [self yx_stopLoading];
        if (!retItem || error) {
            if (error.code == 75) { // 你的申请已通过审核，无法取消。请返回并刷新作业首页
                [self yx_showToast:error.localizedDescription];
            } else {
                [self yx_showToast:error.localizedDescription];
            }
            return;
        }
        
        [self yx_leftCancelButtonPressed:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:YXCancelReplyClassSuccessNotification object:nil];
    }];
}

- (void)askToExitAction
{
    self.alertView = [YXAlertView alertWithMessage:@"确定退出班级吗？"];
    [self.alertView addCancelButton];
    @weakify(self);
    [self.alertView addButtonWithTitle:@"确定" action:^{
        @strongify(self);
        [self doExitClass];
    }];
    [self.alertView showInView:self.view];
}

- (void)doExitClass
{
    [self.exitRequest stopRequest];
    self.exitRequest = [[YXExitClassRequest alloc] init];
    self.exitRequest.classId = self.rawData.gid;
    
    @weakify(self);
    [self yx_startLoading];
    [self.exitRequest startRequestWithRetClass:[HttpBaseRequestItem class]
                              andCompleteBlock:^(id retItem, NSError *error) {
                                  @strongify(self);
                                  [self yx_stopLoading];
                                  if (error) {
                                      [self yx_showToast:error.localizedDescription];
                                      return;
                                  }
                                  
                                  [self yx_leftCancelButtonPressed:nil];
                                  [[NSNotificationCenter defaultCenter] postNotificationName:YXExitClassSuccessNotification object:nil];
                              }];
}

@end
