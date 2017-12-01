//
//  QASingleQuestionRedoBaseView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/1/17.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QASingleQuestionRedoBaseView.h"
#import "YXQAAnalysisItem.h"
#import "GlobalUtils.h"
#import "QANoteCell.h"
#import "QAAnalysisResultCell.h"
#import "QAAnalysisDifficultyCell.h"
#import "QAAnalysisAnalysisCell.h"
#import "QAAnaysisGapCell.h"
#import "QAAnalysisScoreCell.h"
#import "QAAnalysisSubjectiveResultCell.h"

@interface QASingleQuestionRedoBaseView()
@property (nonatomic, strong) RACDisposable *dispose;
@property (nonatomic, strong) RACDisposable *contentSizeDispose;

@property (nonatomic, strong) NSMutableArray *analysisDataArray;
@property (nonatomic, assign) NSUInteger analysisCellCount;

@end

@implementation QASingleQuestionRedoBaseView

- (void)dealloc {
    [self.dispose dispose];
    [self.contentSizeDispose dispose];
}

- (void)setupUI {
    [super setupUI];
    [self setupObserver];
    NSInteger oriCount = self.cellHeightArray.count;
    [self setupSingleQuestionAnalysisContent];
    self.analysisCellCount = self.cellHeightArray.count - oriCount - 1;
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footerView;
    [self.tableView registerClass:[QANoteCell class] forCellReuseIdentifier:@"QANoteCell"];
    [self.tableView registerClass:[QAAnalysisResultCell class] forCellReuseIdentifier:@"QAAnalysisResultCell"];
    [self.tableView registerClass:[QAAnalysisDifficultyCell class] forCellReuseIdentifier:@"QAAnalysisDifficultyCell"];
    [self.tableView registerClass:[QAAnalysisAnalysisCell class] forCellReuseIdentifier:@"QAAnalysisAnalysisCell"];
    [self.tableView registerClass:[QAAnaysisGapCell class] forCellReuseIdentifier:@"QAAnaysisGapCell"];
        [self.tableView registerClass:[QAAnalysisSubjectiveResultCell class] forCellReuseIdentifier:@"QAAnalysisSubjectiveResultCell"];
        [self.tableView registerClass:[QAAnalysisScoreCell class] forCellReuseIdentifier:@"QAAnalysisScoreCell"];
    [self setupAnalysisBGViewUI];
    if (self.data.redoStatus == QARedoStatus_CanDelete || self.data.redoStatus == QARedoStatus_AlreadyDelete) {
        self.analysisBGView.hidden = NO;
        self.tableView.tableFooterView.backgroundColor = [UIColor colorWithHexString:@"81d40d"];
    }else {
        self.analysisBGView.hidden = YES;
        self.tableView.tableFooterView.backgroundColor = [UIColor clearColor];
    }
}

