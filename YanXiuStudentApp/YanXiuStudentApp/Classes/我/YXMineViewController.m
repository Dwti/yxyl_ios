//
//  YXMineViewController.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/7.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXMineViewController.h"
#import "YXMineTableViewCell.h"

#import "YXMyProfileViewController.h"
#import "YXMistakeSubjectViewController.h"
#import "YXStageViewController.h"
#import "YXTextbookVersionViewController.h"
#import "YXSettingViewController.h"

#import "YXMineManager.h"
#import "YXUserManager.h"
#import "YXUpdateUserInfoRequest.h"
#import "YXUploadHeadImgRequest.h"

#import "YXFeedbackViewModel.h"
#import "YXFeedbackViewController.h"

@interface YXMineViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) YXUserModel *userModel;
@property (nonatomic, strong) NSString *stageName;

@end

@implementation YXMineViewController

- (void)dealloc
{
    [self removeNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的";
    self.items = @[@[@{@"":@"默认头像"}],
                   @[
//                       @{@"我的收藏":@"我的收藏"},
                     @{@"我的错题":@"我的错题"}],
                   @[@{@"学段":@"学段"},
                     @{@"教材版本":@"教材版本"}],
                   @[@{@"意见反馈":@"意见反馈"},
                     @{@"设置":@"设置"}]];
    
    [self registerNotifications];
    [self reloadTableViewData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (void)registerNotifications
{
    [self removeNotifications];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];

    [center addObserver:self
               selector:@selector(updateUserInfoSuccess:)
                   name:YXUpdateUserInfoSuccessNotification
                 object:nil];
    [center addObserver:self
               selector:@selector(updateHeadImgSuccess:)
                   name:YXUpdateHeadImgSuccessNotification
                 object:nil];
}

- (void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateUserInfoSuccess:(NSNotification *)notification
{
    [self reloadTableViewData];
}

- (void)updateHeadImgSuccess:(NSNotification *)notification
{
    [self reloadTableViewData];
}

- (void)loginSuccess:(NSNotification *)notification
{
    [self reloadTableViewData];
}

- (void)logoutSuccess:(NSNotification *)notification
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self reloadTableViewData];
}

#pragma mark -

- (void)reloadTableViewData {
    self.userModel = [YXUserManager sharedManager].userModel;
    if (self.userModel.stageName) {
        self.stageName = self.userModel.stageName;
    } else {
        switch (self.userModel.stageid.integerValue) {
            case 1202:
                self.stageName = @"小学";
                break;
                
            case 1203:
                self.stageName = @"初中";
                break;
            
            case 1204:
                self.stageName = @"高中";
                break;
                
            default:
                break;
        }
    }
    [self.tableView reloadData];
}

- (void)updateStageWithName:(NSString *)stageName stageId:(NSString *)stageId {
    if ([stageId isEqualToString:self.userModel.stageid]
        || [stageName isEqualToString:self.userModel.stageName]) {
        return;
    }
    
    self.stageName = stageName;
    [self.tableView reloadData];
    NSDictionary *param = @{@"stageid": stageId,
                            @"stageName": stageName};
    @weakify(self);
    [self yx_startLoading];
    [[YXUpdateUserInfoHelper instance] requestWithType:YXUpdateUserInfoTypeStage param:param completion:^(NSError *error) {
        @strongify(self);
        [self yx_stopLoading];
        if (error) {
            [self yx_showToast:error.localizedDescription];
            self.stageName = self.userModel.stageName;
            [self.tableView reloadData];
        } else {
            //[[YXGetEditionsManager sharedManager] clearVolumesCache];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *itemsInSection = self.items[section];
    return itemsInSection.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YXMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kYXMineCellIdentifier];
    cell.showLine = [self showLineAtIndexPath:indexPath];
    NSArray *itemsInSection = self.items[indexPath.section];
    NSDictionary *dict = itemsInSection[indexPath.row];
    if (indexPath.section == 0) {
        [cell setTitle:self.userModel.nickname account:self.userModel.mobile];
        [cell updateWithImageUrl:self.userModel.head defaultImage:[UIImage imageNamed:dict.allValues[0]]];
    } else {
        [cell setTitle:dict.allKeys[0] image:[UIImage imageNamed:dict.allValues[0]]];
        [cell updateWithImageUrl:nil defaultImage:nil];
    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        [cell updateWithAccessoryText:self.stageName];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 123.f;
    } else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *vc = nil;
    switch (indexPath.section) {
        case 0:
        {
            vc = [[YXMyProfileViewController alloc] init];
        }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    vc = [[YXMistakeSubjectViewController alloc] init];
                    break;
                case 1:
//                    vc = [[YXExerciseHistoryViewController alloc] init];
                    break;
                default:
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                {
                    vc = [[YXStageViewController alloc] init];
                    ((YXStageViewController *)vc).isRegisterAccount = NO;
                    ((YXStageViewController *)vc).stageid = [YXUserManager sharedManager].userModel.stageid;
                    @weakify(self);
                    ((YXStageViewController *)vc).selectBlock = ^(NSString *stageId, NSString *stageName) {
                        @strongify(self);
                        [self updateStageWithName:stageName stageId:stageId];
                    };
                }
                    break;
                case 1:
                    vc = [[YXTextbookVersionViewController alloc] init];
                    break;
                default:
                    break;
            }
            break;
        case 3:
            switch (indexPath.row) {
                case 0:
                {
                    YXFeedbackViewModel * viewModel = [[YXFeedbackViewModel alloc] init];
                    vc = [[YXFeedbackViewController alloc] initWithViewModel:viewModel];
                }
                    break;
                case 1:
                    vc = [[YXSettingViewController alloc] init];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
