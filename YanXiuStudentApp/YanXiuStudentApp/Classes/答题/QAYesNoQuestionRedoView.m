//
//  QAYesNoQuestionRedoView.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 1/17/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "QAYesNoQuestionRedoView.h"
#import "QAYesNoOptionCell.h"
#import "QAQuestionStemCell.h"

@interface QAYesNoQuestionRedoView ()
@end

@implementation QAYesNoQuestionRedoView

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
    [heightArray addObject:@([QAQuestionStemCell heightForString:self.data.stem isSubQuestion:self.isSubQuestionView])];
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
        QAQuestionStemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAQuestionStemCell"];
        cell.delegate = self;
        [cell updateWithString:self.data.stem isSubQuestion:self.isSubQuestionView];
        return cell;
    }
    if (indexPath.row - 1 <= 2) {
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
        if (answerIndex == 0) {
            answerIndex = 1;
        }else {
            answerIndex = 0;
        }
        if ([self.data.myAnswers[answerIndex] boolValue]) {
            cell.choosed = YES;
        }
        
        QARedoStatus status = self.data.redoStatus;
        if (status==QARedoStatus_CanDelete || status==QARedoStatus_AlreadyDelete) {
            cell.markType = OptionMarkType_None;
            if ([self.data.myAnswers[answerIndex] boolValue]) {
                cell.markType = OptionMarkType_Wrong;
            }
            if ([self.data.correctAnswers[answerIndex] boolValue]) {
                cell.markType = OptionMarkType_Correct;
            }
            cell.userInteractionEnabled = NO;
        }
        return cell;
    }else{
        UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell;
    }
}

- (void)updateRedoStatus {
    if ([self.data answerState] == YXAnswerStateNotAnswer) {
        self.data.redoStatus = QARedoStatus_Init;
    } else {
        self.data.redoStatus = QARedoStatus_CanSubmit;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= 2 && indexPath.row < 4) {
        NSInteger answerIndex = indexPath.row - 2;
        if (answerIndex == 0) {
            answerIndex = 1;
        }else {
            answerIndex = 0;
        }
        BOOL choose = [self.data.myAnswers[answerIndex] boolValue];
        for (int i = 0; i < [self.data.myAnswers count]; i++) {
            self.data.myAnswers[i] = @(NO);
        }
        self.data.myAnswers[answerIndex] = @(!choose);
        [self.tableView reloadData];
        [self.data saveAnswer];
        
        if ([self.data answerState] == YXAnswerStateNotAnswer) {
            self.data.redoStatus = QARedoStatus_Init;
        }else {
            self.data.redoStatus = QARedoStatus_CanSubmit;
        }
    }
}
@end
