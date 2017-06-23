//
//  QAYesNoQuestionAnalysisView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2016/10/24.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAYesNoQuestionAnalysisView.h"
#import "YXQAQuestionCell2.h"
#import "YXQAYesNoChooseCell.h"
#import "QAComplexHeaderFactory.h"
#import "QAQuestionStemCell.h"
#import "QAYesNoOptionCell.h"

@interface QAYesNoQuestionAnalysisView ()
@property (nonatomic, strong) UITableViewCell<QAComplexHeaderCellDelegate> *headerCell;
@property (nonatomic, strong) QAQuestion *oriData;
@end

@implementation QAYesNoQuestionAnalysisView

- (void)setData:(QAQuestion *)data {
    if (data.childQuestions.count == 1) {
        self.oriData = data;
        [super setData:data.childQuestions.firstObject];
        self.headerCell = [QAComplexHeaderFactory headerCellClassForQuestion:self.oriData];
    }else {
        [super setData:data];
    }
}

- (void)setupUI {
    [super setupUI];
    [self.tableView registerClass:[QAQuestionStemCell class] forCellReuseIdentifier:@"QAQuestionStemCell"];
    [self.tableView registerClass:[QAYesNoOptionCell class] forCellReuseIdentifier:@"QAYesNoOptionCell"];
}

- (NSMutableArray *)heightArrayForCell {
    NSMutableArray *heightArray = [NSMutableArray array];
    [heightArray addObject:@([self.headerCell heightForQuestion:self.oriData])];
    if (self.hideQuestion) {
        [heightArray addObject:@(0.0001)];
    }else {
        [heightArray addObject:@([QAQuestionStemCell heightForString:self.data.stem isSubQuestion:self.isSubQuestionView])];
    }
    for (int i = 0; i < [self.data.myAnswers count]; i++) {
        [heightArray addObject:@(55)];
    }
    return heightArray;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell<QAComplexHeaderCellDelegate> *cell = [tableView dequeueReusableCellWithIdentifier:kHeaderCellReuseID];
        if (!cell) {
            cell = [QAComplexHeaderFactory headerCellClassForQuestion:self.oriData];
            cell.cellHeightDelegate = self;
        }
        return cell;
    }
    
    if (indexPath.row == 1) {
        if (self.hideQuestion) {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            return cell;
        }
        QAQuestionStemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAQuestionStemCell"];
        cell.delegate = self;
        [cell updateWithString:self.data.stem isSubQuestion:self.isSubQuestionView];
        return cell;
    }else if(indexPath.row <= 3) {
        QAYesNoOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAYesNoOptionCell"];
        cell.choosed = NO;
        if (indexPath.row == 2) {
            cell.title = @"正确";
            cell.isLast = NO;
        }else {
            cell.title = @"错误";
            cell.isLast = YES;
        }
        cell.isAnalysis = YES;
        cell.choosed = NO;
        cell.markType = OptionMarkType_None;
        NSInteger answerIndex = indexPath.row - 2;
        if (!self.analysisDataHidden) {
            if ([self.data.myAnswers[answerIndex] boolValue]) {
                cell.choosed = YES;
                cell.markType = OptionMarkType_Wrong;
            }
            if ([self.data.correctAnswers[answerIndex] boolValue]) {
                cell.markType = OptionMarkType_Correct;
            }
        }
        return cell;
        
    }else{
        UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell;
    }
}
@end
