//
//  ExerciseChapterTreeViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/28.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "ExerciseChapterTreeViewController.h"
#import "ChapterTreeDataFetcher.h"
#import "ExerciseChapterTreeCell.h"
#import "YXGetSectionQBlockRequest.h"
#import "QAAnswerQuestionViewController.h"

@interface ExerciseChapterTreeViewController ()
@property (nonatomic, strong) YXGetSectionQBlockRequest *chapterRequest;


@end

@implementation ExerciseChapterTreeViewController

- (void)viewDidLoad {
    ChapterTreeDataFetcher *fetcher = [[ChapterTreeDataFetcher alloc]init];
    fetcher.volumeID = self.volumeID;
    fetcher.subjectID = self.subjectID;
    fetcher.editionID = self.editionID;
    self.dataFetcher = fetcher;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.treeView registerClass:[ExerciseChapterTreeCell class] forCellReuseIdentifier:@"ExerciseChapterTreeCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setVolumeID:(NSString *)volumeID {
    if (_volumeID) {
        _volumeID = volumeID;
        ChapterTreeDataFetcher *fetcher = (ChapterTreeDataFetcher *)self.dataFetcher;
        fetcher.volumeID = _volumeID;
        [self fetchTreeData];
    }else{
        _volumeID = volumeID;
    }
}

#pragma mark - TreeView
- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item {
    NSInteger level = [treeView levelForCellForItem:item];
    BOOL isExpand = [treeView isCellForItemExpanded:item];
    GetChapterListRequestItem_chapter *chapter = item;

    ExerciseChapterTreeCell *cell = [treeView dequeueReusableCellWithIdentifier:@"ExerciseChapterTreeCell"];
    cell.level = level;
    cell.chapter = chapter;
    cell.isExpand = isExpand;
    if ([self.treeNodes.firstObject isEqual:item]) {
        cell.isFirst = YES;
    }else {
        cell.isFirst = NO;
    }
    WEAK_SELF
    [cell setTreeExpandBlock:^(ExerciseChapterTreeCell *cell) {
        STRONG_SELF
        if (cell.isExpand) {
            [self.treeView collapseRowForItem:item];
        }else {
            [self.treeView expandRowForItem:item];
        }
        cell.isExpand = !cell.isExpand;
    }];
    [cell setTreeClickBlock:^(ExerciseChapterTreeCell *cell) {
        GetChapterListRequestItem_chapter *chapter1 = nil;
        GetChapterListRequestItem_chapter *chapter2 = nil;
        GetChapterListRequestItem_chapter *chapter3 = nil;
        if (level == 0) {
            chapter1 = cell.chapter;
        } else if (level == 1) {
            chapter2 = cell.chapter;
            chapter1 = [self.treeView parentForItem:chapter2];
        } else if (level == 2) {
            chapter3 = cell.chapter;
            chapter2 = [self.treeView parentForItem:chapter3];
            chapter1 = [self.treeView parentForItem:chapter2];
        }
        [self requestChapterFirst:chapter1.chapterID?:@"0" second:chapter2.chapterID?:@"0" thrid:chapter3.chapterID?:@"0"];
        
    }];
    
    return cell;
}

#pragma mark - request
- (void)requestChapterFirst:(NSString *)chapter1
                     second:(NSString *)chapter2
                      thrid:(NSString *)chapter3
{
    if (self.chapterRequest) {
        [self.chapterRequest stopRequest];
    }
    YXGetSectionQBlockRequest *request = [[YXGetSectionQBlockRequest alloc] init];
    request.stageId = [YXUserManager sharedManager].userModel.stageid;
    request.subjectId = self.subjectID;
    request.editionId = self.editionID;
    request.volumeId = self.volumeID;
    request.chapterId = chapter1;
    request.sectionId = chapter2;
    request.cellId = chapter3;
    request.questNum = @"10";
    [self.view nyx_startLoading];
    WEAK_SELF
    [request startRequestWithRetClass:[YXIntelligenceQuestionListItem class] andCompleteBlock:^(id retItem, NSError *error) {
        [self.view nyx_stopLoading];
        STRONG_SELF
        YXIntelligenceQuestionListItem *item = retItem;
        YXIntelligenceQuestion *question = nil;
        if (item.data.count > 0) {
            question = item.data[0];
            QAAnswerQuestionViewController *vc = [[QAAnswerQuestionViewController alloc] init];
            vc.requestParams = [self answerQuestionParamsWithFirst:chapter1 Second:chapter2 Thrid:chapter3];
            vc.model = [QAPaperModel modelFromRawData:question];
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            [self.view nyx_showToast:error.localizedDescription];
        }

    }];
    self.chapterRequest = request;

}
#pragma mark - format data
- (YXQARequestParams *)answerQuestionParamsWithFirst:(NSString *)chapter1
                                               Second:(NSString *)chapter2
                                                Thrid:(NSString *)chapter3{
    YXQARequestParams *params = [[YXQARequestParams alloc] init];
    params.stageId = [YXUserManager sharedManager].userModel.stageid;
    params.subjectId = self.subjectID;
    params.editionId = self.editionID;
    params.volumeId = self.volumeID;
    params.type = YXExerciseListTypeQuiz;
    params.segment = YXExerciseListSegmentChapter;
    params.chapterId = chapter1;
    params.sectionId = chapter2;
    params.cellId = chapter3;
    params.questNum = @"10";
    return params;
}

@end
