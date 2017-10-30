//
//  QAOralAnswerQuestion.m
//  YanXiuStudentApp-iPhone
//
//  Created by LiuWenXing on 2017/10/17.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAOralAnswerQuestion.h"

@implementation QAOralAnswerQuestion

- (NSArray *)correctAnswersWithRawData:(YXQuestion *)rawData {
    self.oralResultItem = [[QAOralResultItem alloc] initWithString:rawData.pad.jsonAnswer.firstObject error:nil];
    return [NSArray arrayWithArray:rawData.answer];
}

- (void)setOralResultItem:(QAOralResultItem *)oralResultItem {
    _oralResultItem = oralResultItem;
    self.objectiveScore = [NSString stringWithFormat:@"%d", (int)[oralResultItem oralResultGrade]];
}

#pragma mark - 答题状态
- (YXQAAnswerState)answerState {
    if (isEmpty(self.oralResultItem)) {
        return YXAnswerStateNotAnswer;
    }
    if (self.oralResultItem.oralResultGrade == QAOralResultGradeA || self.oralResultItem.oralResultGrade == QAOralResultGradeB) {
        return YXAnswerStateCorrect;
    } else {
        return YXAnswerStateWrong;
    }
}

#pragma mark - 答题报告
- (NSArray *)answerForReport {
    return isEmpty([self.oralResultItem toJSONString]) ? nil : @[[self.oralResultItem toJSONString]];
}

#pragma mark - 答案本地保存
- (void)saveAnswer {
    if (![self questionKey]) {
        return;
    }
    YXQAAnswerState state = [self answerState];
    if (state == YXAnswerStateNotAnswer) {
        [self clearAnswer];
        return;
    }
    WEAK_SELF
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        STRONG_SELF
        NSData *data = [NSJSONSerialization dataWithJSONObject:[self answerForReport] options:0 error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        QuestionAnswerEntity *entity = [QuestionAnswerEntity MR_findFirstByAttribute:@"questionKey" withValue:[self questionKey] inContext:localContext];
        if (!entity) {
            entity = [QuestionAnswerEntity MR_createEntityInContext:localContext];
            entity.questionKey = [self questionKey];
        }
        entity.questionAnswer = str;
    }];
}

- (void)loadAnswer {
    if (![self questionKey]) {
        return;
    }
    QuestionAnswerEntity *entity = [QuestionAnswerEntity MR_findFirstByAttribute:@"questionKey" withValue:[self questionKey]];
    if (entity) {
        NSData *data = [entity.questionAnswer dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        self.oralResultItem = [[QAOralResultItem alloc] initWithString:arr.firstObject error:nil];
    }
}

- (void)clearAnswer {
    if (![self questionKey]) {
        return;
    }
    WEAK_SELF
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        STRONG_SELF
        QuestionAnswerEntity *entity = [QuestionAnswerEntity MR_findFirstByAttribute:@"questionKey" withValue:[self questionKey] inContext:localContext];
        if (entity) {
            [entity MR_deleteEntityInContext:localContext];
        }
    }];
}

@end
