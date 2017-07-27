//
//  YXRankViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/9/22.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXRankViewController.h"
#import "YXRankCell.h"
#import "YXRankHeaderView.h"
#import "UIImage+YXImage.h"
#import "YXBottomGradientView.h"

@interface YXRankViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation YXRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"桌面"]];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    UIImage *rankImage = [UIImage imageNamed:@"大背景"];
    UIImageView *rankBGView = [[UIImageView alloc] initWithImage:rankImage];
    [self.view addSubview:rankBGView];
    [rankBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(rankImage.size.height * CGRectGetWidth([UIScreen mainScreen].bounds) / rankImage.size.width);
    }];
    
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:@"返回icon"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"返回icon-按下"] forState:UIControlStateHighlighted];
//    [button addTarget:self action:@selector(yx_leftBackButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(20);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(48);
    }];
    
    UIImageView *tableViewBGView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"容器背景"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)]];
    tableViewBGView.userInteractionEnabled = YES;
    tableViewBGView.clipsToBounds = YES;
    [self.view addSubview:tableViewBGView];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 90;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [tableViewBGView addSubview:self.tableView];
    
    UILabel *footView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds) - 46, 60)];
    footView.textAlignment = NSTextAlignmentCenter;
    footView.textColor = [UIColor colorWithHexString:@"c6ab7d"];
    footView.text = @"每周一重置，勤奋的同学都有机会登上榜首：）";
    footView.font = [UIFont systemFontOfSize:12];
    self.tableView.tableFooterView = footView;
    
    YXBottomGradientView *gradientView = [[YXBottomGradientView alloc] initWithFrame:CGRectZero color:[UIColor colorWithHexString:@"543b18"]];
    [tableViewBGView addSubview:gradientView];
    
    UIImageView *rankIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"排行榜icon"]];
    [self.view addSubview:rankIconView];
    [rankIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo((CGRectGetHeight([UIScreen mainScreen].bounds) <= 480) ? 20:80);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(102);
        make.width.mas_equalTo(235);
    }];
//    [tableViewBGView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(rankIconView.mas_top).offset(78);
//        make.left.mas_equalTo(23 * [UIView scale]);
//        make.right.mas_equalTo(-23 * [UIView scale]);
//        make.bottom.mas_equalTo(-25);
//    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(7);
        make.right.mas_equalTo(-7);
        make.bottom.mas_equalTo(-3);
    }];
    [gradientView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-2);
        make.height.mas_equalTo(30);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.rankModel.rankItemArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseID = @"rank_cell";
    YXRankCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[YXRankCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    cell.rankItem = self.rankModel.rankItemArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 104.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *header = @"header";
    YXRankHeaderView *hv = [tableView dequeueReusableHeaderFooterViewWithIdentifier:header];
    if (!hv) {
        hv = [[YXRankHeaderView alloc]initWithReuseIdentifier:header];
    }
    hv.rank = self.rankModel.myRank;
    return hv;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45.f;
}

@end
