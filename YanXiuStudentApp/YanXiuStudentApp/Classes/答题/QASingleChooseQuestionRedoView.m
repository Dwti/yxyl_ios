//
//  QASingleChooseQuestionRedoView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/1/17.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QASingleChooseQuestionRedoView.h"

@implementation QASingleChooseQuestionRedoView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= 1 && indexPath.row < 5) {
        NSInteger answerIndex = indexPath.row - 1;
        BOOL choose = [self.data.myAnswers[answerIndex] boolValue];
        for (int i = 0; i < [self.data.myAnswers count]; i++) {
            self.data.myAnswers[i] = @(NO);
        }
        self.data.myAnswers[answerIndex] = @(!choose);
        [self.tableView reloadData];
        if (!choose) {
            [self.delegate autoGoNextGoGoGo];
        }else {
            if ([self.delegate respondsToSelector:@selector(cancelAnswer)]) {
                [self.delegate cancelAnswer];
            }
        }
        if ([self.data answerState] == YXAnswerStateNotAnswer) {
            self.data.redoStatus = QARedoStatus_Init;
        }else {
            self.data.redoStatus = QARedoStatus_CanSubmit;
        }
    }
}

@end
