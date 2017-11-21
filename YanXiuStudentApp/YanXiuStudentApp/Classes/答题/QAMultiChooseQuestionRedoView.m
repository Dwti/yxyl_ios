//
//  QAMultiChooseQuestionRedoView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/1/17.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAMultiChooseQuestionRedoView.h"

@implementation QAMultiChooseQuestionRedoView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= 1 && indexPath.row < 6) {
        NSInteger answerIndex = indexPath.row - 2;
        self.data.myAnswers[answerIndex] = @(![self.data.myAnswers[answerIndex] boolValue]);
        [self.tableView reloadData];
        if ([self.data answerState] == YXAnswerStateNotAnswer) {
            self.data.redoStatus = QARedoStatus_Init;
        }else {
            self.data.redoStatus = QARedoStatus_CanSubmit;
        }
    }
}

@end
