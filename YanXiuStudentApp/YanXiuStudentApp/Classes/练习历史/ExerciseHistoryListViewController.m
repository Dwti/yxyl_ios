//
//  ExerciseHistoryListViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/11/3.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "ExerciseHistoryListViewController.h"
#import "YXGetPracticeEditionRequest.h"
#import "YXHistoryCell.h"
#import "YXDashLineCell.h"
#import "YXGetQuestionReportRequest.h"
#import "YXQAReportViewController.h"
#import "YXGetQuestionListRequest.h"
#import "YXAnswerQuestionViewController.h"
#import "YXTipsView.h"

@interface ExerciseHistoryListViewController ()
@property (nonatomic, strong) YXGetQuestionListRequest *questionListRequest;
@property (nonatomic, strong) YXGetQuestionReportRequest *reportRequest;
@end

@implementation ExerciseHistoryListViewController

- (void)viewDidLoad {
    self.errorView = [[YXCommonErrorView alloc] init];
    
    YXTipsView *emptyView = [[YXTipsView alloc] init];
    emptyView.title = @"%>_<%";
    emptyView.text = @"这里还没有题哦";
    NSString *typeString = (self.segment == YXExerciseListSegmentChapter ? @"考点":@"章节");
    emptyView.detailText = [NSString stringWithFormat:@"切换到【%@】看看吧", typeString];
    [emptyView show:NO];
    self.emptyView = emptyView;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.subject.name;
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[YXHistoryCell class] forCellReuseIdentifier:@"data"];
    [self.tableView registerClass:[YXDashLineCell class] forCellReuseIdentifier:@"dash"];

    [self setupObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupObserver {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:YXSubmitQuestionSuccessNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        [self firstPageFetch];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray.count == 0) {
        return 0;
    }
    return self.dataArray.count * 2 - 1;
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
        YXHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"data"];
        [cell updateWithData:self.dataArray[indexPath.row/2]];
        @weakify(self);
        cell.clickBlock = ^{
            @strongify(self); if (!self) return;
            if (indexPath.row % 2) {
                
            } else {
                YXGetPracticeHistoryItem_Data *data = self.dataArray[indexPath.row/2];
                if ([data isFinished]) {
                    [self requestReportDataWithPaperId:data.paperId];
                } else {
                    [self requestQuestionListWithPaperId:data.paperId];
                }
            }
        };
        return cell;
    }
    
    return nil;
}

- (void)requestReportDataWithPaperId:(NSString *)paperId{
    [self.reportRequest stopRequest];
    self.reportRequest = [[YXGetQuestionReportRequest alloc]init];
    self.reportRequest.ppid = paperId;
    self.reportRequest.flag = @"1";
    
    @weakify(self)
    [self yx_startLoading];
    [self.reportRequest startRequestWithRetClass:[YXIntelligenceQuestionListItem class] andCompleteBlock:^(id retItem, NSError *error) {
        @strongify(self)
        [self yx_stopLoading];
        if (error) {
            [self yx_showToast:error.localizedDescription];
        }else{
            [self goToReportVCWithItem:retItem];
        }
    }];
}
- (void)goToReportVCWithItem:(YXIntelligenceQuestionListItem *)item{
    YXQAReportViewController *vc = [[YXQAReportViewController alloc] init];
    YXQARequestParams *param = [[YXQARequestParams alloc] init];
    YXIntelligenceQuestion *q = item.data.firstObject;
    param.stageId = q.stageid;
    param.subjectId = q.subjectid;
    param.editionId = q.bedition;
    param.volumeId = q.volume;
    param.chapterId = q.chapterid;
    param.sectionId = q.sectionid;
    param.questNum = @"10";
    param.cellId = q.cellid;
    param.segment = self.segment;
    vc.requestParams = param;
    
    YXIntelligenceQuestion *question = nil;
    if (item.data.count > 0) {
        question = item.data[0];
        vc.model = [QAPaperModel modelFromRawData:question];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)requestQuestionListWithPaperId:(NSString *)paperId
{
    [self.questionListRequest stopRequest];
    self.questionListRequest = [[YXGetQuestionListRequest alloc] init];
    self.questionListRequest.paperId = paperId;
    @weakify(self);
    [self yx_startLoading];
    [self.questionListRequest startRequestWithRetClass:[YXIntelligenceQuestionListItem class] andCompleteBlock:^(id retItem, NSError *error) {
        @strongify(self);
        [self yx_stopLoading];
        YXIntelligenceQuestionListItem *item = retItem;
        if (item.data.count > 0 && !error) {
            YXAnswerQuestionViewController *vc = [[YXAnswerQuestionViewController alloc] init];
            YXQARequestParams *param = [[YXQARequestParams alloc] init];
            YXIntelligenceQuestion *q = item.data.firstObject;
            param.stageId = q.stageid;
            param.subjectId = q.subjectid;
            param.editionId = q.bedition;
            param.volumeId = q.volume;
            param.chapterId = q.chapterid;
            param.sectionId = q.sectionid;
            param.questNum = @"10";
            param.cellId = q.cellid;
            param.segment = self.segment;
            vc.requestParams = param;
            vc.model = [QAPaperModel modelFromRawData:item.data[0]];
            vc.pType = YXPTypeExerciseHistory;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [self yx_showToast:error.localizedDescription];
        }
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2) {
        return 2;
    }
    
    return 92;
}

@end
