//
//  HomeworkListViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/16.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "HomeworkListViewController.h"
#import "YXHomeworkListFetcher.h"
#import "HomeworkListCell.h"

@interface HomeworkListViewController ()
@property (nonatomic, strong) YXHomeworkListGroupsItem_Data *data;

@end

@implementation HomeworkListViewController

- (instancetype)initWithData:(YXHomeworkListGroupsItem_Data *)data {
    if (self = [super init]) {
        self.data = data;
        YXHomeworkListFetcher *fetcher = [[YXHomeworkListFetcher alloc] init];
        fetcher.gid = data.groupId;
        self.dataFetcher = fetcher;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.data.name;
    self.view.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    self.naviTheme = NavigationBarTheme_White;
    [self setupUI];
    [self setupObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 10)];
    self.tableView.tableHeaderView = headerView;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    [self.tableView registerClass:[HomeworkListCell class] forCellReuseIdentifier:@"HomeworkListCell"];
}

- (void)setupObserver {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:YXSavePaperSuccessNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        [self.view nyx_startLoading];
        [self firstPageFetch];
    }];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:YXSubmitQuestionSuccessNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        [self.view nyx_startLoading];
        [self firstPageFetch];
    }];
}

#pragma mark - tableview datasource & delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeworkListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeworkListCell"];
    cell.data = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
