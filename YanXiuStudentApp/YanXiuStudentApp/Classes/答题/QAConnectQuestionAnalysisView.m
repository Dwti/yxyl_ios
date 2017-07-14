//
//  QAConnectQuestionAnalysisView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2016/10/24.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAConnectQuestionAnalysisView.h"
#import "QAQuestionStemCell.h"
#import "QAConnectAnalysisContentCell.h"

@interface QAConnectQuestionAnalysisView ()
@property (nonatomic, strong) NSMutableArray *contentGroupArray;
@end
@implementation QAConnectQuestionAnalysisView

- (void)setupUI {
    [super setupUI];
    [self.tableView registerClass:[QAQuestionStemCell class] forCellReuseIdentifier:@"QAQuestionStemCell"];
    [self.tableView registerClass:[QAConnectAnalysisContentCell class] forCellReuseIdentifier:@"QAConnectAnalysisContentCell"];
}

- (NSMutableArray *)heightArrayForCell {
    NSMutableArray *heightArray = [NSMutableArray array];
    UITableViewCell<QAComplexHeaderCellDelegate> *headerCell = [QAComplexHeaderFactory headerCellClassForQuestion:self.oriData];
    [heightArray addObject:@([headerCell heightForQuestion:self.oriData])];
    if (self.hideQuestion) {
        [heightArray addObject:@(0.0001)];
    }else {
        [heightArray addObject:@([QAQuestionStemCell heightForString:self.data.stem isSubQuestion:self.isSubQuestionView])];
    }
    [heightArray addObject:@([QAConnectAnalysisContentCell heightForItem:self.data])];
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
    }else if (indexPath.row == 1) {
        if (self.hideQuestion) {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            return cell;
        }
        QAQuestionStemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAQuestionStemCell"];
        cell.bottomLineHidden = YES;
        cell.delegate = self;
        [cell updateWithString:self.data.stem isSubQuestion:self.isSubQuestionView];
        return cell;
    }else if (indexPath.row == 2) {
        QAConnectAnalysisContentCell *cell = [[QAConnectAnalysisContentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        if (self.contentGroupArray) {
            cell.groupArray = self.contentGroupArray;
        }
        cell.item = self.data;
        self.contentGroupArray = cell.groupArray;
        cell.userInteractionEnabled = NO;
        cell.showAnalysisAnswers = YES;
        WEAK_SELF
        [cell setCellHeightChangeBlock:^(CGFloat height) {
            STRONG_SELF
            CGFloat cellHeight = [QAConnectAnalysisContentCell heightForItem:self.data];
            CGFloat newCellHeight = ceil(height);
            if (cellHeight < newCellHeight) {
                [self.cellHeightArray replaceObjectAtIndex:indexPath.row withObject:@(newCellHeight)];
                [self.tableView beginUpdates];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [self.tableView endUpdates];
            }
        }];
        return cell;

    }else {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

@end
