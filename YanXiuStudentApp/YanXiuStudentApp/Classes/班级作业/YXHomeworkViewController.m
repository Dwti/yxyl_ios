//
//  YXHomeworkViewController.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/10/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "YXHomeworkViewController.h"

#import "YXClassInfoViewController.h"
#import "YXTipsView.h"
#import "YXCommonErrorView.h"
#import "YXAnswerQuestionViewController.h"
#import "YXJieXiViewController.h"
#import "YXQAReportViewController.h"
#import "YXSearchClassRequest.h"
#import "YXGetQuestionListRequest.h"
#import "YXExitClassRequest.h"
#import "YXGetQuestionReportRequest.h"
#import "YXHomeworkListFetcher.h"
#import "YXRedManager.h"
#import "YXHomeworkCell2_2.h"
#import "YXRedManager.h"
#import "YXDashLineCell.h"
#import "YXRecordManager.h"
#import "YXProblemItem.h"
#import "PagedListFetcherBase.h"

@interface YXHomeworkViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) PagedListFetcherBase *fetcher;
@end

@implementation YXHomeworkViewController

- (void)dealloc
{
    [self removeNotifications];
}

- (instancetype)initWithFetcher:(PagedListFetcherBase *)fetcher {
    if (self = [super init]) {
        self.fetcher = fetcher;
    }
    return self;
}

- (void)viewDidLoad {
    UIImageView *backgroundImageView = [[UIImageView alloc] init];
    backgroundImageView.image = [UIImage imageNamed:@"背景01"];
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:backgroundImageView];
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.dataFetcher = self.fetcher;
    
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
    [YXRedManager requestPendingHomeWorkNumber];
//    [self firstPageFetch];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
            WEAK_SELF
            [self requestQuestionListWithHomework:homework completion:^(YXIntelligenceQuestionListItem *item, NSError *error) {
                STRONG_SELF
                YXAnswerQuestionViewController *vc = [[YXAnswerQuestionViewController alloc] init];
                vc.model = [QAPaperModel modelFromRawData:item.data[0]];
                vc.pType = YXPTypeGroupHomework;
                [self.navigationController pushViewController:vc animated:YES];
            }];
        }
            break;
        case 1: // 进入解析界面（1 未完成）
        {
            WEAK_SELF
            [self requestQuestionListWithHomework:homework completion:^(YXIntelligenceQuestionListItem *item, NSError *error) {
                STRONG_SELF
                YXJieXiViewController *vc = [[YXJieXiViewController alloc] init];
                vc.model = [QAPaperModel modelFromRawData:item.data[0]];
                vc.pType = YXPTypeGroupHomework;
                vc.analysisDataDelegate = [[YXQAAnalysisDataConfig alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
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
                             completion:(void(^)(YXIntelligenceQuestionListItem *item, NSError *error))completeBlock
{
    [self yx_startLoading];
    WEAK_SELF
    [ClassHomeworkDataManager getQuestionListWithPaperID:homework.paperId completeBlock:^(YXIntelligenceQuestionListItem *item, NSError *error) {
        STRONG_SELF
        [self yx_stopLoading];
        if (error) {
            [self yx_showToast:error.localizedDescription];
            return;
        }
        if (item.data.count > 0) {
            BLOCK_EXEC(completeBlock,item,nil);
        }
    }];
}

- (void)requestReportWithHomework:(YXHomework *)homework
{
    if (![homework shouldDisplayTheReport]) { //暂不显示报告
        [self yx_showToast:[NSString stringWithFormat:@"%@之后才能查看报告", homework.overTime]];
        return;
    }
    [self yx_startLoading];
    WEAK_SELF
    [ClassHomeworkDataManager getQuestionReportWithPaperID:homework.paperId completeBlock:^(YXIntelligenceQuestionListItem *item, NSError *error) {
        STRONG_SELF
        [self yx_stopLoading];
        if (error) {
            [self yx_showToast:error.localizedDescription];
            return;
        }
        if (item.data.count > 0) {
            YXIntelligenceQuestion *question = item.data[0];
            YXQAReportViewController *vc = [[YXQAReportViewController alloc] init];
            vc.model = [QAPaperModel modelFromRawData:question];
            vc.pType = YXPTypeGroupHomework;
            [self.navigationController pushViewController:vc animated:YES];
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
        cell.preferedGapToCellBounds = 50;
        cell.bHasShadow = NO;
        cell.realColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        YXHomeworkCell2_2 *cell = [tableView dequeueReusableCellWithIdentifier:@"YXHomeworkCell"];
        YXHomework *item = self.dataArray[indexPath.row/2];
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
