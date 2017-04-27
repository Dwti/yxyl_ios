//
//  YXCitySelectViewController_Pad.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/1/29.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXCitySelectViewController_Pad.h"
#import "YXProvinceList.h"
#import "YXProvinceCitySelectionCell.h"
#import "YXAreaSelectionHeaderView.h"
#import "YXDistrictSelectViewController_Pad.h"

@interface YXCitySelectViewController_Pad ()

@property (nonatomic, strong) YXProvince *province;

@end

@implementation YXCitySelectViewController_Pad

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
    self.title = @"选择城市";
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
    YXDistrictSelectViewController_Pad *vc = [[YXDistrictSelectViewController_Pad alloc] initWithProvince:self.province city:self.province.citys[indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
