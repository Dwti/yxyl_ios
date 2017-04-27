//
//  YXMineBaseViewController.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/9.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXMineBaseViewController.h"
#import "UIView+YXScale.h"

@interface YXMineBaseViewController ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation YXMineBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loadView
{
    [super loadView];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"我的背景"]];
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:backgroundImageView];
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[YXMineTableViewCell class] forCellReuseIdentifier:kYXMineCellIdentifier];
    [_tableView registerClass:[YXMineSelectCell class] forCellReuseIdentifier:kYXMineSelectCellIdentifier];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(34.f * [UIView scale]);
        make.right.mas_equalTo(-34.f * [UIView scale]);
    }];
}

- (BOOL)showLineAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = [self tableView:self.tableView numberOfRowsInSection:indexPath.section];
    return (indexPath.row < count - 1) && (count > 1);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 25.f;
    }
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat defaultHeight = 62.f;
    if ([self showLineAtIndexPath:indexPath]) {
        defaultHeight += 2.f;
    }
    return defaultHeight;
}

@end
