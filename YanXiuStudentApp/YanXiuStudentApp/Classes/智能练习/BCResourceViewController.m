//
//  BCResourceViewController.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/10/18.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "BCResourceViewController.h"
#import "EmptyView.h"
#import "YXCommonErrorView.h"
#import "BCResourceListCell.h"
#import "BCResourceListHeaderView.h"
#import "BCTopicListViewController.h"
#import "GetSubjectRequest.h"
#import "BCResourceDataManager.h"

@interface BCResourceViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong) EmptyView *emptyView;
@property(nonatomic, strong) YXCommonErrorView *errorView;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) GetTopicTreeRequestItem *item;
@end

@implementation BCResourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    self.navigationItem.title = self.subject.name;
    self.naviTheme = NavigationBarTheme_White;
    [self setupUI];
    [self getTopicTree];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.estimatedSectionFooterHeight = 10.f;
    self.tableView.estimatedSectionHeaderHeight = 55.f;
    [self.tableView registerClass:[BCResourceListHeaderView class] forHeaderFooterViewReuseIdentifier:@"BCResourceListHeaderView"];
    [self.tableView registerClass:[BCResourceListCell class] forCellReuseIdentifier:@"BCResourceListCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    if (!self.emptyView) {
        self.emptyView = [[EmptyView alloc]init];
        self.emptyView.title = @"内容为空";
        self.emptyView.image = [UIImage imageNamed:@"没有练习历史插图"];
    }
    
    if (!self.errorView) {
        self.errorView = [[YXCommonErrorView alloc]init];
    }
    WEAK_SELF
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self getTopicTree];
    }];
}

- (void)getTopicTree {
    WEAK_SELF
     [self.view nyx_startLoading];
    [BCResourceDataManager requestTopicTreeWithSubjectId:self.subject.subjectID type:self.subject.type completeBlock:^(GetTopicTreeRequestItem *retItem, NSError *error) {
        STRONG_SELF
         [self.view nyx_stopLoading];
        if (error) {
            if (self.item.themes.count > 0) {
                [self.view nyx_showToast:error.localizedDescription];
                return;
            }
            [self.view addSubview:self.errorView];
            [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(0);
            }];
            return;
        }
        if (retItem.themes.count <= 0) {
            [self.view addSubview:self.emptyView];
            [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(0);
            }];
            return;
        }
        [self.errorView removeFromSuperview];
        [self.emptyView removeFromSuperview];
        NSMutableArray *array = [NSMutableArray arrayWithArray:retItem.themes];
        for (GetTopicTreeRequestItem_theme *theme in retItem.themes) {
            if (theme.children.count <= 0) {
                [array removeObject:theme];
            }
        }
        GetTopicTreeRequestItem *newItem = [[GetTopicTreeRequestItem alloc]init];
        newItem.themes = array.copy;
        self.item = newItem;
        [self.tableView reloadData];
    }];
}

#pragma mark - tableview datasource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.item.themes.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    GetTopicTreeRequestItem_theme *theme = self.item.themes[section];
    return theme.children.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BCResourceListCell *cell = [[BCResourceListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    GetTopicTreeRequestItem_theme *theme = self.item.themes[indexPath.section];
    cell.resourceTitle = [theme.children[indexPath.row] name];
    if (indexPath.row == theme.children.count - 1) {
        cell.shouldShowLine = NO;
    }else {
        cell.shouldShowLine = YES;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    BCResourceListHeaderView *headerView = [[BCResourceListHeaderView alloc]initWithReuseIdentifier:nil];
    GetTopicTreeRequestItem_theme *theme = self.item.themes[section];
    headerView.title = theme.name;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 55.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GetTopicTreeRequestItem_theme *theme = self.item.themes[indexPath.section];
    BCTopicListViewController *vc = [[BCTopicListViewController alloc]initWithTopicTheme:theme.children[indexPath.row] type:self.subject.type];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
