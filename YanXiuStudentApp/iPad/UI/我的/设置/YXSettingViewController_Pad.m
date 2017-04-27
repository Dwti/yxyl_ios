//
//  YXSettingViewController_Pad.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/1/27.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXSettingViewController_Pad.h"
#import "YXModifyPasswordViewController_Pad.h"
#import "YXStageChooseViewController_Pad.h"
#import "YXSubjectEditionChooseViewController_Pad.h"
#import "YXFeedbackViewController_Pad.h"
#import "YXAboutViewController_Pad.h"
#import "YXWebViewController_Pad.h"
#import "YXUpdateUserInfoRequest.h"
#import "YXGetEditionsRequest.h"
#import "YXCommonButtonCell.h"

@interface YXSettingViewController_Pad ()

@property (nonatomic, strong) NSArray *nameForClassList;
@property (nonatomic, strong) YXUserModel *userModel;
@property (nonatomic, strong) NSString *stageName;

@end

@implementation YXSettingViewController_Pad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    
    if ([YXUserManager sharedManager].isThirdLogin) {
        self.nameForClassList = @[
  @[@{@"学段":@"YXStageChooseViewController_Pad"}, @{@"教材版本":@"YXSubjectEditionChooseViewController_Pad"}],
  @[@{@"意见反馈":@"YXFeedbackViewController_Pad"}, @{@"关于":@"YXAboutViewController_Pad"}, @{@"隐私政策":@"YXWebViewController_Pad"}]];
    } else {
        self.nameForClassList = @[
  @[@{@"修改密码":@"YXModifyPasswordViewController_Pad"}, @{@"学段":@"YXStageChooseViewController_Pad"}, @{@"教材版本":@"YXSubjectEditionChooseViewController_Pad"}],
  @[@{@"意见反馈":@"YXFeedbackViewController_Pad"}, @{@"关于":@"YXAboutViewController_Pad"}, @{@"隐私政策":@"YXWebViewController_Pad"}]];
    }
    
    [self.tableView registerClass:[YXCommonButtonCell class] forCellReuseIdentifier:kCommonButtonCellIdentifier];
    [self reloadTableViewData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadTableViewData
{
    self.userModel = [YXUserManager sharedManager].userModel;
    self.stageName = self.userModel.stageName;
    [self.tableView reloadData];
}

- (void)updateStageWithName:(NSString *)stageName stageId:(NSString *)stageId
{
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
            [[YXGetEditionsManager sharedManager] clearVolumesCache];
        }
    }];
}

- (UIViewController *)viewControllerAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *nameForClass = self.nameForClassList[indexPath.section][indexPath.row];
    Class class = NSClassFromString(nameForClass.allValues[0]);
    UIViewController *vc = nil;
    if ([class isSubclassOfClass:[YXWebViewController_Pad class]]) {
        vc = [(YXWebViewController_Pad *)[class alloc] initWithUrl:@"http://mobile.hwk.yanxiu.com/privacy_policy.html"];
    } else {
        vc = [[class alloc] init];
        if ([class isSubclassOfClass:[YXStageChooseViewController_Pad class]]) {
            ((YXStageChooseViewController_Pad *)vc).stageid = [YXUserManager sharedManager].userModel.stageid;
            @weakify(self);
            ((YXStageChooseViewController_Pad *)vc).selectBlock = ^(NSString *stageId, NSString *stageName) {
                @strongify(self);
                [self updateStageWithName:stageName stageId:stageId];
            };
        }
    }
    vc.title = nameForClass.allKeys[0];
    return vc;
}

- (void)logout
{
    [[YXUserManager sharedManager] logout];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.nameForClassList.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section < self.nameForClassList.count) {
        NSArray *namesForClasses = self.nameForClassList[section];
        return namesForClasses.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < self.nameForClassList.count) {
        YXMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kYXMineCellIdentifier];
        NSDictionary *nameForClass = self.nameForClassList[indexPath.section][indexPath.row];
        [cell setTitle:nameForClass.allKeys[0] image:nil];
        cell.showLine = [self showLineAtIndexPath:indexPath];
        if ([NSClassFromString(nameForClass.allValues[0]) isSubclassOfClass:[YXStageChooseViewController_Pad class]]) {
            [cell updateWithAccessoryText:self.stageName isBoldFont:YES];
        }
        return cell;
    } else if (indexPath.section == self.nameForClassList.count) {
        YXCommonButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommonButtonCellIdentifier];
        [cell setButtonText:@"退出"];
        return cell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section < self.nameForClassList.count) {
        [self.navigationController pushViewController:[self viewControllerAtIndexPath:indexPath]
                                             animated:YES];
    } else if (indexPath.section == self.nameForClassList.count) {
        [self logout];
    }
}

@end
