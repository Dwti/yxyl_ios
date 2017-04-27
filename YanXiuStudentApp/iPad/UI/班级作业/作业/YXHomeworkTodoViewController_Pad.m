//
//  YXHomeworkTodoViewController_Pad.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/2/1.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXHomeworkTodoViewController_Pad.h"
#import "YXCommonErrorView.h"
#import "YXQAAnswerQuestionViewController_Pad.h"

#import "YXHomeworkToDoFetcher.h"
#import "YXGetQuestionListRequest.h"
#import "YXSubmitQuestionRequest.h"

#import "YXHomeworkTodoCell.h"
#import "YXDashLineCell.h"
#import "YXSplitViewController.h"

@interface YXHomeworkTodoViewController_Pad ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) YXGetQuestionListRequest *request;
@property (nonatomic, assign) BOOL shouldBack;

@end

@implementation YXHomeworkTodoViewController_Pad

- (void)dealloc
{
    [self removeNotifications];
    [self.dataFetcher stop];
}

- (void)viewDidLoad
{
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"作业背景"]];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
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
    [self.request stopRequest];
    self.request = [[YXGetQuestionListRequest alloc] init];
    self.request.paperId = data.paperId;
    @weakify(self);
    [self yx_startLoading];
    [self.request startRequestWithRetClass:[YXIntelligenceQuestionListItem class] andCompleteBlock:^(id retItem, NSError *error) {
        @strongify(self);
        [self yx_stopLoading];
        YXIntelligenceQuestionListItem *item = retItem;
        if (item.data.count > 0 && !error) {
            YXQAAnswerQuestionViewController_Pad *vc = [[YXQAAnswerQuestionViewController_Pad alloc]init];
            vc.model = [QAPaperModel modelFromRawData:item.data[0]];
            vc.pType = YXPTypeGroupHomework;
            [self.yxSplitViewController.navigationController pushViewController:vc animated:YES];
        } else {
            [self yx_showToast:error.localizedDescription];
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
        cell.preferedGapToCellBounds = 90;
        cell.bHasShadow = NO;
        cell.realColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        YXHomeworkTodoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"data"];
        cell.edgeInterval = 75.f;
        cell.clockInterval = 160.f;
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
