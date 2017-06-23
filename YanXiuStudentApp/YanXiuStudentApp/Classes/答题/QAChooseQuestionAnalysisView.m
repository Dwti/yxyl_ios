//
//  QAChooseQuestionAnalysisView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2016/10/20.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAChooseQuestionAnalysisView.h"
#import "QAQuestionStemCell.h"
#import "QAChooseOptionCell.h"
#import "QAComplexHeaderFactory.h"

@interface QAChooseQuestionAnalysisView ()
@property (nonatomic, strong) UITableViewCell<QAComplexHeaderCellDelegate> *headerCell;
@property (nonatomic, strong) QAQuestion *oriData;
@end
@implementation QAChooseQuestionAnalysisView

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
    [self.tableView registerClass:[QAChooseOptionCell class] forCellReuseIdentifier:@"QAChooseOptionCell"];
}
- (NSMutableArray *)heightArrayForCell {
    NSMutableArray *heightArray = [NSMutableArray array];
    [heightArray addObject:@([self.headerCell heightForQuestion:self.oriData])];
    if (self.hideQuestion) {
        [heightArray addObject:@(0.0001)];
    }else {
        [heightArray addObject:@([QAQuestionStemCell heightForString:self.data.stem isSubQuestion:self.isSubQuestionView])];
    }
    for (int i = 0; i < self.data.options.count; i++) {
        [heightArray addObject:@([QAChooseOptionCell heightForString:self.data.options[i]])];
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
    }else if(indexPath.row <= self.data.options.count+1) {
        NSInteger answerIndex = indexPath.row - 2;
        QAChooseOptionCell *cell = [[QAChooseOptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.delegate = self;
        cell.isAnalysis = YES;
        cell.isLast = indexPath.row==self.data.options.count+1;
        cell.isMulti = self.data.templateType == YXQATemplateMultiChoose;
        cell.choosed = NO;
        cell.markType = OptionMarkType_None;
        if (!self.analysisDataHidden) {
            if ([self.data.myAnswers[answerIndex] boolValue]) {
                cell.choosed = YES;
                cell.markType = OptionMarkType_Wrong;
            }
            if ([self.data.correctAnswers[answerIndex] boolValue]) {
                cell.markType = OptionMarkType_Correct;
            }
        }
        [cell updateWithOption:self.data.options[answerIndex] forIndex:answerIndex];
        return cell;
    }else{
        UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell;
    }
}

@end
