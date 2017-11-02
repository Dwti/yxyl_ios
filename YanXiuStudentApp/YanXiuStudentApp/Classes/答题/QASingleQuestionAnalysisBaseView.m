//
//  QASingleQuestionAnalysisBaseView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/11.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QASingleQuestionAnalysisBaseView.h"
#import "QAQuestion.h"
#import "QAOralAnswerQuestion.h"
#import "EditNoteViewController.h"
#import "QAAnaysisGapCell.h"
#import "QAAnalysisResultCell.h"
#import "QAAnalysisOralResultCell.h"
#import "QAAnalysisScoreCell.h"
#import "QAAnalysisDifficultyCell.h"
#import "QAAnalysisAnalysisCell.h"
#import "QAAnalysisAnswerCell.h"
#import "QAAnalysisKnowledgePointCell.h"
#import "QAAnalysisAudioCommentCell.h"
#import "QAAnalysisSubjectiveResultCell.h"
#import "QANoteCell.h"

@interface QASingleQuestionAnalysisBaseView() 

@property (nonatomic, strong) NSMutableArray *analysisDataArray;
@property (nonatomic, assign) NSUInteger analysisCellCount;

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
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    footerView.backgroundColor = [UIColor colorWithHexString:@"89e00d"];
    self.tableView.tableFooterView = footerView;
    [self.tableView registerClass:[QAAnaysisGapCell class] forCellReuseIdentifier:@"QAAnaysisGapCell"];
    [self.tableView registerClass:[QAAnalysisResultCell class] forCellReuseIdentifier:@"QAAnalysisResultCell"];
    [self.tableView registerClass:[QAAnalysisScoreCell class] forCellReuseIdentifier:@"QAAnalysisScoreCell"];
    [self.tableView registerClass:[QAAnalysisDifficultyCell class] forCellReuseIdentifier:@"QAAnalysisDifficultyCell"];
    [self.tableView registerClass:[QAAnalysisAnalysisCell class] forCellReuseIdentifier:@"QAAnalysisAnalysisCell"];
    [self.tableView registerClass:[QAAnalysisAnswerCell class] forCellReuseIdentifier:@"QAAnalysisAnswerCell"];
    [self.tableView registerClass:[QAAnalysisKnowledgePointCell class] forCellReuseIdentifier:@"QAAnalysisKnowledgePointCell"];
    [self.tableView registerClass:[QAAnalysisAudioCommentCell class] forCellReuseIdentifier:@"QAAnalysisAudioCommentCell"];
    [self.tableView registerClass:[QAAnalysisAudioCommentCell class] forCellReuseIdentifier:@"QAAnalysisSubjectiveResultCell"];
    [self.tableView registerClass:[QANoteCell class] forCellReuseIdentifier:@"QANoteCell"];
    [self.tableView registerClass:[QAAnalysisOralResultCell class] forCellReuseIdentifier:@"QAAnalysisOralResultCell"];

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
    __block CGFloat startPostion = 0;
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
        
        CGFloat noteCellHeight = [QANoteCell heightForText:self.data.noteText images:self.data.noteImages];
        [self.cellHeightArray replaceObjectAtIndex:(self.cellHeightArray.count - 1) withObject:@(noteCellHeight)];
        
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:(self.cellHeightArray.count - 1) inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - tableView datasource delegate
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    [self.tableView sendSubviewToBack:self.analysisBGView];
}

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
        QAAnalysisBaseCell *analysisCell = nil;
        if (data.type == YXAnalysisCurrentStatus) {
            if (self.data.templateType == YXQATemplateOral) {
                QAAnalysisOralResultCell *cell = [[QAAnalysisOralResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                cell.item = data;
                cell.oralScore = self.data.objectiveScore;
                QAOralAnswerQuestion *question = (QAOralAnswerQuestion *)self.data;
                cell.hasAnswer = !isEmpty(question.oralResultItem);
                return cell;
            }
            QAAnalysisResultCell *cell = [[QAAnalysisResultCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.delegate = self;
            cell.item = data;
            cell.htmlString = self.data.answerCompare;
            cell.isCorrect = self.data.answerState == YXAnswerStateCorrect ? YES : NO;
            [cell updateUI];
            analysisCell = cell;
        }
        else if (data.type == YXAnalysisDifficulty) {
            QAAnalysisDifficultyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAAnalysisDifficultyCell" forIndexPath:indexPath];
            cell.item = data;
            cell.difficulty = self.data.difficulty;
            analysisCell = cell;
            
        } else if (data.type == YXAnalysisAnswer) {
            QAAnalysisAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAAnalysisAnswerCell" forIndexPath:indexPath];
            cell.delegate = self;
            cell.item = data;
            cell.htmlString = [self.data answerPresentation];
            analysisCell = cell;
            
        } else if (data.type == YXAnalysisAnalysis) {
            QAAnalysisAnalysisCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAAnalysisAnalysisCell" forIndexPath:indexPath];
            cell.delegate = self;
            cell.item = data;
            cell.htmlString = self.data.analysis;
            analysisCell = cell;
            
        } else if (data.type == YXAnalysisKnowledgePoint) {
            QAAnalysisKnowledgePointCell *cell = [[QAAnalysisKnowledgePointCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YXKnpCell"];
            cell.item = data;
            cell.knowledgePointArray = self.data.knowledgePoints;
            analysisCell = cell;
        } else if (data.type == YXAnalysisScore) {
            QAAnalysisScoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAAnalysisScoreCell" forIndexPath:indexPath];
            cell.item = data;
            cell.score = self.data.score;
            cell.isMarked = self.data.isMarked;
            [cell updateUI];
            analysisCell = cell;
        } else if (data.type == YXAnalysisResult) {
            QAAnalysisSubjectiveResultCell *cell = [[QAAnalysisSubjectiveResultCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.item = data;
            cell.isCorrect = self.data.score == 5 ? YES : NO;
            cell.isMarked = self.data.isMarked;
            [cell updateUI];
            analysisCell = cell;
        } else if (data.type == YXAnalysisAudioComment) {
            QAAnalysisAudioCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAAnalysisAudioCommentCell" forIndexPath:indexPath];
            cell.item = data;
            cell.questionItem = self.data;
            analysisCell = cell;
            
        } else if (data.type == YXAnalysisNote) {
            QANoteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QANoteCell"];
            cell.item = data;
            [cell updateWithText:self.data.noteText images:self.data.noteImages];
            WEAK_SELF
            [cell setEditAction:^{
                STRONG_SELF
                SAFE_CALL_OneParam(self.editNoteDelegate, editNoteButtonTapped, self.data);
            }];
            analysisCell = cell;
        }else {
            return [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        }
        analysisCell.isShowLine = analysisDataIndex!=self.analysisDataArray.count-1;
        if (indexPath.row == self.cellHeightArray.count-1) {
            self.tableView.tableFooterView.backgroundColor = analysisCell.contentView.backgroundColor;
        }
        return analysisCell;
    }
    else {
        return [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
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
                [self.cellHeightArray addObject:@([QAAnalysisSubjectiveResultCell height])];
            } else {
                item.type = YXAnalysisScore;
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
            if (self.data.templateType == YXQATemplateOral) {
                [self.cellHeightArray addObject:@([QAAnalysisOralResultCell height])];
            } else {
                [self.cellHeightArray addObject:@([QAAnalysisResultCell heightForString:self.data.answerCompare])];
            }
        }
    }
    if (!isEmpty(self.data.difficulty)) {
        if ([self.analysisDataDelegate shouldShowAnalysisDataWithQAItemType:self.data.templateType analysisType:YXAnalysisDifficulty]) {
            YXQAAnalysisItem *item = [[YXQAAnalysisItem alloc]init];
            item.type = YXAnalysisDifficulty;
            [self.analysisDataArray addObject:item];
            [self.cellHeightArray addObject:@([QAAnalysisDifficultyCell height])];
        }
    }
    if ([self isShowAnswer:self.data]) {
        if ([self.analysisDataDelegate shouldShowAnalysisDataWithQAItemType:self.data.templateType analysisType:YXAnalysisAnswer]) {
            YXQAAnalysisItem *item = [[YXQAAnalysisItem alloc]init];
            item.type = YXAnalysisAnswer;
            [self.analysisDataArray addObject:item];
            [self.cellHeightArray addObject:@([QAAnalysisAnswerCell heightForString:[self.data answerPresentation]])];
        }
    }
    if (!isEmpty(self.data.analysis)) {
        if ([self.analysisDataDelegate shouldShowAnalysisDataWithQAItemType:self.data.templateType analysisType:YXAnalysisAnalysis]) {
            YXQAAnalysisItem *item = [[YXQAAnalysisItem alloc]init];
            item.type = YXAnalysisAnalysis;
            [self.analysisDataArray addObject:item];
            [self.cellHeightArray addObject:@([QAAnalysisAnalysisCell heightForString:self.data.analysis])];
            
        }
    }
    if (!isEmpty(self.data.knowledgePoints)) {
        if ([self.analysisDataDelegate shouldShowAnalysisDataWithQAItemType:self.data.templateType analysisType:YXAnalysisKnowledgePoint]) {
            YXQAAnalysisItem *item = [[YXQAAnalysisItem alloc]init];
            item.type = YXAnalysisKnowledgePoint;
            [self.analysisDataArray addObject:item];
            QAAnalysisKnowledgePointCell *cell = [[QAAnalysisKnowledgePointCell alloc]init];
            [self.cellHeightArray addObject:@([cell heightWithKnowledgePointArray:self.data.knowledgePoints])];
        }
    }
    if ([self.analysisDataDelegate shouldShowAnalysisDataWithQAItemType:self.data.templateType analysisType:YXAnalysisNote]) {
        YXQAAnalysisItem *item2 = [[YXQAAnalysisItem alloc]init];
        item2.type = YXAnalysisNote;
        [self.analysisDataArray addObject:item2];
        [self.cellHeightArray addObject:@([QANoteCell heightForText:self.data.noteText images:self.data.noteImages])];
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

@end
