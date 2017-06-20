//
//  QASubjectiveQuestionView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2016/10/20.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QASubjectiveQuestionView.h"
#import "YXQAQuestionCell2.h"
#import "YXAddPhotoTableViewCell.h"
#import "QAQuestionUtil.h"
#import "QASubjectiveQuestionCell.h"
#import "QAQuestionStemCell.h"
#import "QASubjectivePhotoCell.h"
@interface QASubjectiveQuestionView ()
@end
@implementation QASubjectiveQuestionView

- (void)setupUI {
    [super setupUI];
    [self.tableView registerClass:[QAQuestionStemCell class] forCellReuseIdentifier:@"QAQuestionStemCell"];
    [self.tableView registerClass:[QASubjectivePhotoCell class] forCellReuseIdentifier:@"QASubjectivePhotoCell"];
}
- (NSMutableArray *)heightArrayForCell {
    NSMutableArray *heightArray = [NSMutableArray array];
    [heightArray addObject:@([QAQuestionStemCell heightForString:self.data.stem isSubQuestion:self.isSubQuestionView])];
    [heightArray addObject:@(100)];
    return heightArray;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        QAQuestionStemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAQuestionStemCell"];
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
