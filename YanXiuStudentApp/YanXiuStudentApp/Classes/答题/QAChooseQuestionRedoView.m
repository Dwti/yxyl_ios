 //
//  QAChooseQuestionRedoView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/1/17.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAChooseQuestionRedoView.h"
#import "QAQuestionStemCell.h"
#import "QAChooseOptionCell.h"

@implementation QAChooseQuestionRedoView
- (void)setupUI {
    [super setupUI];
    [self.tableView registerClass:[QAQuestionStemCell class] forCellReuseIdentifier:@"QAQuestionStemCell"];
    [self.tableView registerClass:[QAChooseOptionCell class] forCellReuseIdentifier:@"QAChooseOptionCell"];
}
- (NSMutableArray *)heightArrayForCell {
    NSMutableArray *heightArray = [NSMutableArray array];
    UITableViewCell<QAComplexHeaderCellDelegate> *headerCell = [QAComplexHeaderFactory headerCellClassForQuestion:self.oriData];
    [heightArray addObject:@([headerCell heightForQuestion:self.oriData])];
    [heightArray addObject:@([QAQuestionStemCell heightForString:self.data.stem isSubQuestion:self.isSubQuestionView])];
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
    
    if (indexPath.row - 1 <= self.data.options.count) {
        NSInteger answerIndex = indexPath.row - 2;
        QAChooseOptionCell *cell = [[QAChooseOptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.delegate = self;
        cell.isLast = indexPath.row==self.data.options.count+1;
        cell.isMulti = self.data.templateType == YXQATemplateMultiChoose;
        cell.choosed = NO;
        if ([self.data.myAnswers[answerIndex] boolValue]) {
            cell.choosed = YES;
        }
        [cell updateWithOption:self.data.options[answerIndex] forIndex:answerIndex];
        
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

@end
