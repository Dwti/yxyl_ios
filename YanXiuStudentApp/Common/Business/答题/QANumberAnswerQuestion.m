//
//  QANumberAnswerQuestion.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/9/12.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QANumberAnswerQuestion.h"

@implementation QANumberAnswerQuestion
- (NSArray *)correctAnswersWithRawData:(YXQuestion *)rawData{
    NSMutableArray *correctAnswers = [self initializedAnswerArrayWithElementCount:rawData.content.choices.count];
    for (NSString *answer in rawData.answer) {
        [self addAnsweredIndex:answer.integerValue toAnswerArray:correctAnswers];
    }
    return [NSArray arrayWithArray:correctAnswers];
}

- (NSMutableArray *)initializedAnswerArrayWithElementCount:(NSInteger)count{
    NSMutableArray *answers = [NSMutableArray array];
    for (int i=0; i<count; i++) {
        [answers addObject:@NO];
    }
    return answers;
}

- (void)addAnsweredIndex:(NSInteger)index toAnswerArray:(NSMutableArray *)answerArray{
    answerArray[index] = @YES;
}

- (NSMutableArray *)myAnswersWithRawData:(YXQuestion *)rawData{
    NSMutableArray *myAnswers = [self initializedAnswerArrayWithElementCount:rawData.content.choices.count];
    for (NSString *answer in rawData.pad.jsonAnswer) {
        [self addAnsweredIndex:answer.integerValue toAnswerArray:myAnswers];
    }
    return myAnswers;
}

#pragma mark - 答案描述
- (NSString *)answerPresentation {
    NSMutableArray *array = [NSMutableArray array];
    [self.correctAnswers enumerateObjectsUsingBlock:^(NSNumber *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.boolValue) {
            char c = 'A' + idx;
            NSString *cString = [NSString stringWithFormat:@"%c", c];
            [array addObject:cString];
        }
    }];
    return [array componentsJoinedByString:@","];
}

#pragma mark - 答题状态
- (YXQAAnswerState)answerState{
    BOOL answered = FALSE;
    BOOL correct = TRUE;
    for (int i = 0; i < self.myAnswers.count; i++) {
        NSNumber *myAnswer = self.myAnswers[i];
        NSNumber *correctAnswer = self.correctAnswers[i];
        if (myAnswer.boolValue) {
            answered = TRUE;
        }
        if (myAnswer.boolValue != correctAnswer.boolValue) {
            correct = FALSE;
        }
    }
    if (!answered) {
        return YXAnswerStateNotAnswer;
    }else if (correct){
        return YXAnswerStateCorrect;
    }else{
        return YXAnswerStateWrong;
    }
}

#pragma mark - 答题报告
- (NSArray *)answerForReport{
    NSMutableArray *answerArray = [NSMutableArray array];
    [self.myAnswers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSNumber *number = (NSNumber *)obj;
        if (number.boolValue) {
            [answerArray addObject:[NSString stringWithFormat:@"%@",@(idx)]];
        }
    }];
    return [NSArray arrayWithArray:answerArray];
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
        for (NSString *answer in arr) {
            [self addAnsweredIndex:answer.integerValue toAnswerArray:self.myAnswers];
        }
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
