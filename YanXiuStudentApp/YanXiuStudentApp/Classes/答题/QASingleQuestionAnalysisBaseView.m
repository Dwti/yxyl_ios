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
#import "QAAnaysisGapCell.h"
#import "QAAnalysisBaseCell.h"
#import "QAAnalysisResultCell.h"
#import "QAAnalysisScoreCell.h"
#import "QAAnalysisDifficultyCell.h"
#import "QAAnalysisAnalysisCell.h"
#import "QAAnalysisAnswerCell.h"
#import "QAAnalysisKnowledgePointCell.h"
#import "QAAnalysisAudioCommentCell.h"

@interface QASingleQuestionAnalysisBaseView() <
YXKnowledgePointViewDelegate,
YXQAAnalysisReportErrorViewDelegate,
YXQAAnalysisUnfoldDelegate
>

@property (nonatomic, strong) NSMutableArray *analysisDataArray;
@property (nonatomic, assign) NSUInteger analysisCellCount;
@property (nonatomic, strong) NSArray *testArray;

@end


@implementation QASingleQuestionAnalysisBaseView

- (void)dealloc {
    [self.tableView removeObserver:self forKeyPath:@"contentSize"];
}
- (void)setupUI {
    [super setupUI];
    [self setupRAC];
    NSInteger oriCount = self.cellHeightArray.count;
    [self setupSingleQuestionAnalysisContent];
    self.analysisCellCount = self.cellHeightArray.count - oriCount - 1;
    
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
    
    [self.tableView registerClass:[QAAnaysisGapCell class] forCellReuseIdentifier:@"QAAnaysisGapCell"];
    [self.tableView registerClass:[QAAnalysisBaseCell class] forCellReuseIdentifier:@"QAAnalysisBaseCell"];
    [self.tableView registerClass:[QAAnalysisResultCell class] forCellReuseIdentifier:@"QAAnalysisResultCell"];
    [self.tableView registerClass:[QAAnalysisScoreCell class] forCellReuseIdentifier:@"QAAnalysisScoreCell"];
    [self.tableView registerClass:[QAAnalysisDifficultyCell class] forCellReuseIdentifier:@"QAAnalysisDifficultyCell"];
    [self.tableView registerClass:[QAAnalysisAnalysisCell class] forCellReuseIdentifier:@"QAAnalysisAnalysisCell"];
    [self.tableView registerClass:[QAAnalysisAnswerCell class] forCellReuseIdentifier:@"QAAnalysisAnswerCell"];
    [self.tableView registerClass:[QAAnalysisKnowledgePointCell class] forCellReuseIdentifier:@"QAAnalysisKnowledgePointCell"];
    [self.tableView registerClass:[QAAnalysisAudioCommentCell class] forCellReuseIdentifier:@"QAAnalysisAudioCommentCell"];
    
    [self setupAnalysisBGViewUI];
}

- (void)setupAnalysisBGViewUI {
    self.analysisBGView = [[QAAnalysisBackGroundView alloc]init];
    [self.tableView insertSubview:self.analysisBGView atIndex:0];
    [self.tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];
    
    if (self.isPaperSubmitted) {
        if ([self.analysisDataDelegate shouldShowAnalysisDataWithQAItemType:self.data.templateType analysisType:YXAnalysisScore] ||
            [self.analysisDataDelegate shouldShowAnalysisDataWithQAItemType:self.data.templateType analysisType:YXAnalysisResult]
            ) {
            if (self.data.questionType == YXQAItemFill ||
                self.data.questionType == YXQAItemListenFill ||
                self.data.questionType == YXQAItemListenAudioFill ||
                self.data.questionType == YXQAItemTranslate ||
                self.data.questionType == YXQAItemCorrect) {
                
                if (self.data.isMarked) {
                    self.analysisBGView.stateImgView.hidden = NO;
                    self.analysisBGView.isCorrect = self.data.score == 5 ? YES : NO;
                }else {
                    self.analysisBGView.stateImgView.hidden = YES;
                    self.analysisBGView.stateImgView.image = nil;
                }
            }
        }
        if ([self.analysisDataDelegate shouldShowAnalysisDataWithQAItemType:self.data.templateType analysisType:YXAnalysisCurrentStatus]) {
            if (self.data.answerState == YXAnswerStateCorrect) {
                self.analysisBGView.stateImgView.hidden = NO;
                self.analysisBGView.isCorrect = YES;
            }else {
                self.analysisBGView.stateImgView.hidden = NO;
                self.analysisBGView.isCorrect = NO;
            }
        }
    }
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    [self setupAnalysisBGViewLayout];
}

