//
//  YXAreaSelectViewController_Pad.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/1/29.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXAreaSelectViewController_Pad.h"
#import "YXProvinceList.h"
#import "YXProvinceCitySelectionCell.h"
#import "YXAreaSelectionHeaderView.h"
#import "YXCitySelectViewController_Pad.h"

@interface YXAreaSelectViewController_Pad ()

@property (nonatomic, strong) YXProvinceList *provinceList;

@end

@implementation YXAreaSelectViewController_Pad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"地区";
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
    YXCitySelectViewController_Pad *vc = [[YXCitySelectViewController_Pad alloc] initWithProvince:self.provinceList.provinces[indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
