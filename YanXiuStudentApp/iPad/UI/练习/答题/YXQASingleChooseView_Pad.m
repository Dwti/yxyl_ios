//
//  YXQASingleChooseView_Pad.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/27.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQASingleChooseView_Pad.h"

@implementation YXQASingleChooseView_Pad

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row >= 1) {
        NSInteger answerIndex = indexPath.row - 1;
        BOOL choose = [_myAnswerArray[answerIndex] boolValue];
        for (int i = 0; i < [_myAnswerArray count]; i++) {
            _myAnswerArray[i] = @(NO);
        }
        _myAnswerArray[answerIndex] = @(!choose);
        self.data.myAnswers = [NSMutableArray arrayWithArray:_myAnswerArray];
        [self.tableView reloadData];
        
        if (!choose) {
            [self.delegate autoGoNextGoGoGo];
        }
    }
}

@end
