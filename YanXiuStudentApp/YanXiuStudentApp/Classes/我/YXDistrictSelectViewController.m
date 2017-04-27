//
//  YXDistrictSelectViewController.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/9.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXDistrictSelectViewController.h"
#import "YXProvinceList.h"
#import "YXMineSelectCell.h"
#import "YXUpdateUserInfoRequest.h"
#import "YXDistrictSelectionCell.h"
#import "YXAreaSelectionHeaderView.h"
#import "YXSchoolSearchViewController.h"

@interface YXDistrictSelectViewController ()

@property (nonatomic, strong) YXProvince *province;
@property (nonatomic, strong) YXCity *city;
@property (nonatomic, strong) YXDistrict *district;
@property (nonatomic, strong) UIButton *saveButton;

@end

@implementation YXDistrictSelectViewController

- (instancetype)initWithProvince:(YXProvince *)province
                            city:(YXCity *)city
{
    if (self = [super init]) {
        self.province = province;
        self.city = city;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.city.name;
    self.saveButton = [self yx_setupRightButtonItemWithTitle:@"保存" image:nil highLightedImage:nil];
    self.saveButton.enabled = NO;
    self.saveButton.hidden = YES;
    [self relayoutWithItemCount:self.city.districts.count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)yx_rightButtonPressed:(id)sender {
    if ([[YXUserManager sharedManager] isLogin]) { //已登录，直接请求网络修改地区信息
        if ([self.district.did isEqualToString:[YXUserManager sharedManager].userModel.areaid]
            && [self.district.name isEqualToString:[YXUserManager sharedManager].userModel.areaName]) {
            [self backToViewController:@"YXMyProfileViewController"];
            return;
        }
        NSDictionary *param = @{@"provinceid":self.province.pid,
                                @"provinceName":self.province.name,
                                @"cityid":self.city.cid,
                                @"cityName":self.city.name,
                                @"areaid":self.district.did,
                                @"areaName":self.district.name};
        @weakify(self);
        [self yx_startLoading];
        self.saveButton.enabled = NO;
        [[YXUpdateUserInfoHelper instance] requestWithType:YXUpdateUserInfoTypeArea param:param completion:^(NSError *error) {
            @strongify(self);
            self.saveButton.enabled = YES;
            [self yx_stopLoading];
            if (!error) {
                [self backToViewController:@"YXMyProfileViewController"];
            } else {
                [self yx_showToast:error.localizedDescription];
            }
        }];
    } else {
        NSDictionary *userInfo = @{@"province": self.province,
                                   @"city": self.city,
                                   @"district": self.district};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"YXProvinceSelectedNotification"
                                                            object:nil
                                                          userInfo:userInfo];
        [self backToViewController:@"YXEditProfileViewController"];
    }
}

- (void)backToViewController:(NSString *)controllerName {
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:NSClassFromString(controllerName)]) {
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.city.districts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"YXDistrictSelectionCell";
    YXDistrictSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[YXDistrictSelectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.title = ((YXDistrict *)self.city.districts[indexPath.row]).name;
    return cell;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *identifier = @"YXAreaSelectionHeaderView";
    YXAreaSelectionHeaderView *v = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!v) {
        v = [[YXAreaSelectionHeaderView alloc] initWithReuseIdentifier:identifier];
    }
    v.title = @"请选择你所在的区县";
    return v;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.district = self.city.districts[indexPath.row];
    self.saveButton.enabled = YES;
    
    YXSchoolSearchViewController *vc = [[YXSchoolSearchViewController alloc] init];
    vc.province = self.province;
    vc.city = self.city;
    vc.district = self.district;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
