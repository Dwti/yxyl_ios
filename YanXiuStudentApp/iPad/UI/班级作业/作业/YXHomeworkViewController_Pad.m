//
//  YXHomeworkViewController_Pad.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/2/1.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXHomeworkViewController_Pad.h"
#import "YXTipsView.h"
#import "YXCommonErrorView.h"

#import "YXQAAnswerQuestionViewController_Pad.h"
#import "YXQAAnalysisViewController_Pad.h"
#import "YXQAReportViewController_Pad.h"

#import "YXSearchClassRequest.h"
#import "YXGetQuestionListRequest.h"
#import "YXExitClassRequest.h"
#import "YXGetQuestionReportRequest.h"
#import "YXHomeworkListFetcher.h"

#import "YXHomeworkCell2_2.h"
#import "YXDashLineCell.h"
#import "YXSplitViewController.h"
#import "YXQAAnalysisDataConfig.h"
#import "YXProblemItem.h"
#import "YXRecordManager.h"

@interface YXHomeworkViewController_Pad () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) YXGetQuestionListRequest *request;
@property (nonatomic, strong) YXGetQuestionReportRequest *reportRequest;

@end

@implementation YXHomeworkViewController_Pad

- (void)dealloc
{
    [self removeNotifications];
}

- (void)viewDidLoad {
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"作业背景"]];
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:backgroundImageView];
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    YXHomeworkListFetcher *fetcher = [[YXHomeworkListFetcher alloc] init];
    fetcher.gid = self.groupInfoData.groupId;
    self.dataFetcher = fetcher;
    
    self.errorView = [[YXCommonErrorView alloc] init];
    
    YXTipsView *emptyView = [[YXTipsView alloc] init];
    emptyView.title = @"O(∩_∩)O";
    emptyView.text = @"老师还没发布作业呢";
    [emptyView show:NO];
    self.emptyView = emptyView;
    
    [super viewDidLoad];
    [self yx_setupLeftBackBarButtonItem];
    self.title = self.groupInfoData.name;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 70;
    [self.tableView registerClass:[YXHomeworkCell2_2 class] forCellReuseIdentifier:@"YXHomeworkCell"];
    [self.tableView registerClass:[YXDashLineCell class] forCellReuseIdentifier:@"dash"];
    [self registerNotifications];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self yx_startLoading];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self firstPageFetch];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.request stopRequest];
    [self.reportRequest stopRequest];
}

- (void)registerNotifications
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(quitHomeworkGroupSuccess)
                   name:YXExitClassSuccessNotification
                 object:nil];
    [center addObserver:self
               selector:@selector(submitQuestionSuccess:)
                   name:YXSubmitQuestionSuccessNotification
                 object:nil];
    [center addObserver:self
               selector:@selector(firstPageFetch)
                   name:YXSavePaperSuccessNotification
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

- (void)quitHomeworkGroupSuccess
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)requestWithHomework:(YXHomework *)homework
{
    NSInteger status = [homework.paperStatus.status integerValue];
    switch (status) {
        case 0: // 进入答题界面（0 待完成）
        {
            @weakify(self);
            [self requestQuestionListWithHomework:homework completion:^(YXIntelligenceQuestionListItem *item, NSError *error) {
                @strongify(self);
                YXQAAnswerQuestionViewController_Pad *vc = [[YXQAAnswerQuestionViewController_Pad alloc]init];
                vc.model = [QAPaperModel modelFromRawData:item.data[0]];
                vc.pType = YXPTypeGroupHomework;
                if (!self.yxSplitViewController) {
                    // APNS
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    [self.yxSplitViewController.navigationController pushViewController:vc animated:YES];
                }
            }];
        }
            break;
        case 1: // 进入解析界面（1 未完成）
        {
            @weakify(self);
            [self requestQuestionListWithHomework:homework completion:^(YXIntelligenceQuestionListItem *item, NSError *error) {
                @strongify(self);
                YXQAAnalysisViewController_Pad *vc = [[YXQAAnalysisViewController_Pad alloc] init];
                vc.model = [QAPaperModel modelFromRawData:item.data[0]];
                vc.analysisDataDelegate = [[YXQAAnalysisDataConfig alloc] init];
                vc.pType = YXPTypeGroupHomework;
                [self.yxSplitViewController.navigationController pushViewController:vc animated:YES];
            }];
        }
            break;
        case 2: // 进入答题报告界面（2 已完成）
        {
            [self requestReportWithHomework:homework];
        }
            break;
        default:
            break;
    }
}

