//
//  ExerciseHistorySubjectViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/11/3.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "ExerciseHistorySubjectViewController.h"
#import "YXMineTableViewCell.h"
#import "UIView+YXScale.h"
#import "YXGetPracticeEditionRequest.h"
#import "YXCommonErrorView.h"
#import "YXExerciseEmptyView.h"
#import "ExerciseHistoryContentViewController.h"

@interface ExerciseHistorySubjectViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YXGetPracticeEditionRequest *request;
@property (nonatomic, strong) GetPracticeEditionRequestItem *item;
@property (nonatomic, strong) YXCommonErrorView *errorView;
@property (nonatomic, strong) YXExerciseEmptyView *emptyView;
@end

@implementation ExerciseHistorySubjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"练习历史";
    [self yx_setupLeftBackBarButtonItem];
    [self setupUI];
    [self requestHistorySubjects];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"我的背景"]];
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:backgroundImageView];
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[YXMineTableViewCell class] forCellReuseIdentifier:kYXMineCellIdentifier];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(34.f * [UIView scale]);
        make.right.mas_equalTo(-34.f * [UIView scale]);
    }];
    
    self.errorView = [[YXCommonErrorView alloc] init];
    [self.view addSubview:self.errorView];
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.errorView.hidden = YES;
    @weakify(self);
    [self.errorView setRetryBlock:^{
        @strongify(self); if (!self) return;
        [self requestHistorySubjects];
    }];
    
    self.emptyView = [[YXExerciseEmptyView alloc] init];
    self.emptyView.hidden = YES;
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)requestHistorySubjects {
    if (self.request) {
        [self.request stopRequest];
    }
    self.request = [[YXGetPracticeEditionRequest alloc] init];
    self.request.stageId = [YXUserManager sharedManager].userModel.stageid;
    @weakify(self);
    [self yx_startLoading];
    [self.request startRequestWithRetClass:[GetPracticeEditionRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        @strongify(self);
        [self yx_stopLoading];
        self.errorView.hidden = YES;
        self.emptyView.hidden = YES;
        GetPracticeEditionRequestItem *item = retItem;
        if (item && item.subjects.count == 0) {
            if (item.status.desc) {
                [self.emptyView setEmptyText:item.status.desc];
            }
            self.emptyView.hidden = NO;
            return;
        }
        if (error) {
            self.errorView.errorCode = [NSString stringWithFormat:@"%@", @(error.code)];
            self.errorView.hidden = NO;
            return;
        }
        
        self.item = item;
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.item.subjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YXMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kYXMineCellIdentifier];
    cell.isTextLabelInset = YES;
    cell.showLine = [self showLineAtIndexPath:indexPath];
    GetPracticeEditionRequestItem_subject *subject = self.item.subjects[indexPath.row];
    [cell setTitle:subject.name image:[UIImage imageNamed:[YXSubjectImageHelper myImageNameWithType:[subject.subjectID integerValue]]]];
    [cell updateWithAccessoryText:subject.edition.editionName];
    return cell;
}

- (BOOL)showLineAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger count = [self tableView:self.tableView numberOfRowsInSection:indexPath.section];
    return (indexPath.row < count - 1) && (count > 1);
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 25.f;
    }
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat defaultHeight = 62.f;
    if ([self showLineAtIndexPath:indexPath]) {
        defaultHeight += 2.f;
    }
    return defaultHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ExerciseHistoryContentViewController *vc = [[ExerciseHistoryContentViewController alloc] init];
    vc.subject = self.item.subjects[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
