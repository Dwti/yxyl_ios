//
//  QASingleQuestionAnalysisBaseView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/11.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QASingleQuestionAnalysisBaseView.h"
#import "YXDifficultyCell.h"
#import "YXKnpCell.h"
#import "YXReportErrorCell.h"
#import "YXQAAnalysisUnfoldDelegate.h"
#import "YXLabelHtmlCell2.h"
#import "YXAnalysisCell.h"
#import "YXCommentCell2.h"
#import "YXJieXiShowView.h"
#import "AnswerCell.h"
#import "QAQuestion.h"
#import "AudioCommentCell.h"
#import "CommentCell.h"
#import "MistakeNoteTableViewCell.h"
#import "EditNoteViewController.h"

@interface QASingleQuestionAnalysisBaseView() <
YXKnowledgePointViewDelegate,
YXQAAnalysisReportErrorViewDelegate,
YXQAAnalysisUnfoldDelegate
>

@property (nonatomic, strong) NSMutableArray *analysisDataArray;
@property (nonatomic, assign) NSUInteger analysisCellCount;
@end


@implementation QASingleQuestionAnalysisBaseView

- (void)setupUI {
    [super setupUI];
    [self setupRAC];
    NSInteger oriCount = self.cellHeightArray.count;
    [self setupSingleQuestionAnalysisContent];
    self.analysisCellCount = self.cellHeightArray.count - oriCount;
    
    [self.tableView registerClass:[YXDifficultyCell class] forCellReuseIdentifier:@"YXDifficultyCell"];
    [self.tableView registerClass:[YXKnpCell class] forCellReuseIdentifier:@"YXKnpCell"];
    [self.tableView registerClass:[YXReportErrorCell class] forCellReuseIdentifier:@"YXReportErrorCell"];
    [self.tableView registerClass:[AudioCommentCell class] forCellReuseIdentifier:@"AudioCommentCell"];
    [self.tableView registerClass:[YXLabelHtmlCell2 class] forCellReuseIdentifier:@"YXLabelHtmlCell2"];
    [self.tableView registerClass:[AnswerCell class] forCellReuseIdentifier:@"AnswerCell"];
    [self.tableView registerClass:[YXAnalysisCell class] forCellReuseIdentifier:@"YXAnalysisCell"];
    [self.tableView registerClass:[YXCommentCell2 class] forCellReuseIdentifier:@"YXCommentCell2"];
    [self.tableView registerClass:[CommentCell class] forCellReuseIdentifier:@"CommentCell"];
    [self.tableView registerClass:[MistakeNoteTableViewCell class] forCellReuseIdentifier:@"MistakeNoteTableViewCell"];
}

