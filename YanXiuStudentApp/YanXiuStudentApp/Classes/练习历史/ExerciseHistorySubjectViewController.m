//
//  ExerciseHistorySubjectViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/11/3.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "ExerciseHistorySubjectViewController.h"
#import "ExerciseHistorySubjectCell.h"
#import "YXGetPracticeEditionRequest.h"
#import "YXCommonErrorView.h"
#import "EmptyView.h"
#import "ExerciseHistoryContentViewController.h"

@interface ExerciseHistorySubjectViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YXGetPracticeEditionRequest *request;
@property (nonatomic, strong) GetPracticeEditionRequestItem *item;
@property (nonatomic, strong) YXCommonErrorView *errorView;
@property (nonatomic, strong) EmptyView *emptyView;
@end

@implementation ExerciseHistorySubjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"练习历史";
    self.naviTheme = NavigationBarTheme_White;
    self.emptyView.title = @"还没有练习历史哦";
    self.emptyView.image = [UIImage imageNamed:@"没有练习历史插图"];
    [self setupUI];
    [self requestHistorySubjects];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ExerciseHistorySubjectCell class] forCellReuseIdentifier:@"kExerciseHistorySubjectCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.errorView = [[YXCommonErrorView alloc] init];
    WEAK_SELF
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self requestHistorySubjects];
    }];
    
    self.emptyView = [[EmptyView alloc] init];
}

- (void)requestHistorySubjects {
    if (self.request) {
        [self.request stopRequest];
    }
    self.request = [[YXGetPracticeEditionRequest alloc] init];
    self.request.stageId = [YXUserManager sharedManager].userModel.stageid;
    @weakify(self);
    [self.view nyx_startLoading];
    [self.request startRequestWithRetClass:[GetPracticeEditionRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        @strongify(self);
        [self.view nyx_stopLoading];
        GetPracticeEditionRequestItem *item = retItem;
        if (item && item.subjects.count == 0) {
            [self.view addSubview:self.emptyView];
            [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(0);
            }];
            if (item.status.desc) {
                self.emptyView.title = item.status.desc;
            }
            return;
        }
        if (error) {
            [self.view addSubview:self.errorView];
            [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(0);
            }];
            return;
        }
        
        [self.emptyView removeFromSuperview];
        [self.errorView removeFromSuperview];
        self.item = item;
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.item.subjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExerciseHistorySubjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kExerciseHistorySubjectCell"];
    GetPracticeEditionRequestItem_subject *subject = self.item.subjects[indexPath.row];
    cell.subject = subject;
    cell.isLast = indexPath.row == self.item.subjects.count - 1;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10.f;
    }
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 51.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ExerciseHistoryContentViewController *vc = [[ExerciseHistoryContentViewController alloc] init];
    vc.subject = self.item.subjects[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
