//
//  QAMultiChooseQuestionView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2016/10/20.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAMultiChooseQuestionView.h"
@implementation QAMultiChooseQuestionView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= 2) {
        YXQAAnswerState fromState = [self.data answerState];
        
        NSInteger answerIndex = indexPath.row - 2;
        self.data.myAnswers[answerIndex] = @(![self.data.myAnswers[answerIndex] boolValue]);
        [self.tableView reloadData];
        
        YXQAAnswerState toState = [self.data answerState];
        if (fromState != toState && [self.answerStateChangeDelegate respondsToSelector:@selector(question:didChangeAnswerStateFrom:to:)]) {
            [self.answerStateChangeDelegate question:self.data didChangeAnswerStateFrom:fromState to:toState];
        }
    }
}
@end
