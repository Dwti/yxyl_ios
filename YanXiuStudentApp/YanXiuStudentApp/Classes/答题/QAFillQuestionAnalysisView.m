//
//  QAFillQuestionAnalysisView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2016/10/24.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAFillQuestionAnalysisView.h"
#import "YXQAQuestionCell2.h"
#import "QAFillQuestionCell.h"
#import "QAFillBlankCell.h"
#import "QAComplexHeaderFactory.h"

@interface QAFillQuestionAnalysisView ()
@property (nonatomic, strong) UITableViewCell<QAComplexHeaderCellDelegate> *headerCell;
@property (nonatomic, strong) QAQuestion *oriData;
@end

@implementation QAFillQuestionAnalysisView

- (void)setData:(QAQuestion *)data {
    if (data.childQuestions.count == 1) {
        self.oriData = data;
        [super setData:data.childQuestions.firstObject];
        self.headerCell = [QAComplexHeaderFactory headerCellClassForQuestion:self.oriData];
    }else {
        [super setData:data];
    }
}

- (void)setupUI {
    [super setupUI];
    [self.tableView registerClass:[QAFillBlankCell class] forCellReuseIdentifier:@"QAFillBlankCell"];
}

- (NSMutableArray *)heightArrayForCell {
    NSMutableArray *heightArray = [NSMutableArray array];
    [heightArray addObject:@([self.headerCell heightForQuestion:self.oriData])];
    [heightArray addObject:@([QAFillBlankCell heightForString:self.data.stem])];
    return heightArray;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell<QAComplexHeaderCellDelegate> *cell = [tableView dequeueReusableCellWithIdentifier:kHeaderCellReuseID];
        if (!cell) {
            cell = [QAComplexHeaderFactory headerCellClassForQuestion:self.oriData];
            cell.cellHeightDelegate = self;
        }
        return cell;
    }else if (indexPath.row == 1) {
        QAFillBlankCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAFillBlankCell"];
        cell.delegate = self;
        cell.isAnalysis = YES;
        cell.question = self.data;
        cell.userInteractionEnabled = NO;
        return cell;
    }else {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

@end
