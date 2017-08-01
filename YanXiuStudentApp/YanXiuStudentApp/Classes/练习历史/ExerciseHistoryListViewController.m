//
//  ExerciseHistoryListViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/11/3.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "ExerciseHistoryListViewController.h"
#import "YXGetPracticeEditionRequest.h"
#import "ExerciseHistoryListCell.h"
#import "YXGetQuestionReportRequest.h"
#import "QAReportViewController.h"
#import "YXGetQuestionListRequest.h"
#import "QAAnswerQuestionViewController.h"

@interface ExerciseHistoryListViewController ()
@property (nonatomic, strong) YXGetQuestionListRequest *questionListRequest;
@property (nonatomic, strong) YXGetQuestionReportRequest *reportRequest;
@end

@implementation ExerciseHistoryListViewController

- (void)viewDidLoad {
    self.errorView = [[YXCommonErrorView alloc] init];
    
    EmptyView *emptyView = [[EmptyView alloc] init];
    emptyView.title = @"%>_<% 这里还没有题哦";
//    emptyView.text = @"这里还没有题哦";
//    NSString *typeString = (self.segment == YXExerciseListSegmentChapter ? @"考点":@"章节");
//    emptyView.detailText = [NSString stringWithFormat:@"切换到【%@】看看吧", typeString];
//    [emptyView show:NO];
    self.emptyView = emptyView;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.subject.name;
    self.naviTheme = NavigationBarTheme_White;
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExerciseHistoryListCell *cell = [[ExerciseHistoryListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    YXGetPracticeHistoryItem_Data *data = self.dataArray[indexPath.row];
    cell.data = data;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YXGetPracticeHistoryItem_Data *data = self.dataArray[indexPath.row];
    if ([data isFinished]) {
        [self requestReportDataWithPaperId:data.paperId];
    } else {
        [self requestQuestionListWithPaperId:data.paperId];
    }
}

- (void)requestReportDataWithPaperId:(NSString *)paperId{
    [self.reportRequest stopRequest];
    self.reportRequest = [[YXGetQuestionReportRequest alloc]init];
    self.reportRequest.ppid = paperId;
    self.reportRequest.flag = @"1";
    
    @weakify(self)
    [self.view nyx_startLoading];
    [self.reportRequest startRequestWithRetClass:[YXIntelligenceQuestionListItem class] andCompleteBlock:^(id retItem, NSError *error) {
        @strongify(self)
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
        }else{
            [self goToReportVCWithItem:retItem];
        }
    }];
}
- (void)goToReportVCWithItem:(YXIntelligenceQuestionListItem *)item{
    QAReportViewController *vc = [[QAReportViewController alloc]init];
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
    [self.view nyx_startLoading];
    [self.questionListRequest startRequestWithRetClass:[YXIntelligenceQuestionListItem class] andCompleteBlock:^(id retItem, NSError *error) {
        @strongify(self);
        [self.view nyx_stopLoading];
        YXIntelligenceQuestionListItem *item = retItem;
        if (item.data.count > 0 && !error) {
            QAAnswerQuestionViewController *vc = [[QAAnswerQuestionViewController alloc] init];
            vc.model = [QAPaperModel modelFromRawData:item.data[0]];
            vc.pType = YXPTypeExerciseHistory;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [self.view nyx_showToast:error.localizedDescription];
        }
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
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

@end
