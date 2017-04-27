//
//  YXExerciseHistoryViewController.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/9.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXExerciseHistoryViewController_Pad.h"
#import "YXMineTableViewCell.h"
#import "YXSubjectImageHelper.h"
#import "YXGetPracticeEditionRequest.h"
#import "YXCommonErrorView.h"
#import "YXExerciseEmptyView.h"

#import "YXExerciseHistoryChooseChapterKnpViewController_Pad.h"

@interface YXExerciseHistoryViewController_Pad ()

@property (nonatomic, strong) YXGetPracticeEditionRequest *request;
@property (nonatomic, strong) YXNodeElementListItem *item;
@property (nonatomic, strong) YXCommonErrorView *errorView;
@property (nonatomic, strong) YXExerciseEmptyView *emptyView;

@end

@implementation YXExerciseHistoryViewController_Pad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"练习历史";
    
    [self getPracticeHistory];
    
    self.errorView = [[YXCommonErrorView alloc] init];
    [self.view addSubview:self.errorView];
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.errorView.hidden = YES;
    @weakify(self);
    [self.errorView setRetryBlock:^{
        @strongify(self); if (!self) return;
        [self getPracticeHistory];
    }];
    
    _emptyView = [[YXExerciseEmptyView alloc] init];
    _emptyView.hidden = YES;
    [self.view addSubview:_emptyView];
    [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)reloadUI {
    if (self.errorView) {
        [self getPracticeHistory];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.request stopRequest];
}

- (void)getPracticeHistory
{
    self.item = nil;
    [self.tableView reloadData];
    
    if (self.request) {
        [self.request stopRequest];
    }
    self.request = [[YXGetPracticeEditionRequest alloc] init];
    self.request.stageId = [YXUserManager sharedManager].userModel.stageid;
    @weakify(self);
    [self yx_startLoading];
    [self.request startRequestWithRetClass:[YXNodeElementListItem class] andCompleteBlock:^(id retItem, NSError *error) {
        @strongify(self);
        [self yx_stopLoading];
        self.errorView.hidden = YES;
        self.emptyView.hidden = YES;
        YXNodeElementListItem *item = retItem;
        if (item && item.data.count == 0) {
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.item.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YXMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kYXMineCellIdentifier];
    cell.isTextLabelInset = YES;
    cell.showLine = [self showLineAtIndexPath:indexPath];
    YXNodeElement *subject = self.item.data[indexPath.row];
    [cell setTitle:subject.name image:[UIImage imageNamed:[YXSubjectImageHelper myImageNameWithType:[subject.eid integerValue]]]];
    [cell updateWithAccessoryText:subject.data.editionName];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YXExerciseHistoryChooseChapterKnpViewController_Pad *vc = [[YXExerciseHistoryChooseChapterKnpViewController_Pad alloc] init];
    vc.subject = self.item.data[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
