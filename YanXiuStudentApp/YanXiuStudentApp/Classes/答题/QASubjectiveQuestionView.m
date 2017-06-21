//
//  QASubjectiveQuestionView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2016/10/20.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QASubjectiveQuestionView.h"
#import "YXAddPhotoTableViewCell.h"
#import "QAQuestionUtil.h"
#import "QASubjectiveQuestionCell.h"
#import "QASubjectiveStemCell.h"
#import "QASubjectivePhotoCell.h"
#import "QAComplexHeaderFactory.h"

@interface QASubjectiveQuestionView ()
@property (nonatomic, strong) UITableViewCell<QAComplexHeaderCellDelegate> *headerCell;
@property (nonatomic, strong) QAQuestion *oriData;
@end
@implementation QASubjectiveQuestionView

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
    [self.tableView registerClass:[QASubjectiveStemCell class] forCellReuseIdentifier:@"QASubjectiveStemCell"];
    [self.tableView registerClass:[QASubjectivePhotoCell class] forCellReuseIdentifier:@"QASubjectivePhotoCell"];
}
- (NSMutableArray *)heightArrayForCell {
    NSMutableArray *heightArray = [NSMutableArray array];
    [heightArray addObject:@([self.headerCell heightForQuestion:self.oriData])];
    [heightArray addObject:@([QASubjectiveStemCell heightForString:self.data.stem isSubQuestion:self.isSubQuestionView])];
    [heightArray addObject:@(100)];
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
        QASubjectiveStemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QASubjectiveStemCell"];
        cell.delegate = self;
        [cell updateWithString:self.data.stem isSubQuestion:self.isSubQuestionView];
        return cell;
    }else {
        QASubjectivePhotoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"QASubjectivePhotoCell"];
        WEAK_SELF
        [cell setNumberChangedBlock:^(NSInteger from,NSInteger to){
            STRONG_SELF
            [self.data saveAnswer];
            YXQAAnswerState fromState = from==0? YXAnswerStateNotAnswer:YXAnswerStateAnswered;
            YXQAAnswerState toState = to==0? YXAnswerStateNotAnswer:YXAnswerStateAnswered;
            if (fromState != toState && [self.answerStateChangeDelegate respondsToSelector:@selector(question:didChangeAnswerStateFrom:to:)]) {
                [self.answerStateChangeDelegate question:self.data didChangeAnswerStateFrom:fromState to:toState];
            }
        }];
        [cell updateWithPhotos:self.data.myAnswers editable:YES];
        return cell;
    }
}

@end
