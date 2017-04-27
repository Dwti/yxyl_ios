//
//  YXQAMultiChooseView_Pad.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/27.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQAMultiChooseView_Pad.h"

@implementation YXQAMultiChooseView_Pad

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row >= 1) {
        NSInteger answerIndex = indexPath.row - 1;
        _myAnswerArray[answerIndex] = @(![_myAnswerArray[answerIndex] boolValue]);
        self.data.myAnswers = [NSMutableArray arrayWithArray:_myAnswerArray];
        [self.tableView reloadData];
    }
}

@end
