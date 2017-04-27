//
//  YXLoginBaseViewController_Pad.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/1/26.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXLoginBaseViewController_Pad.h"

CGFloat const kYXLoginCellWidth = 300.f;

@interface YXLoginBaseViewController_Pad ()

@end

@implementation YXLoginBaseViewController_Pad

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
    
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"登录背景"]];
    bgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView registerClass:[YXLoginCell class] forCellReuseIdentifier:kYXLoginCellIdentifier];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.centerX.mas_equalTo(0);
        make.width.mas_equalTo(kYXLoginCellWidth);
    }];
}

#pragma mark -

- (BOOL)showLineAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = [self tableView:self.tableView numberOfRowsInSection:indexPath.section];
    return (indexPath.row < count - 1) && (count > 1);
}

- (UIView *)viewForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YXLoginCell *cell = [tableView dequeueReusableCellWithIdentifier:kYXLoginCellIdentifier];
    cell.containerView = [self viewForRowAtIndexPath:indexPath];
    cell.showLine = [self showLineAtIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 40.f;
    }
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat defaultHeight = 60.f;
    if ([self showLineAtIndexPath:indexPath]) {
        defaultHeight += 2.f;
    }
    return defaultHeight;
}

@end
