//
//  QAStringAnswerQuestion.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/9/12.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAStringAnswerQuestion.h"

@implementation QAStringAnswerQuestion
- (NSArray *)correctAnswersWithRawData:(YXQuestion *)rawData{
    return [NSArray arrayWithArray:rawData.answer];
}

- (NSMutableArray *)myAnswersWithRawData:(YXQuestion *)rawData{
    if (isEmpty(rawData.pad.jsonAnswer)) {
        return [self initializedAnswerArrayWithElementCount:rawData.answer.count];
    }else{
        return [NSMutableArray arrayWithArray:rawData.pad.jsonAnswer];
    }
}

- (NSMutableArray *)initializedAnswerArrayWithElementCount:(NSInteger)count{
    NSMutableArray *answers = [NSMutableArray array];
    for (int i=0; i<count; i++) {
        [answers addObject:@""];
    }
    return answers;
}

#pragma mark - 答题状态
- (YXQAAnswerState)answerState{
    BOOL answered = FALSE;
    BOOL allAnswered = TRUE;
    BOOL correct = TRUE;
    for (NSString *myAnswer in self.myAnswers) {
        NSInteger index = [self.myAnswers indexOfObject:myAnswer];
        NSString *correctAnswer = self.correctAnswers[index];
        if ([myAnswer isEqualToString:@""]) {
            allAnswered = FALSE;
        }else{
            answered = TRUE;
        }
        if (![myAnswer isEqualToString:correctAnswer]) {
            correct = FALSE;
        }
    }
    if (!answered) {
        return YXAnswerStateNotAnswer;
    }else if (!allAnswered){
        return YXAnswerStatePartAnswer;
    }else if (correct){
        return YXAnswerStateCorrect;
    }else{
        return YXAnswerStateWrong;
    }
}

#pragma mark - 答题报告
- (NSArray *)answerForReport{
    return [NSArray arrayWithArray:self.myAnswers];
}

#pragma mark - 答案本地保存
- (void)saveAnswer {
    if (![self questionKey]) {
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
        [self.myAnswers removeAllObjects];
        [self.myAnswers addObjectsFromArray:arr];
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