- (void)setupObserver {
    WEAK_SELF
    self.dispose = [RACObserve(self.data, redoStatus) subscribeNext:^(id x) {
        STRONG_SELF
        [self refreshForRedoStatusChange];
    }];
    
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

- (void)refreshForRedoStatusChange {
    if (self.data.redoStatus == QARedoStatus_CanDelete) {
        [self.tableView reloadData];
        [self updateBGViewImage];
        self.analysisBGView.hidden = NO;
        DDLogDebug(@"self.analysisBGView.frame.origin.y = %@",@(self.analysisBGView.frame.origin.y));
        self.tableView.tableFooterView.backgroundColor = [UIColor colorWithHexString:@"81d40d"];
    }
}

- (void)setupSingleQuestionAnalysisContent {
    NSAssert([self.analysisDataDelegate respondsToSelector:@selector(shouldShowAnalysisDataWithQAItemType:analysisType:)], @"未设置解析数据委托");
    [self.cellHeightArray addObject:@([QAAnaysisGapCell height])];
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
    
//    YXQAAnalysisItem *item = [[YXQAAnalysisItem alloc]init];
//    item.type = YXAnalysisCurrentStatus;
//    [self.analysisDataArray addObject:item];
//    [self.cellHeightArray addObject:@([QAAnalysisResultCell heightForString:[self.data answerStateDescription]])];

    if (self.isPaperSubmitted) {//提交了就显示对错
        if ([self.analysisDataDelegate shouldShowAnalysisDataWithQAItemType:self.data.templateType analysisType:YXAnalysisCurrentStatus]) {
            YXQAAnalysisItem *item = [[YXQAAnalysisItem alloc]init];
            item.type = YXAnalysisCurrentStatus;
            [self.analysisDataArray addObject:item];
//            if (self.data.templateType == YXQATemplateOral) {
//                [self.cellHeightArray addObject:@([QAAnalysisOralResultCell height])];
//            } else {
                [self.cellHeightArray addObject:@([QAAnalysisResultCell heightForString:self.data.answerCompare])];
//            }
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
    
    if (!isEmpty(self.data.analysis)) {
        if ([self.analysisDataDelegate shouldShowAnalysisDataWithQAItemType:self.data.templateType analysisType:YXAnalysisAnalysis]) {
            YXQAAnalysisItem *item = [[YXQAAnalysisItem alloc]init];
            item.type = YXAnalysisAnalysis;
            [self.analysisDataArray addObject:item];
            [self.cellHeightArray addObject:@([QAAnalysisAnalysisCell heightForString:self.data.analysis])];
        }
    }
    
    YXQAAnalysisItem *item2 = [[YXQAAnalysisItem alloc]init];
    item2.type = YXAnalysisNote;
    [self.analysisDataArray addObject:item2];
    [self.cellHeightArray addObject:@([QANoteCell heightForText:self.data.noteText images:self.data.noteImages])];
}

- (void)setupAnalysisBGViewUI {
    self.analysisBGView = [[QAAnalysisBackGroundView alloc]init];
    self.analysisBGView.userInteractionEnabled = NO;
    [self.tableView insertSubview:self.analysisBGView atIndex:0];
    self.analysisBGView.layer.zPosition = -1;
    WEAK_SELF
    self.contentSizeDispose = [RACObserve(self.tableView, contentSize) subscribeNext:^(id x) {
        STRONG_SELF
        [self setupAnalysisBGViewLayout];
    }];
    [self updateBGViewImage];
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

- (void)updateBGViewImage {
#warning //待后续再看 此处的判定
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
#pragma mark - tableView datasource delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.data.redoStatus==QARedoStatus_Init || self.data.redoStatus==QARedoStatus_CanSubmit) {
        return  self.cellHeightArray.count - self.analysisCellCount;
    }
    return self.cellHeightArray.count;
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
    YXQAAnalysisItem *data = self.analysisDataArray[analysisDataIndex];
    
    if (data.type == YXAnalysisDifficulty) {
        QAAnalysisDifficultyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAAnalysisDifficultyCell" forIndexPath:indexPath];
        cell.item = data;
        cell.difficulty = self.data.difficulty;
        return cell;
    }else if (data.type == YXAnalysisAnalysis) {
        QAAnalysisAnalysisCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAAnalysisAnalysisCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.item = data;
        cell.htmlString = self.data.analysis;
        return cell;
    }else if (data.type == YXAnalysisCurrentStatus) {
        QAAnalysisResultCell *cell = [[QAAnalysisResultCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.delegate = self;
        cell.item = data;
        cell.htmlString = [self.data answerStateDescription];
        return cell;
    } else if (data.type == YXAnalysisNote) {
        QANoteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QANoteCell"];
        cell.item = data;
        [cell updateWithText:self.data.noteText images:self.data.noteImages];
        WEAK_SELF
        [cell setEditAction:^{
            STRONG_SELF
            SAFE_CALL_OneParam(self.editNoteDelegate, editNoteButtonTapped, self.data);
        }];
        return cell;
    } else if (data.type == YXAnalysisScore) {
        QAAnalysisScoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAAnalysisScoreCell" forIndexPath:indexPath];
        cell.item = data;
        cell.score = self.data.score;
        cell.isMarked = self.data.isMarked;
        [cell updateUI];
        return cell;
    } else if (data.type == YXAnalysisResult) {
        QAAnalysisSubjectiveResultCell *cell = [[QAAnalysisSubjectiveResultCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.item = data;
        cell.isCorrect = self.data.score == 5 ? YES : NO;
        cell.isMarked = self.data.isMarked;
        [cell updateUI];
        return cell;
    } else {
        return [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
}

@end