- (void)setupRAC {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:MistakeNoteSaveNotification object:nil] subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = x;
        if (self.data.questionID != noti.object) {
            return;
        }
        
        CGFloat noteCellHeight = [MistakeNoteTableViewCell heightForNoteWithQuestion: self.data isEditable:NO];
        [self.cellHeightArray replaceObjectAtIndex:(self.cellHeightArray.count - 1) withObject:@(noteCellHeight)];
        
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:(self.cellHeightArray.count - 1) inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - tableView datasource delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.analysisDataHidden) {
        return  self.cellHeightArray.count;
    }
    return self.cellHeightArray.count - self.analysisCellCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger analysisStartRowIndex = self.cellHeightArray.count - self.analysisCellCount;
    if (indexPath.row < analysisStartRowIndex) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    NSInteger analysisDataIndex = indexPath.row - analysisStartRowIndex;
    if (analysisDataIndex < self.analysisDataArray.count) {
        
        YXQAAnalysisItem *data = self.analysisDataArray[analysisDataIndex];
        
        if (data.type == YXAnalysisCurrentStatus) {
            YXLabelHtmlCell2 *cell = [[YXLabelHtmlCell2 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.delegate = self;
            cell.item = data;
            cell.htmlString = self.data.answerCompare;
            return cell;
        } else if (data.type == YXAnalysisStatistic) {
            YXLabelHtmlCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"YXLabelHtmlCell2" forIndexPath:indexPath];
            cell.delegate = self;
            cell.item = data;
            cell.htmlString = self.data.globalStatis;
            return cell;
        } else if (data.type == YXAnalysisDifficulty) {
            YXDifficultyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXDifficultyCell" forIndexPath:indexPath];
            cell.item = data;
            cell.difficulty = self.data.difficulty;
            return cell;
        } else if (data.type == YXAnalysisAnswer) {
            AnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AnswerCell" forIndexPath:indexPath];
            cell.delegate = self;
            cell.item = data;
            cell.htmlString = [self.data answerPresentation];
            return cell;
        } else if (data.type == YXAnalysisAnalysis) {
            YXAnalysisCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXAnalysisCell" forIndexPath:indexPath];
            cell.delegate = self;
            cell.item = data;
            cell.htmlString = self.data.analysis;
            return cell;
        } else if (data.type == YXAnalysisKnowledgePoint) {
            YXKnpCell *cell = [[YXKnpCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YXKnpCell"];
            cell.delegate = self;
            cell.item = data;
            cell.knpClickable = self.canDoExerciseFromKnp;
            cell.knpArray = self.data.knowledgePoints;
            return cell;
        } else if (data.type == YXAnalysisScore) {
            YXCommentCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"YXCommentCell2" forIndexPath:indexPath];
            cell.comment = self.data.comment;
            cell.item = data;
            cell.score = self.data.score/5;
            cell.marked = self.data.isMarked;
            [cell updateUI];
            return cell;
        } else if (data.type == YXAnalysisResult) {
            CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
            cell.item = data;
            cell.isMarked = self.data.isMarked;
            cell.isCorrect = self.data.score == 5 ? YES : NO;
            [cell updateUI];
            return cell;
        } else if (data.type == YXAnalysisAudioComment) {
            AudioCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AudioCommentCell" forIndexPath:indexPath];
            cell.analysisItem = data;
            cell.questionItem = self.data;
            return cell;
        } else if (data.type == YXAnalysisNote) {
            MistakeNoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MistakeNoteTableViewCell" forIndexPath:indexPath];
            cell.isEditable = NO;
            cell.item = data;
            cell.questionItem = self.data;
            cell.delegate = self.addPhotoHandler;
            [cell reloadViewWithArray:self.data.noteImages addEnable:NO];
            WEAK_SELF
            [cell setEditButtonTapped:^{
                STRONG_SELF
                [self.editNoteDelegate editNoteButtonTapped:self.data];
            }];
            return cell;
        }else if (data.type == YXAnalysisErrorReport) {
            YXReportErrorCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXReportErrorCell" forIndexPath:indexPath];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else {
            return [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        }
    } else {
        return [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (!self.analysisDataHidden) {
        return nil;
    }else {
        YXJieXiShowView *analysisShowView = [[YXJieXiShowView alloc]initWithFrame:CGRectMake(0, 0, 320, 54)];
        analysisShowView.delegate = self;
        return analysisShowView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (!self.analysisDataHidden) {
        return 0;
    }else {
        return [YXJieXiShowView height];
    }
}

#pragma mark - setAnalysisDataHidden
- (void)setAnalysisDataHidden:(BOOL)analysisDataHidden {
    [super setAnalysisDataHidden:analysisDataHidden];
    [self.tableView reloadData];
}

#pragma mark - YXQAAnalysisUnfoldDelegate
- (void)showAnalysisData {
    self.analysisDataHidden = NO;
}

#pragma mark - setupSingleQuestionAnalysisContent
- (void)setupSingleQuestionAnalysisContent {
    NSAssert([self.analysisDataDelegate respondsToSelector:@selector(shouldShowAnalysisDataWithQAItemType:analysisType:)], @"未设置解析数据委托");
    self.analysisDataArray = [NSMutableArray array];
    
    if (self.isPaperSubmitted) {
        if ([self.analysisDataDelegate shouldShowAnalysisDataWithQAItemType:self.data.templateType analysisType:YXAnalysisScore] ||
            [self.analysisDataDelegate shouldShowAnalysisDataWithQAItemType:self.data.templateType analysisType:YXAnalysisResult]
            ) {
            
            YXQAAnalysisItem *item = [[YXQAAnalysisItem alloc]init];

            if (self.data.questionType == YXQAItemFill ||
                self.data.questionType == YXQAItemListenFill ||
                self.data.questionType == YXQAItemListenAudioFill ||
                self.data.questionType == YXQAItemTranslate ||
                self.data.questionType == YXQAItemCorrect) {
                item.type = YXAnalysisResult;
                [self.cellHeightArray addObject:@([CommentCell heightForStatus])];
            } else {
                item.type = YXAnalysisScore;
                [self.cellHeightArray addObject:@([YXCommentCell2 heightForMarkStatus:self.data.isMarked score:self.data.score/5 comment:self.data.comment])];
            }
            
            [self.analysisDataArray addObject:item];
        }
    }
    if (!isEmpty(self.data.audioComments)) {
        if ([self.analysisDataDelegate shouldShowAnalysisDataWithQAItemType:self.data.templateType analysisType:YXAnalysisAudioComment]) {
            YXQAAnalysisItem *item = [[YXQAAnalysisItem alloc]init];
            item.type = YXAnalysisAudioComment;
            [self.analysisDataArray addObject:item];
            [self.cellHeightArray addObject:@([AudioCommentCell heightForAudioComment:self.data.audioComments])];
        }
    }
    if (!isEmpty(self.data.answerCompare)) {
        if ([self.analysisDataDelegate shouldShowAnalysisDataWithQAItemType:self.data.templateType analysisType:YXAnalysisCurrentStatus]) {
            YXQAAnalysisItem *item = [[YXQAAnalysisItem alloc]init];
            item.type = YXAnalysisCurrentStatus;
            [self.analysisDataArray addObject:item];
            [self.cellHeightArray addObject:@([YXLabelHtmlCell2 heightForString:self.data.answerCompare])];
        }
    }
    if (!isEmpty(self.data.globalStatis)) {
        if ([self.analysisDataDelegate shouldShowAnalysisDataWithQAItemType:self.data.templateType analysisType:YXAnalysisStatistic]) {
            YXQAAnalysisItem *item = [[YXQAAnalysisItem alloc]init];
            item.type = YXAnalysisStatistic;
            [self.analysisDataArray addObject:item];
            [self.cellHeightArray addObject:@([YXLabelHtmlCell2 heightForString:self.data.globalStatis])];
        }
    }
    if (!isEmpty(self.data.difficulty)) {
        if ([self.analysisDataDelegate shouldShowAnalysisDataWithQAItemType:self.data.templateType analysisType:YXAnalysisDifficulty]) {
            YXQAAnalysisItem *item = [[YXQAAnalysisItem alloc]init];
            item.type = YXAnalysisDifficulty;
            [self.analysisDataArray addObject:item];
            [self.cellHeightArray addObject:@([YXDifficultyCell height])];
        }
    }
    if ([self isShowAnswer:self.data]) {
        if ([self.analysisDataDelegate shouldShowAnalysisDataWithQAItemType:self.data.templateType analysisType:YXAnalysisAnswer]) {
            YXQAAnalysisItem *item = [[YXQAAnalysisItem alloc]init];
            item.type = YXAnalysisAnswer;
            [self.analysisDataArray addObject:item];
            
            [self.cellHeightArray addObject:@([AnswerCell heightForString:[self.data answerPresentation]])];
        }
    }
    if (!isEmpty(self.data.analysis)) {
        if ([self.analysisDataDelegate shouldShowAnalysisDataWithQAItemType:self.data.templateType analysisType:YXAnalysisAnalysis]) {
            YXQAAnalysisItem *item = [[YXQAAnalysisItem alloc]init];
            item.type = YXAnalysisAnalysis;
            [self.analysisDataArray addObject:item];
            [self.cellHeightArray addObject:@([YXAnalysisCell heightForString:self.data.analysis])];
        }
    }
    if (!isEmpty(self.data.knowledgePoints)) {
        if ([self.analysisDataDelegate shouldShowAnalysisDataWithQAItemType:self.data.templateType analysisType:YXAnalysisKnowledgePoint]) {
            YXQAAnalysisItem *item = [[YXQAAnalysisItem alloc]init];
            item.type = YXAnalysisKnowledgePoint;
            [self.analysisDataArray addObject:item];
            [self.cellHeightArray addObject:@([YXKnpCell heightForPoints:self.data.knowledgePoints])];
        }
    }
    if ([self.analysisDataDelegate shouldShowAnalysisDataWithQAItemType:self.data.templateType analysisType:YXAnalysisNote]) {
        YXQAAnalysisItem *item2 = [[YXQAAnalysisItem alloc]init];
        item2.type = YXAnalysisNote;
        [self.analysisDataArray addObject:item2];
        [self.cellHeightArray addObject:@([MistakeNoteTableViewCell heightForNoteWithQuestion:self.data isEditable:NO])];
    }
    if ([self.analysisDataDelegate shouldShowAnalysisDataWithQAItemType:self.data.templateType analysisType:YXAnalysisErrorReport]) {
        YXQAAnalysisItem *item2 = [[YXQAAnalysisItem alloc]init];
        item2.type = YXAnalysisErrorReport;
        [self.analysisDataArray addObject:item2];
        [self.cellHeightArray addObject:@([YXReportErrorCell height])];
    }
}

- (BOOL)isShowAnswer:(QAQuestion *)data {
    if (!isEmpty(data.correctAnswers) && ![data.correctAnswers.firstObject isEqual: @""]) {
        if (data.templateType == YXQATemplateSubjective) {
            return YES;
        }else if (!self.isPaperSubmitted){
            return YES;
        }
    }
    return NO;
}

#pragma mark - YXKnowledgePointViewDelegate
- (void)knowledgePointView:(YXKnowledgePointView *)pointView didSelectIndex:(NSInteger)index {
    QAKnowledgePoint *knowledgePoint = self.data.knowledgePoints[index];
    if (self.pointClickDelegate && [self.pointClickDelegate respondsToSelector:@selector(knpClickedWithID:)]) {
        [self.pointClickDelegate knpClickedWithID:knowledgePoint.knpID];
    }
}

#pragma mark - YXQAAnalysisReportErrorViewDelegate
- (void)reportErrorViewClicked {
    NSString * questionID = self.data.questionID;
    if (self.reportErrorDelegate && [self.reportErrorDelegate respondsToSelector:@selector(reportAnalysisErrorWithID:)]) {
        [self.reportErrorDelegate reportAnalysisErrorWithID:questionID];
    }
}

@end
