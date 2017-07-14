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
#import "QAComplexHeaderFactory.h"

@interface QAYesNoQuestionView()
@property (nonatomic,strong) UITableViewCell<QAComplexHeaderCellDelegate> *headerCell;

@end

@implementation QAYesNoQuestionView

- (void)leaveForeground {
    [super leaveForeground];
    SAFE_CALL(self.headerCell, leaveForeground);
}

- (void)setupUI {
    [super setupUI];
    self.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    [self.tableView registerClass:[QAYesNoOptionCell class] forCellReuseIdentifier:@"QAYesNoOptionCell"];
    [self.tableView registerClass:[QAQuestionStemCell class] forCellReuseIdentifier:@"QAQuestionStemCell"];
}

- (NSMutableArray *)heightArrayForCell {
    NSMutableArray *heightArray = [NSMutableArray array];
    UITableViewCell<QAComplexHeaderCellDelegate> *headerCell = [QAComplexHeaderFactory headerCellClassForQuestion:self.oriData];
    [heightArray addObject:@([headerCell heightForQuestion:self.oriData])];
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
            self.headerCell = cell;
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
    }
    
    QAYesNoOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAYesNoOptionCell"];
    cell.choosed = NO;
    if (indexPath.row == 2) {
        cell.title = @"正确";
        cell.isLast = NO;
    }else {
        cell.title = @"错误";
        cell.isLast = YES;
    }
    NSInteger answerIndex = indexPath.row - 2;
    if ([self.data.myAnswers[answerIndex] boolValue]) {
        cell.choosed = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= 2) {
        YXQAAnswerState fromState = [self.data answerState];
        
        NSInteger answerIndex = indexPath.row - 2;
        BOOL choose = [self.data.myAnswers[answerIndex] boolValue];
        for (int i = 0; i < [self.data.myAnswers count]; i++) {
            self.data.myAnswers[i] = @(NO);
        }
        self.data.myAnswers[answerIndex] = @(!choose);
        [self.tableView reloadData];
        [self.data saveAnswer];
        
        YXQAAnswerState toState = [self.data answerState];
        if (fromState != toState && [self.answerStateChangeDelegate respondsToSelector:@selector(question:didChangeAnswerStateFrom:to:)]) {
            [self.answerStateChangeDelegate question:self.data didChangeAnswerStateFrom:fromState to:toState];
        }
    }
}

@end
