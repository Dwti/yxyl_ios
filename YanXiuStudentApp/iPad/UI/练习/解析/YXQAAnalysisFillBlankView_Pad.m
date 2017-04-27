//
//  YXQAAnalysisFillBlankView_Pad.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/28.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQAAnalysisFillBlankView_Pad.h"
#import "YXQAAnalysisLabelHtmlCell_Pad.h"
#import "YXQAAnalysisAnalysisCell_Pad.h"
#import "YXQAAnalysisDifficultyCell_Pad.h"
#import "YXQAAnalysisReportErrorCell_Pad.h"
#import "YXQAAnalysisKnpCell_Pad.h"
#import "YXQAAnalysisUnfoldDelegate.h"
#import "YXQAAnalysisUnfoldView_Pad.h"

@interface YXQAAnalysisFillBlankView_Pad()<YXKnowledgePointViewDelegate,YXQAAnalysisReportErrorViewDelegate,YXQAAnalysisUnfoldDelegate>
@property (nonatomic, assign) NSInteger superRowCount;
@property (nonatomic, strong) NSMutableArray *analysisDataArray;

@end

@implementation YXQAAnalysisFillBlankView_Pad

- (void)_setupUI {
    [super _setupUI];
    self.superRowCount = [_heightArray count];
    
    [self.tableView registerClass:[YXQAAnalysisDifficultyCell_Pad class] forCellReuseIdentifier:@"YXQAAnalysisDifficultyCell_Pad"];
    [self.tableView registerClass:[YXQAAnalysisKnpCell_Pad class] forCellReuseIdentifier:@"YXQAAnalysisKnpCell_Pad"];
    [self.tableView registerClass:[YXQAAnalysisReportErrorCell_Pad class] forCellReuseIdentifier:@"YXQAAnalysisReportErrorCell_Pad"];
    [self.tableView registerClass:[YXQAAnalysisLabelHtmlCell_Pad class] forCellReuseIdentifier:@"YXQAAnalysisLabelHtmlCell_Pad"];
    [self.tableView registerClass:[YXQAAnalysisAnalysisCell_Pad class] forCellReuseIdentifier:@"YXQAAnalysisAnalysisCell_Pad"];
    [self.tableView registerClass:[YXQAAnalysisUnfoldView_Pad class] forHeaderFooterViewReuseIdentifier:@"YXQAAnalysisUnfoldView_Pad"];
    
    if (!self.analysisDataHidden) {
        [self setupAnalysisContent];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger myRowIndex = indexPath.row - _superRowCount;
    if (myRowIndex < 0) {
        UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        if (indexPath.row == 0) {
            for (UITextField *t in _textFieldArray) {
                t.userInteractionEnabled = FALSE;
            }
        }
        return cell;
    }
    
    if (myRowIndex<self.analysisDataArray.count) {
        YXQAAnalysisItem *data = self.analysisDataArray[myRowIndex];
        if (data.type == YXAnalysisCurrentStatus) {
            YXQAAnalysisLabelHtmlCell_Pad *cell = [tableView dequeueReusableCellWithIdentifier:@"YXQAAnalysisLabelHtmlCell_Pad"];
            cell.delegate = self;
            cell.item = data;
            cell.htmlString = self.data.answerCompare;
            return cell;
        }else if (data.type == YXAnalysisStatistic){
            YXQAAnalysisLabelHtmlCell_Pad *cell = [tableView dequeueReusableCellWithIdentifier:@"YXQAAnalysisLabelHtmlCell_Pad"];
            cell.delegate = self;
            cell.item = data;
            cell.htmlString = self.data.globalStatis;
            return cell;
        }else if (data.type == YXAnalysisDifficulty){
            YXQAAnalysisDifficultyCell_Pad *cell = [tableView dequeueReusableCellWithIdentifier:@"YXQAAnalysisDifficultyCell_Pad"];
            cell.item = data;
            cell.difficulty = self.data.difficulty;
            return cell;
        }else if (data.type == YXAnalysisAnalysis){
            YXQAAnalysisAnalysisCell_Pad *cell = [tableView dequeueReusableCellWithIdentifier:@"YXQAAnalysisAnalysisCell_Pad"];
            cell.delegate = self;
            cell.item = data;
            cell.htmlString = self.data.analysis;
            return cell;
        }else if (data.type == YXAnalysisKnowledgePoint){
            YXQAAnalysisKnpCell_Pad *cell = [tableView dequeueReusableCellWithIdentifier:@"YXQAAnalysisKnpCell_Pad"];
            cell.delegate = self;
            cell.item = data;
            cell.knpClickable = self.canDoExerciseFromKnp;
            cell.knpArray = self.data.knowledgePoints;
            return cell;
        }else{
            return [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        }
    }else{
        YXQAAnalysisReportErrorCell_Pad *cell = [tableView dequeueReusableCellWithIdentifier:@"YXQAAnalysisReportErrorCell_Pad"];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (!self.analysisDataHidden) {
        return nil;
    }else{
        YXQAAnalysisUnfoldView_Pad *v = [[YXQAAnalysisUnfoldView_Pad alloc]initWithReuseIdentifier:@"YXQAAnalysisUnfoldView_Pad"];
        v.delegate = self;
        return v;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (!self.analysisDataHidden) {
        return 0;
    }else{
        return [YXQAAnalysisUnfoldView_Pad height];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark - 解析的展开与收起
- (void)setAnalysisDataHidden:(BOOL)analysisDataHidden{
    _analysisDataHidden = analysisDataHidden;
    if (!analysisDataHidden) {
        [self setupAnalysisContent];
        [self.tableView reloadData];
    }else{
        NSInteger total = _heightArray.count;
        for (int i= 0; i<total-_superRowCount; i++) {
            [_heightArray removeLastObject];
        }
        [self.tableView reloadData];
    }
}
#pragma mark - YXQAAnalysisUnfoldDelegate
- (void)showAnalysisData{
    self.analysisDataHidden = FALSE;
}
#pragma mark -
- (void)setupAnalysisContent{
    NSAssert([self.analysisDataDelegate respondsToSelector:@selector(shouldShowAnalysisDataWithQAItemType:analysisType:)], @"未设置解析数据委托");
    
    self.analysisDataArray = [NSMutableArray array];
    if (!isEmpty(self.data.answerCompare)) {
        if ([self.analysisDataDelegate shouldShowAnalysisDataWithQAItemType:YXQATemplateFill analysisType:YXAnalysisCurrentStatus]) {
            YXQAAnalysisItem *item = [[YXQAAnalysisItem alloc]init];
            item.type = YXAnalysisCurrentStatus;
            [self.analysisDataArray addObject:item];
            [_heightArray addObject:@([YXQAAnalysisLabelHtmlCell_Pad heightForString:self.data.answerCompare])];
        }
    }
    if (!isEmpty(self.data.globalStatis)) {
        if ([self.analysisDataDelegate shouldShowAnalysisDataWithQAItemType:YXQATemplateFill analysisType:YXAnalysisStatistic]) {
            YXQAAnalysisItem *item = [[YXQAAnalysisItem alloc]init];
            item.type = YXAnalysisStatistic;
            [self.analysisDataArray addObject:item];
            [_heightArray addObject:@([YXQAAnalysisLabelHtmlCell_Pad heightForString:self.data.globalStatis])];
        }
    }
    if (!isEmpty(self.data.difficulty)) {
        if ([self.analysisDataDelegate shouldShowAnalysisDataWithQAItemType:YXQATemplateFill analysisType:YXAnalysisDifficulty]) {
            YXQAAnalysisItem *item = [[YXQAAnalysisItem alloc]init];
            item.type = YXAnalysisDifficulty;
            [self.analysisDataArray addObject:item];
            [_heightArray addObject:@([YXQAAnalysisDifficultyCell_Pad height])];
        }
    }
    if (!isEmpty(self.data.analysis)) {
        if ([self.analysisDataDelegate shouldShowAnalysisDataWithQAItemType:YXQATemplateFill analysisType:YXAnalysisAnalysis]) {
            YXQAAnalysisItem *item = [[YXQAAnalysisItem alloc]init];
            item.type = YXAnalysisAnalysis;
            [self.analysisDataArray addObject:item];
            [_heightArray addObject:@([YXQAAnalysisAnalysisCell_Pad heightForString:self.data.analysis])];
        }
    }
    // 如果是从练习进来的，知识点上有可以再做一遍的功能
    if (!isEmpty(self.data.knowledgePoints)) {
        if ([self.analysisDataDelegate shouldShowAnalysisDataWithQAItemType:YXQATemplateFill analysisType:YXAnalysisKnowledgePoint]) {
            YXQAAnalysisItem *item = [[YXQAAnalysisItem alloc]init];
            item.type = YXAnalysisKnowledgePoint;
            [self.analysisDataArray addObject:item];
            [_heightArray addObject:@([YXQAAnalysisKnpCell_Pad heightForPoints:self.data.knowledgePoints])];
        }
    }
    
    if (self.reportErrorDelegate && ([self.reportErrorDelegate canReportError])) {
        //报错
        [_heightArray addObject:@([YXQAAnalysisReportErrorCell_Pad height])];
    }
}

#pragma mark - YXKnowledgePointViewDelegate
- (void)knowledgePointView:(YXKnowledgePointView *)pointView didSelectIndex:(NSInteger)index{
    QAKnowledgePoint *p = self.data.knowledgePoints[index];
    if (self.pointClickDelegate && [self.pointClickDelegate respondsToSelector:@selector(knpClickedWithID:)]) {
        [self.pointClickDelegate knpClickedWithID:p.knpID];
    }
}

#pragma mark - YXQAAnalysisReportErrorViewDelegate
- (void)reportErrorViewClicked
{
    NSString * qid = self.data.questionID;
    if (self.reportErrorDelegate && [self.reportErrorDelegate respondsToSelector:@selector(reportAnalysisErrorWithID:)]) {
        [self.reportErrorDelegate reportAnalysisErrorWithID:qid];
    }
}

@end
