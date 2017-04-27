//
//  YXAreaViewController.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/9.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXAreaViewController.h"
#import "YXProvinceList.h"
#import "YXMineTableViewCell.h"
#import "YXCitySelectViewController.h"
#import "YXProvinceCitySelectionCell.h"
#import "YXAreaSelectionHeaderView.h"

@interface YXAreaViewController ()

@property (nonatomic, strong) YXProvinceList *provinceList;

@end

@implementation YXAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择地区";
    [self parseProvinceList];
    [self relayoutWithItemCount:self.provinceList.provinces.count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)parseProvinceList
{
    if (!self.provinceList || !self.provinceList.provinces) {
        self.provinceList = [[YXProvinceList alloc] init];
        [self.provinceList startParse];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.provinceList.provinces.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"YXProvinceCitySelectionCell";
    YXProvinceCitySelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[YXProvinceCitySelectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.title = ((YXProvince *)self.provinceList.provinces[indexPath.row]).name;
    return cell;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *identifier = @"YXAreaSelectionHeaderView";
    YXAreaSelectionHeaderView *v = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!v) {
        v = [[YXAreaSelectionHeaderView alloc] initWithReuseIdentifier:identifier];
    }
    v.title = @"请选择你所在的省/直辖市";
    return v;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YXCitySelectViewController *vc = [[YXCitySelectViewController alloc] initWithProvince:self.provinceList.provinces[indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
