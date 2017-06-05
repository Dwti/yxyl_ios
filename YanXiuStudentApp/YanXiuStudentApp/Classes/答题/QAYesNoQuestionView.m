//
//  QAYesNoQuestionView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2016/10/20.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAYesNoQuestionView.h"
#import "QAYesNoOptionCell.h"
#import "QAQuestionStemCell.h"

@implementation QAYesNoQuestionView

- (void)setupUI {
    [super setupUI];
    self.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    [self.tableView registerClass:[QAYesNoOptionCell class] forCellReuseIdentifier:@"QAYesNoOptionCell"];
    [self.tableView registerClass:[QAQuestionStemCell class] forCellReuseIdentifier:@"QAQuestionStemCell"];
}

- (NSMutableArray *)heightArrayForCell {
    NSMutableArray *heightArray = [NSMutableArray array];
     [heightArray addObject:@([QAQuestionStemCell heightForString:self.data.stem isSubQuestion:self.isSubQuestionView])];
    for (int i = 0; i < [self.data.myAnswers count]; i++) {
        [heightArray addObject:@(55)];
    }
    return heightArray;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        QAQuestionStemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAQuestionStemCell"];
        cell.delegate = self;
        [cell updateWithString:self.data.stem isSubQuestion:self.isSubQuestionView];
        return cell;
    }

    QAYesNoOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAYesNoOptionCell"];
    cell.choosed = NO;
    if (indexPath.row == 1) {
        cell.title = @"正确";
        cell.isLast = NO;
    }else {
        cell.title = @"错误";
        cell.isLast = YES;
    }
    NSInteger answerIndex = indexPath.row - 1;
    if ([self.data.myAnswers[answerIndex] boolValue]) {
        cell.choosed = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= 1) {
        YXQAAnswerState fromState = [self.data answerState];
        
        NSInteger answerIndex = indexPath.row - 1;
        BOOL choose = [self.data.myAnswers[answerIndex] boolValue];
        for (int i = 0; i < [self.data.myAnswers count]; i++) {
            self.data.myAnswers[i] = @(NO);
        }
        self.data.myAnswers[answerIndex] = @(!choose);
        [self.tableView reloadData];
        
        YXQAAnswerState toState = [self.data answerState];
        if (fromState != toState && [self.answerStateChangeDelegate respondsToSelector:@selector(question:didChangeAnswerStateFrom:to:)]) {
            [self.answerStateChangeDelegate question:self.data didChangeAnswerStateFrom:fromState to:toState];
        }
    }
}

@end
