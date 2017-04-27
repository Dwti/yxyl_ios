//
//  YXMistakeSubjectViewController.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/9.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXMistakeSubjectViewController.h"
#import "YXMineTableViewCell.h"
#import "YXSubjectImageHelper.h"
#import "UIColor+YXColor.h"
#import "YXMistakeListViewController.h"
#import "YXCommonErrorView.h"
#import "YXExerciseEmptyView.h"
#import "YXMistakeListViewController.h"
#import "MistakeAllViewController.h"

@interface YXMistakeSubjectViewController ()

@property (nonatomic, strong) GetSubjectMistakeRequestItem *requestItem;
@property (nonatomic, strong) YXCommonErrorView *errorView;
@property (nonatomic, strong) YXExerciseEmptyView *emptyView;

@end

@implementation YXMistakeSubjectViewController

- (void)dealloc {
    DDLogWarn(@"release======>>%@",NSStringFromClass([self class]));
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的错题";
    [self yx_setupLeftBackBarButtonItem];
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
    self.errorView = [[YXCommonErrorView alloc] init];
    self.errorView.hidden = YES;
    WEAK_SELF
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self requestForMistakeEdition];
    }];
    [self.view addSubview:self.errorView];
    
    self.emptyView = [[YXExerciseEmptyView alloc] init];
    self.emptyView.hidden = YES;
    [self.view addSubview:_emptyView];
}
- (void)setupLayout {
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
    [self yx_startLoading];
    [[MistakeQuestionManager sharedInstance]requestSubjectMistakeWithCompleteBlock:^(GetSubjectMistakeRequestItem *item, NSError *error) {
        STRONG_SELF
        [self yx_stopLoading];
        self.errorView.hidden = YES;
        self.emptyView.hidden = YES;
        self.tableView.hidden = NO;
        if (error) {
            self.errorView.errorCode = [NSString stringWithFormat:@"%@", @(error.code)];
            self.errorView.hidden = NO;
        }else{
            if (item.subjectMistakes.count == 0) {
                if (item.status.desc) {
                    [self.emptyView setEmptyText:item.status.desc];
                }
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
    YXMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kYXMineCellIdentifier];
    cell.isTextLabelInset = YES;
    cell.showLine = [self showLineAtIndexPath:indexPath];
    GetSubjectMistakeRequestItem_subjectMistake *subject = self.requestItem.subjectMistakes[indexPath.row];
    [cell setTitle:subject.name image:[UIImage
                                       imageNamed:[YXSubjectImageHelper myImageNameWithType:[subject.subjectID integerValue]]]];
    [cell updateWithAccessoryCustomText:subject.data.wrongQuestionsCount];
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MistakeAllViewController *mistakeListVC = [[MistakeAllViewController alloc] init];
    mistakeListVC.subject = self.requestItem.subjectMistakes[indexPath.row];
    [self.navigationController pushViewController:mistakeListVC animated:YES];
}

@end
