//
//  ExerciseKnpTreeViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/28.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "ExerciseKnpTreeViewController.h"
#import "KnpTreeDataFetcher.h"
#import "GetKnpListRequest.h"
#import "ExerciseKnpTreeCell.h"
#import "YXGenKnpointQBlockRequest.h"
#import "QAAnswerQuestionViewController.h"

@interface ExerciseKnpTreeViewController ()
@property (nonatomic, strong) YXGenKnpointQBlockRequest *knpQuestionRequest;

@end

@implementation ExerciseKnpTreeViewController

- (void)viewDidLoad {
    KnpTreeDataFetcher *fetcher = [[KnpTreeDataFetcher alloc]init];
    fetcher.subjectID = self.subjectID;
    self.dataFetcher = fetcher;
    [super viewDidLoad];
    [self.treeView registerClass:[ExerciseKnpTreeCell class] forCellReuseIdentifier:@"ExerciseKnpTreeCell"];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TreeView
- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item {
    NSInteger level = [treeView levelForCellForItem:item];
    BOOL isExpand = [treeView isCellForItemExpanded:item];
    GetKnpListRequestItem_knp *knp = item;
    ExerciseKnpTreeCell *cell = [treeView dequeueReusableCellWithIdentifier:@"ExerciseKnpTreeCell"];
    cell.level = level;
    cell.knp = knp;
    cell.isExpand = isExpand;
    if ([self.treeNodes.firstObject isEqual:item]) {
        cell.isFirst = YES;
    }else {
        cell.isFirst = NO;
    }
    WEAK_SELF
    [cell setTreeExpandBlock:^(ExerciseKnpTreeCell *cell) {
        STRONG_SELF
        if (cell.isExpand) {
            [self.treeView collapseRowForItem:item];
        }else {
            [self.treeView expandRowForItem:item];
        }
        cell.isExpand = !cell.isExpand;
    }];
    [cell setTreeClickBlock:^(ExerciseKnpTreeCell *cell) {
        STRONG_SELF
        GetKnpListRequestItem_knp *knpFirst = nil;
        GetKnpListRequestItem_knp *knpSecond = nil;
        GetKnpListRequestItem_knp *knpThird = nil;
        GetKnpListRequestItem_knp *knpFourth = nil;
        if (level == 0) {
            knpFirst = cell.knp;
        } else if (level == 1) {
            knpSecond = cell.knp;
            knpFirst = [self.treeView parentForItem:knpFirst];
        } else if (level == 2) {
            knpThird = cell.knp;
            knpSecond = [self.treeView parentForItem:knpThird];
            knpFirst = [self.treeView parentForItem:knpSecond];
        }else if (level == 3) {
            knpFourth = cell.knp;
            knpThird = [self.treeView parentForItem:knpFourth];
            knpSecond = [self.treeView parentForItem:knpThird];
            knpFirst = [self.treeView parentForItem:knpSecond];
        }
        [self requestQuestionFirstId:knpFirst.knpID?:@"0"
                            secondId:knpSecond.knpID?:@"0"
                             thridId:knpThird.knpID?:@"0"
                            fourthId:knpFourth.knpID?:@"0"];
    }];
    
    return cell;
}
- (void)requestQuestionFirstId:(NSString *)knpId1
                      secondId:(NSString *)knpId2
                       thridId:(NSString *)knpId3
                      fourthId:(NSString *)knpId4 {
    if (self.knpQuestionRequest) {
        [self.knpQuestionRequest stopRequest];
    }
    YXGenKnpointQBlockRequest *request = [[YXGenKnpointQBlockRequest alloc] init];
    request.stageId = [YXUserManager sharedManager].userModel.stageid;
    request.subjectId = self.subjectID;
    request.questNum = @"10";
    request.knpId1 = knpId1;
    request.knpId2 = knpId2;
    request.knpId3 = knpId3;
    request.knpId4 = knpId4;
    request.fromType = @"2";
    [self.view nyx_startLoading];
    WEAK_SELF
    [request startRequestWithRetClass:[YXIntelligenceQuestionListItem class] andCompleteBlock:^(id retItem, NSError *error) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        YXIntelligenceQuestionListItem *item = retItem;
        YXIntelligenceQuestion *question = nil;
        if (item.data.count > 0) {
            question = item.data[0];
            QAAnswerQuestionViewController *vc = [[QAAnswerQuestionViewController alloc] init];
            vc.requestParams = [self answerQuestionParamsFirstId:knpId1 secondId:knpId2 thridId:knpId3 fourthId:knpId4];
            vc.model = [QAPaperModel modelFromRawData:question];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [self.view nyx_showToast:error.localizedDescription];
        }
    }];
    self.knpQuestionRequest = request;
}
#pragma mark - format data
- (YXQARequestParams *)answerQuestionParamsFirstId:(NSString *)knpId1
                                          secondId:(NSString *)knpId2
                                           thridId:(NSString *)knpId3
                                          fourthId:(NSString *)knpId4 {
    YXQARequestParams *params = [[YXQARequestParams alloc] init];
    params.stageId = [YXUserManager sharedManager].userModel.stageid;
    params.subjectId = self.subjectID;
    params.editionId = self.editionID;
    params.volumeId = self.volumeID;
    params.type = YXExerciseListTypeQuiz;
    params.segment = YXExerciseListSegmentTestItem;
    params.chapterId = knpId1;
    params.sectionId = knpId2;
    params.cellId = knpId3;
    params.pointId = knpId4;
    params.questNum = @"10";
    return params;
}

@end
