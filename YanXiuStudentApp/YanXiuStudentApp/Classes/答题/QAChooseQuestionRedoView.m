//
//  QAChooseQuestionRedoView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/1/17.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAChooseQuestionRedoView.h"

@implementation QAChooseQuestionRedoView
- (void)setupUI {
    [super setupUI];
//    [self.tableView registerClass:[YXQAQuestionCell2 class] forCellReuseIdentifier:@"YXQAQuestionCell2"];
//    [self.tableView registerClass:[YXQAChooseAnswerCell2 class] forCellReuseIdentifier:@"YXQAChooseAnswerCell2"];
}
- (NSMutableArray *)heightArrayForCell {
    NSMutableArray *heightArray = [NSMutableArray array];
//    [heightArray addObject:@([YXQAQuestionCell2 heightForString:self.data.stem dashHidden:NO])];
//    for (int i = 0; i < self.data.options.count; i++) {
//        [heightArray addObject:@([YXQAChooseAnswerCell2 heightForString:self.data.options[i]])];
//    }
    return heightArray;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
//        YXQAQuestionCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"YXQAQuestionCell2"];
//        cell.delegate = self;
//        cell.item = self.data;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return cell;
        return nil;
    }else if(indexPath.row <= self.data.options.count){
//        NSInteger answerIndex = indexPath.row - 1;
//        YXQAChooseAnswerCell2 *cell = [[YXQAChooseAnswerCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//        cell.delegate = self;
//        cell.bChoosed = NO;
//        if ([self.data.myAnswers[answerIndex] boolValue]) {
//            cell.bChoosed = YES;
//        }
//        [cell updateWithItem:self.data forIndex:answerIndex];
//        
//        QARedoStatus status = self.data.redoStatus;
//        if (status==QARedoStatus_CanDelete || status==QARedoStatus_AlreadyDelete) {
//            cell.markType = EMarkNone;
//            if ([self.data.myAnswers[answerIndex] boolValue]) {
//                cell.markType = EMarkWrong;
//            }
//            if ([self.data.correctAnswers[answerIndex] boolValue]) {
//                cell.markType = EMarkCorrect;
//            }
//            cell.userInteractionEnabled = NO;
//        }
//        return cell;
        return nil;
    }else{
        UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell;
    }
}

@end
