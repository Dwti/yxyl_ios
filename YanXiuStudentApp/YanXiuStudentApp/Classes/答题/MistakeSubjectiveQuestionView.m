//
//  MistakeSubjectiveQuestionView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/11/30.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "MistakeSubjectiveQuestionView.h"
#import "QAQuestionUtil.h"
#import "QASubjectiveStemCell.h"
#import "MiatakeSubjectiveTipCell.h"

@interface MistakeSubjectiveQuestionView ()

@end
@implementation MistakeSubjectiveQuestionView

- (void)setupUI {
    [super setupUI];
    [self.tableView registerClass:[QASubjectiveStemCell class] forCellReuseIdentifier:@"QASubjectiveStemCell"];
    [self.tableView registerClass:[MiatakeSubjectiveTipCell class] forCellReuseIdentifier:@"MiatakeSubjectiveTipCell"];
}

- (NSMutableArray *)heightArrayForCell {
    NSMutableArray *heightArray = [NSMutableArray array];
    UITableViewCell<QAComplexHeaderCellDelegate> *headerCell = [QAComplexHeaderFactory headerCellClassForQuestion:self.oriData];
    [heightArray addObject:@([headerCell heightForQuestion:self.oriData])];
    if (self.hideQuestion) {
        [heightArray addObject:@(0.0001)];
    }else {
        [heightArray addObject:@([QASubjectiveStemCell heightForString:self.data.stem isSubQuestion:self.isSubQuestionView])];
    }
    [heightArray addObject:@(100)];
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
        QASubjectiveStemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QASubjectiveStemCell"];
        cell.delegate = self;
        [cell updateWithString:self.data.stem isSubQuestion:self.isSubQuestionView];
        return cell;
    }else {
        MiatakeSubjectiveTipCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MiatakeSubjectiveTipCell"];
        return cell;
    }
}

@end