-(void)setupAnalysisBGViewLayout {
    __block CGFloat startPostion;
    NSInteger analysisStartRowIndex = self.cellHeightArray.count - self.analysisCellCount;
    [self.cellHeightArray enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        startPostion += [obj floatValue];
        if (idx == analysisStartRowIndex - 1) {
            *stop = YES;
        }
    }];
    self.analysisBGView.frame = CGRectMake(0, startPostion, self.tableView.width, self.tableView.contentSize.height - startPostion);
    
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
    if (indexPath.row < analysisStartRowIndex - 1) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    if (indexPath.row == analysisStartRowIndex - 1) {
        QAAnaysisGapCell *cell = [[QAAnaysisGapCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        return cell;
    }
    
    NSInteger analysisDataIndex = indexPath.row - analysisStartRowIndex;
    if (analysisDataIndex < self.analysisDataArray.count) {
        
        YXQAAnalysisItem *data = self.analysisDataArray[analysisDataIndex];
        
        if (data.type == YXAnalysisCurrentStatus) {
            //            YXLabelHtmlCell2 *cell = [[YXLabelHtmlCell2 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            //            cell.delegate = self;
            //            cell.item = data;
            //            cell.htmlString = self.data.answerCompare;
            //            return cell;
            QAAnalysisResultCell *cell = [[QAAnalysisResultCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.delegate = self;
            cell.item = data;
            cell.htmlString = self.data.answerCompare;
            cell.type = QAAnswerResultType_Objective;
            cell.isCorrect = self.data.answerState == YXAnswerStateCorrect ? YES : NO;
            [cell updateUI];
            return cell;
        }
        else if (data.type == YXAnalysisDifficulty) {
            //            YXDifficultyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXDifficultyCell" forIndexPath:indexPath];
            //            cell.item = data;
            //            cell.difficulty = self.data.difficulty;
            //            return cell;
            QAAnalysisDifficultyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAAnalysisDifficultyCell" forIndexPath:indexPath];
            cell.item = data;
            cell.difficulty = self.data.difficulty;
            return cell;
            
        } else if (data.type == YXAnalysisAnswer) {
            //            AnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AnswerCell" forIndexPath:indexPath];
            //            cell.delegate = self;
            //            cell.item = data;
            //            cell.htmlString = [self.data answerPresentation];
            //            return cell;
            QAAnalysisAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAAnalysisAnswerCell" forIndexPath:indexPath];
            cell.delegate = self;
            cell.item = data;
            cell.htmlString = [self.data answerPresentation];
            return cell;
            
        } else if (data.type == YXAnalysisAnalysis) {
            //            YXAnalysisCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXAnalysisCell" forIndexPath:indexPath];
            //            cell.delegate = self;
            //            cell.item = data;
            //            cell.htmlString = self.data.analysis;
            //            return cell;
            QAAnalysisAnalysisCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAAnalysisAnalysisCell" forIndexPath:indexPath];
            cell.delegate = self;
            cell.item = data;
            cell.htmlString = self.data.analysis;
            return cell;
            
        } else if (data.type == YXAnalysisKnowledgePoint) {
            //            YXKnpCell *cell = [[YXKnpCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YXKnpCell"];
            //            cell.delegate = self;
            //            cell.item = data;
            //            cell.knpClickable = self.canDoExerciseFromKnp;
            //            cell.knpArray = self.data.knowledgePoints;
            //            return cell;
            QAAnalysisKnowledgePointCell *cell = [[QAAnalysisKnowledgePointCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YXKnpCell"];
            cell.item = data;
            //            cell.knowledgePointArray = self.data.knowledgePoints;
            cell.knowledgePointArray = self.testArray;
            cell.isShowLine = NO;
            return cell;
        } else if (data.type == YXAnalysisScore) {
            //            YXCommentCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"YXCommentCell2" forIndexPath:indexPath];
            //            cell.comment = self.data.comment;
            //            cell.item = data;
            //            cell.score = self.data.score/5;
            //            cell.marked = self.data.isMarked;
            //            [cell updateUI];
            //            return cell;
            
            QAAnalysisScoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAAnalysisScoreCell" forIndexPath:indexPath];
            cell.item = data;
            cell.score = self.data.score;
            cell.isMarked = self.data.isMarked;
            [cell updateUI];
            return cell;
        } else if (data.type == YXAnalysisResult) {
            //            CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
            //            cell.item = data;
            //            cell.isMarked = self.data.isMarked;
            //            cell.isCorrect = self.data.score == 5 ? YES : NO;
            //            [cell updateUI];
            //            return cell;
            QAAnalysisResultCell *cell = [[QAAnalysisResultCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.delegate = self;
            cell.item = data;
            cell.htmlString = self.data.answerCompare;
            cell.type = QAAnswerResultType_Subjective;
            cell.isCorrect = self.data.score == 5 ? YES : NO;
            cell.isMarked = self.data.isMarked;
            [cell updateUI];
            return cell;
        } else if (data.type == YXAnalysisAudioComment) {
            //            AudioCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AudioCommentCell" forIndexPath:indexPath];
            //            cell.analysisItem = data;
            //            cell.questionItem = self.data;
            //            return cell;
            QAAnalysisAudioCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAAnalysisAudioCommentCell" forIndexPath:indexPath];
            cell.item = data;
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
        }
        //        else if (data.type == YXAnalysisErrorReport) {
        //            YXReportErrorCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXReportErrorCell" forIndexPath:indexPath];
        //            cell.delegate = self;
        //            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //            return cell;
        //        }
        else {
            return [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        }
    }
    else {
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
    [self.cellHeightArray addObject:@([QAAnaysisGapCell height])];
    
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
                //                [self.cellHeightArray addObject:@([CommentCell heightForStatus])];
                [self.cellHeightArray addObject:@([QAAnalysisResultCell heightForString:self.data.answerCompare])];
            } else {
                item.type = YXAnalysisScore;
                //                [self.cellHeightArray addObject:@([YXCommentCell2 heightForMarkStatus:self.data.isMarked score:self.data.score/5 comment:self.data.comment])];
                [self.cellHeightArray addObject:@([QAAnalysisScoreCell height])];
            }
            
            [self.analysisDataArray addObject:item];
        }
    }
    
    if (!isEmpty(self.data.audioComments)) {
        if ([self.analysisDataDelegate shouldShowAnalysisDataWithQAItemType:self.data.templateType analysisType:YXAnalysisAudioComment]) {
            YXQAAnalysisItem *item = [[YXQAAnalysisItem alloc]init];
            item.type = YXAnalysisAudioComment;
            [self.analysisDataArray addObject:item];
            [self.cellHeightArray addObject:@([QAAnalysisAudioCommentCell heightForAudioComment:self.data.audioComments])];
            
        }
    }
    if (self.isPaperSubmitted) {//提交了就显示对错
        if ([self.analysisDataDelegate shouldShowAnalysisDataWithQAItemType:self.data.templateType analysisType:YXAnalysisCurrentStatus]) {
            YXQAAnalysisItem *item = [[YXQAAnalysisItem alloc]init];
            item.type = YXAnalysisCurrentStatus;
            [self.analysisDataArray addObject:item];
            //            [self.cellHeightArray addObject:@([YXLabelHtmlCell2 heightForString:self.data.answerCompare])];
            [self.cellHeightArray addObject:@([QAAnalysisResultCell heightForString:self.data.answerCompare])];
        }
    }
    if (!isEmpty(self.data.difficulty)) {
        if ([self.analysisDataDelegate shouldShowAnalysisDataWithQAItemType:self.data.templateType analysisType:YXAnalysisDifficulty]) {
            YXQAAnalysisItem *item = [[YXQAAnalysisItem alloc]init];
            item.type = YXAnalysisDifficulty;
            [self.analysisDataArray addObject:item];
            //            [self.cellHeightArray addObject:@([YXDifficultyCell height])];
            [self.cellHeightArray addObject:@([QAAnalysisDifficultyCell height])];
        }
    }
    if ([self isShowAnswer:self.data]) {
        if ([self.analysisDataDelegate shouldShowAnalysisDataWithQAItemType:self.data.templateType analysisType:YXAnalysisAnswer]) {
            YXQAAnalysisItem *item = [[YXQAAnalysisItem alloc]init];
            item.type = YXAnalysisAnswer;
            [self.analysisDataArray addObject:item];
            
            //            [self.cellHeightArray addObject:@([AnswerCell heightForString:[self.data answerPresentation]])];
            [self.cellHeightArray addObject:@([QAAnalysisAnswerCell heightForString:[self.data answerPresentation]])];
        }
    }
    if (!isEmpty(self.data.analysis)) {
        if ([self.analysisDataDelegate shouldShowAnalysisDataWithQAItemType:self.data.templateType analysisType:YXAnalysisAnalysis]) {
            YXQAAnalysisItem *item = [[YXQAAnalysisItem alloc]init];
            item.type = YXAnalysisAnalysis;
            [self.analysisDataArray addObject:item];
            //            [self.cellHeightArray addObject:@([YXAnalysisCell heightForString:self.data.analysis])];
            [self.cellHeightArray addObject:@([QAAnalysisAnalysisCell heightForString:self.data.analysis])];
            
        }
    }
    if (!isEmpty(self.data.knowledgePoints)) {
        if ([self.analysisDataDelegate shouldShowAnalysisDataWithQAItemType:self.data.templateType analysisType:YXAnalysisKnowledgePoint]) {
            YXQAAnalysisItem *item = [[YXQAAnalysisItem alloc]init];
            item.type = YXAnalysisKnowledgePoint;
            [self.analysisDataArray addObject:item];
            //            [self.cellHeightArray addObject:@([YXKnpCell heightForPoints:self.data.knowledgePoints])];
            
            QAKnowledgePoint *p0 = [[QAKnowledgePoint alloc]init];
            p0.name = @"历史";
            QAKnowledgePoint *p1 = [[QAKnowledgePoint alloc]init];
            p1.name = @"秦朝";
            QAKnowledgePoint *p2 = [[QAKnowledgePoint alloc]init];
            p2.name = @"御史大夫";
            QAKnowledgePoint *p3 = [[QAKnowledgePoint alloc]init];
            p3.name = @"小章节";
            QAKnowledgePoint *p4 = [[QAKnowledgePoint alloc]init];
            p4.name = @"检查职能";
            QAKnowledgePoint *p5 = [[QAKnowledgePoint alloc]init];
            p5.name = @"知识点";
            QAKnowledgePoint *p6 = [[QAKnowledgePoint alloc]init];
            p6.name = @"机构";
            NSArray *testArray = @[
                                   p0,
                                   p1,
                                   p2,
                                   p3,
                                   p4,
                                   p5,
                                   p6
                                   ];
            self.testArray = testArray;
            
            QAAnalysisKnowledgePointCell *cell = [[QAAnalysisKnowledgePointCell alloc]init];
            [self.cellHeightArray addObject:@([cell heightWithKnowledgePointArray:self.testArray])];
        }
    }
    if ([self.analysisDataDelegate shouldShowAnalysisDataWithQAItemType:self.data.templateType analysisType:YXAnalysisNote]) {
        YXQAAnalysisItem *item2 = [[YXQAAnalysisItem alloc]init];
        item2.type = YXAnalysisNote;
        [self.analysisDataArray addObject:item2];
        [self.cellHeightArray addObject:@([MistakeNoteTableViewCell heightForNoteWithQuestion:self.data isEditable:NO])];
    }
    //    if ([self.analysisDataDelegate shouldShowAnalysisDataWithQAItemType:self.data.templateType analysisType:YXAnalysisErrorReport]) {
    //        YXQAAnalysisItem *item2 = [[YXQAAnalysisItem alloc]init];
    //        item2.type = YXAnalysisErrorReport;
    //        [self.analysisDataArray addObject:item2];
    //        [self.cellHeightArray addObject:@([YXReportErrorCell height])];
    //    }
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
