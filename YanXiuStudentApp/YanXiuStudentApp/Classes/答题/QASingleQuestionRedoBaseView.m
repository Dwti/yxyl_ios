//
//  QASingleQuestionRedoBaseView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/1/17.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QASingleQuestionRedoBaseView.h"
#import "QARedoSubmitView.h"
#import "YXQAAnalysisItem.h"
#import "GlobalUtils.h"
#import "QANoteCell.h"

@interface QASingleQuestionRedoBaseView()
@property (nonatomic, strong) QARedoSubmitView *submitView;
@property (nonatomic, strong) RACDisposable *dispose;
@property (nonatomic, strong) NSMutableArray *analysisDataArray;
@end

@implementation QASingleQuestionRedoBaseView

- (void)dealloc {
    [self.dispose dispose];
}

- (void)setupUI {
    [super setupUI];
    [self setupObserver];    
    [self setupSingleQuestionAnalysisContent];
    [self.tableView registerClass:[QANoteCell class] forCellReuseIdentifier:@"QANoteCell"];

    if (self.isSubQuestionView) {
        return;
    }
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_bottom);
        make.left.right.equalTo(self);
    }];
    self.submitView = [[QARedoSubmitView alloc]initWithQuestion:self.data];
    [self addSubview:self.submitView];
    [self.submitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(42);
        make.right.mas_equalTo(-33);
        make.top.mas_equalTo(self.tableView.mas_bottom).mas_offset(15);
        make.height.mas_equalTo(52);
        make.bottom.mas_equalTo(-15);
    }];    
}

- (void)setupObserver {
    WEAK_SELF
    self.dispose = [RACObserve(self.data, redoStatus) subscribeNext:^(id x) {
        STRONG_SELF
        NSNumber *num = x;
        QARedoStatus status = num.integerValue;
        if (status == QARedoStatus_CanDelete) {
            [self.tableView reloadData];
        }
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

- (void)setupSingleQuestionAnalysisContent {
    NSAssert([self.analysisDataDelegate respondsToSelector:@selector(shouldShowAnalysisDataWithQAItemType:analysisType:)], @"未设置解析数据委托");
    self.analysisDataArray = [NSMutableArray array];
    
    YXQAAnalysisItem *item = [[YXQAAnalysisItem alloc]init];
    item.type = YXAnalysisCurrentStatus;
    [self.analysisDataArray addObject:item];
//    [self.cellHeightArray addObject:@([YXLabelHtmlCell2 heightForString:[self.data answerStateDescription]])];
//    
//    if (!isEmpty(self.data.difficulty)) {
//        if ([self.analysisDataDelegate shouldShowAnalysisDataWithQAItemType:self.data.templateType analysisType:YXAnalysisDifficulty]) {
//            YXQAAnalysisItem *item = [[YXQAAnalysisItem alloc]init];
//            item.type = YXAnalysisDifficulty;
//            [self.analysisDataArray addObject:item];
//            [self.cellHeightArray addObject:@([YXDifficultyCell height])];
//        }
//    }
//    
//    if (!isEmpty(self.data.analysis)) {
//        if ([self.analysisDataDelegate shouldShowAnalysisDataWithQAItemType:self.data.templateType analysisType:YXAnalysisAnalysis]) {
//            YXQAAnalysisItem *item = [[YXQAAnalysisItem alloc]init];
//            item.type = YXAnalysisAnalysis;
//            [self.analysisDataArray addObject:item];
//            [self.cellHeightArray addObject:@([YXAnalysisCell heightForString:self.data.analysis])];
//        }
//    }
    
    YXQAAnalysisItem *item2 = [[YXQAAnalysisItem alloc]init];
    item2.type = YXAnalysisNote;
    [self.analysisDataArray addObject:item2];
    [self.cellHeightArray addObject:@([QANoteCell heightForText:self.data.noteText images:self.data.noteImages])];
}

#pragma mark - tableView datasource delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.data.redoStatus==QARedoStatus_Init || self.data.redoStatus==QARedoStatus_CanSubmit) {
        return  self.cellHeightArray.count - self.analysisDataArray.count;
    }
    return self.cellHeightArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger analysisStartRowIndex = self.cellHeightArray.count - self.analysisDataArray.count;
    if (indexPath.row < analysisStartRowIndex) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    NSInteger analysisDataIndex = indexPath.row - analysisStartRowIndex;
    YXQAAnalysisItem *data = self.analysisDataArray[analysisDataIndex];
    
    if (data.type == YXAnalysisDifficulty) {
//        YXDifficultyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXDifficultyCell" forIndexPath:indexPath];
//        cell.item = data;
//        cell.difficulty = self.data.difficulty;
//        return cell;
        return [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }else if (data.type == YXAnalysisAnalysis) {
//        YXAnalysisCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXAnalysisCell" forIndexPath:indexPath];
//        cell.delegate = self;
//        cell.item = data;
//        cell.htmlString = self.data.analysis;
//        return cell;
        return [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }else if (data.type == YXAnalysisCurrentStatus) {
//        YXLabelHtmlCell2 *cell = [[YXLabelHtmlCell2 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//        cell.delegate = self;
//        cell.item = data;
//        cell.htmlString = [self.data answerStateDescription];
//        return cell;
        return [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
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
    } else {
        return [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
}

@end
