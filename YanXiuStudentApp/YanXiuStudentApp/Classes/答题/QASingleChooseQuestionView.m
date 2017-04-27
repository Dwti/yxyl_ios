//
//  QASingleChooseQuestionView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2016/10/20.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QASingleChooseQuestionView.h"
@implementation QASingleChooseQuestionView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= 1) {
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
    }
}
@end
