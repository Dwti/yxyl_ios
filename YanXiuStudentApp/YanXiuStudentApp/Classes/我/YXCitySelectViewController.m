//
//  YXCitySelectViewController.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/9.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXCitySelectViewController.h"
#import "YXProvinceList.h"
#import "YXMineTableViewCell.h"
#import "YXDistrictSelectViewController.h"
#import "YXProvinceCitySelectionCell.h"
#import "YXAreaSelectionHeaderView.h"

@interface YXCitySelectViewController ()

@property (nonatomic, strong) YXProvince *province;

@end

@implementation YXCitySelectViewController

- (instancetype)initWithProvince:(YXProvince *)province
{
    if (self = [super init]) {
        self.province = province;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.province.name;
    [self relayoutWithItemCount:self.province.citys.count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.province.citys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"YXProvinceCitySelectionCell";
    YXProvinceCitySelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[YXProvinceCitySelectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.title = ((YXCity *)self.province.citys[indexPath.row]).name;
    return cell;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *identifier = @"YXAreaSelectionHeaderView";
    YXAreaSelectionHeaderView *v = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!v) {
        v = [[YXAreaSelectionHeaderView alloc] initWithReuseIdentifier:identifier];
    }
    v.title = @"请选择你所在的城市";
    return v;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YXDistrictSelectViewController *vc = [[YXDistrictSelectViewController alloc] initWithProvince:self.province city:self.province.citys[indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
