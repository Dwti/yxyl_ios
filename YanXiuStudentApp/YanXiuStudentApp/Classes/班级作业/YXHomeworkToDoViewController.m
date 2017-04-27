//
//  YXHomeworkToDoViewController.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/10.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXHomeworkToDoViewController.h"
#import "YXCommonErrorView.h"
#import "YXAnswerQuestionViewController.h"

#import "YXHomeworkToDoFetcher.h"
#import "YXGetQuestionListRequest.h"
#import "YXSubmitQuestionRequest.h"

#import "YXHomeworkTodoCell.h"
#import "YXDashLineCell.h"

@interface YXHomeworkToDoViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) BOOL shouldBack;

@end

@implementation YXHomeworkToDoViewController

- (void)dealloc
{
    [self removeNotifications];
    [self.dataFetcher stop];
}

- (void)viewDidLoad
{
    UIImageView *backgroundImageView = [[UIImageView alloc] init];
    backgroundImageView.image = [UIImage imageNamed:@"背景01"];
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:backgroundImageView];
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    YXHomeworkToDoFetcher *fetcher = [[YXHomeworkToDoFetcher alloc] init];
    @weakify(self);
    fetcher.emptyBlock = ^{
        @strongify(self);
        [self yx_stopLoading];
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
        self.shouldBack = YES;
    };
    self.dataFetcher = fetcher;
    
    self.errorView = [[YXCommonErrorView alloc] init];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = YXBGGrayColor;
    self.title = @"待完成作业";
    [self yx_setupLeftBackBarButtonItem];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[YXHomeworkTodoCell class] forCellReuseIdentifier:@"data"];
    [self.tableView registerClass:[YXDashLineCell class] forCellReuseIdentifier:@"dash"];
    [self registerNotifications];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self yx_startLoading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.shouldBack) {
        [self yx_leftBackButtonPressed:nil];
    }
}

- (void)requestWithData:(YXHomework *)data
{
    [self yx_startLoading];
    WEAK_SELF
    [ClassHomeworkDataManager getQuestionListWithPaperID:data.paperId completeBlock:^(YXIntelligenceQuestionListItem *item, NSError *error) {
        STRONG_SELF
        [self yx_stopLoading];
        if (error) {
            [self yx_showToast:error.localizedDescription];
            return;
        }
        if (item.data.count > 0) {
            YXAnswerQuestionViewController *vc = [[YXAnswerQuestionViewController alloc] init];
            vc.model = [QAPaperModel modelFromRawData:item.data[0]];
            vc.pType = YXPTypeGroupHomework;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

- (void)registerNotifications
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(submitQuestionSuccess:)
                   name:YXSubmitQuestionSuccessNotification
                 object:nil];
}

- (void)submitQuestionSuccess:(NSNotification *)notification
{
    [self firstPageFetch];
}

- (void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count] * 2 - 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2) {
        YXDashLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dash"];
        cell.realWidth = 7;
        cell.dashWidth = 7;
        cell.preferedGapToCellBounds = 50;
        cell.bHasShadow = NO;
        cell.realColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        YXHomeworkTodoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"data"];
        [cell updateWithData:self.dataArray[indexPath.row/2]];
        @weakify(self);
        cell.clickBlock = ^{
            @strongify(self); if (!self) return;
            [self requestWithData:self.dataArray[indexPath.row/2]];
        };
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2) {
        return 2;
    }
    
    return 92;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row % 2) {
        
    } else {
        [self requestWithData:self.dataArray[indexPath.row/2]];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    return v;
}

@end
