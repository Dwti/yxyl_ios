//
//  YXMistakeSubjectViewController.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/9.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXMistakeSubjectViewController.h"
#import "MistakeSubjectCell.h"
#import "YXSubjectImageHelper.h"
#import "YXCommonErrorView.h"
#import "EmptyView.h"
#import "MistakeAllViewController.h"
#import "YXErrorsPagedListFetcher.h"
#import "MistakeListViewController.h"
#import "MistakeKnpViewController.h"

@interface YXMistakeSubjectViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GetSubjectMistakeRequestItem *requestItem;
@property (nonatomic, strong) YXCommonErrorView *errorView;
@property (nonatomic, strong) EmptyView *emptyView;

@end

@implementation YXMistakeSubjectViewController

- (void)dealloc {
    DDLogWarn(@"release======>>%@",NSStringFromClass([self class]));
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的错题";
    self.naviTheme = NavigationBarTheme_White;
    self.view.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    self.emptyView = [[EmptyView alloc]init];
    self.emptyView.title = @"真棒！还没有错题哦";
    self.emptyView.image = [UIImage imageNamed:@"无错题插图"];
    self.emptyView.hidden = YES;
    [self.view addSubview:self.emptyView];
    [self setupUI];
    [self setupLayout];
    [self requestForMistakeEdition];
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kDeleteMistakeSuccessNotification object:nil] subscribeNext:^(NSNotification *notification) {
        STRONG_SELF
        [self requestForMistakeEdition];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - setupUI
- (void)setupUI {
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.rowHeight = 50;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 10)];
    self.tableView.tableHeaderView = headerView;
    [self.tableView registerClass:[MistakeSubjectCell class] forCellReuseIdentifier:@"MistakeSubjectCell"];
    [self.view addSubview:self.tableView];
    
    self.errorView = [[YXCommonErrorView alloc] init];
    self.errorView.hidden = YES;
    WEAK_SELF
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self requestForMistakeEdition];
    }];
    [self.view addSubview:self.errorView];
}
- (void)setupLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}
#pragma mark - request
- (void)requestForMistakeEdition {
    WEAK_SELF
    [self.view nyx_startLoading];
    [[MistakeQuestionManager sharedInstance]requestSubjectMistakeWithCompleteBlock:^(GetSubjectMistakeRequestItem *item, NSError *error) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        self.errorView.hidden = YES;
        self.emptyView.hidden = YES;
        self.tableView.hidden = NO;
        if (error) {
            self.errorView.hidden = NO;
        }else{
            if (item.subjectMistakes.count == 0) {
                self.emptyView.hidden = NO;
                self.tableView.hidden = YES;
            }else{
                self.requestItem = item;
                [self.tableView reloadData];
            }
        }
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.requestItem.subjectMistakes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MistakeSubjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MistakeSubjectCell"];
    cell.data = self.requestItem.subjectMistakes[indexPath.row];
    cell.shouldShowBottomLine = indexPath.row==self.requestItem.subjectMistakes.count-1;
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GetSubjectMistakeRequestItem_subjectMistake *subject = self.requestItem.subjectMistakes[indexPath.row];

    MistakeKnpViewController *vc = [[MistakeKnpViewController alloc] init];
    vc.subject = subject;
    vc.subjectID = subject.subjectID;
    
    [self.navigationController pushViewController:vc animated:YES];

}

@end