- (void)requestQuestionListWithHomework:(YXHomework *)homework
                             completion:(void(^)(YXIntelligenceQuestionListItem *, NSError *))completeBlock
{
    [self.request stopRequest];
    self.request = [[YXGetQuestionListRequest alloc] init];
    self.request.paperId = homework.paperId;
    @weakify(self);
    [self yx_startLoading];
    [self.request startRequestWithRetClass:[YXIntelligenceQuestionListItem class] andCompleteBlock:^(id retItem, NSError *error) {
        @strongify(self);
        [self yx_stopLoading];
        YXIntelligenceQuestionListItem *item = retItem;
        if (item.data.count > 0 && !error) {
            if (completeBlock) {
                completeBlock(retItem, nil);
            }
        } else {
            [self yx_showToast:error.localizedDescription];
        }
    }];
}

- (void)requestReportWithHomework:(YXHomework *)homework
{
    if ([homework.showana integerValue] == 1) { //暂不显示报告
        [self yx_showToast:[NSString stringWithFormat:@"%@之后才能查看报告", homework.overTime]];
        return;
    }
    
    [self.reportRequest stopRequest];
    self.reportRequest = [[YXGetQuestionReportRequest alloc] init];
    self.reportRequest.ppid = homework.paperId;
    self.reportRequest.flag = @"1";
    @weakify(self);
    [self yx_startLoading];
    [self.reportRequest startRequestWithRetClass:[YXIntelligenceQuestionListItem class] andCompleteBlock:^(id retItem, NSError *error) {
        @strongify(self);
        [self yx_stopLoading];
        YXIntelligenceQuestionListItem *item = retItem;
        if (item.data.count > 0 && !error) {
            YXQAReportViewController_Pad *vc = [[YXQAReportViewController_Pad alloc] init];
            vc.model = [QAPaperModel modelFromRawData:item.data[0]];
            vc.pType = YXPTypeGroupHomework;
            [self.yxSplitViewController.navigationController pushViewController:vc animated:YES];
        } else {
            [self yx_showToast:error.localizedDescription];
        }
    }];
}

#pragma mark - table view
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2) {
        return 2;
    }
    
    YXHomework *item = self.dataArray[indexPath.row/2];
    if ([item hasTeacherComments]) {
        return [tableView fd_heightForCellWithIdentifier:@"YXHomeworkCell" cacheByIndexPath:indexPath configuration:^(id cell) {
            [cell updateWithData:[YXHomeworkMock _mockItemFromRealItem:item]];
        }];
    }
    
    return 92;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count] * 2 - 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
        YXHomework *item = self.dataArray[indexPath.row/2];
        YXHomeworkCell2_2 *cell = [tableView dequeueReusableCellWithIdentifier:@"YXHomeworkCell"];
        [cell updateWithData:[YXHomeworkMock _mockItemFromRealItem:item]];
        if ([cell.status isEqualToString:YXHomeWorkStatusPartFinish]) {
            NSInteger total = item.quesnum.integerValue - cell.answerNum.integerValue;
            if (total) {
                YXProblemItem *problem = [YXProblemItem new];
                problem.quesNum = [NSString stringWithFormat:@"%ld", (long)total];
                problem.subjectID = item.subjectid;
                problem.gradeID = item.gradeid;
                problem.type = YXRecordReciveWorkType;
                [YXRecordManager addRecord:problem];
            }
        }
//        cell.edgeInte*-r0val = 75.f;
//        cell.clockInterval = 160.f;
        @weakify(self);
        cell.clickBlock = ^{
            @strongify(self); if (!self) return;
            [self requestWithHomework:self.dataArray[indexPath.row/2]];
        };
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row % 2) {
        
    } else {
        [self requestWithHomework:self.dataArray[indexPath.row/2]];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    return v;
}

@end
