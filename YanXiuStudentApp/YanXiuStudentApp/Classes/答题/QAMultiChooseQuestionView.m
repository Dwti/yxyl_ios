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
    if (indexPath.row >= 1) {
        NSInteger answerIndex = indexPath.row - 1;
        self.data.myAnswers[answerIndex] = @(![self.data.myAnswers[answerIndex] boolValue]);
        [self.tableView reloadData];
    }
}
@end
