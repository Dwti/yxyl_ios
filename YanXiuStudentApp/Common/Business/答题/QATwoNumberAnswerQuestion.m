//
//  QATwoNumberAnswerQuestion.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/9/12.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QATwoNumberAnswerQuestion.h"

@implementation QATwoNumberAnswerQuestion
- (NSArray *)correctAnswersWithRawData:(YXQuestion *)rawData{
    NSMutableArray *correctAnswers = [self initializedAnswerArray];
    if (rawData.answer.count > 0) {
        NSString *answer = rawData.answer[0];
        [self setAnsweredIndex:answer.integerValue toAnswerArray:correctAnswers];
    }
    return [NSArray arrayWithArray:correctAnswers];
}

- (NSMutableArray *)initializedAnswerArray{
    NSMutableArray *answers = [NSMutableArray arrayWithObjects:@NO, @NO, nil];
    return answers;
}

- (void)setAnsweredIndex:(NSInteger)index toAnswerArray:(NSMutableArray *)answerArray{
    if (index == 0) {
        answerArray[0] = @YES;
    }else{
        answerArray[1] = @YES;
    }
}

- (NSMutableArray *)myAnswersWithRawData:(YXQuestion *)rawData{
    NSMutableArray *myAnswers = [self initializedAnswerArray];
    if (rawData.pad.jsonAnswer.count > 0) {
        NSString *answer = rawData.pad.jsonAnswer[0];
        [self setAnsweredIndex:answer.integerValue toAnswerArray:myAnswers];
    }
    return myAnswers;
}

#pragma mark - 答案描述
- (NSString *)answerPresentation {
    __block NSString *presentation = nil;
    [self.correctAnswers enumerateObjectsUsingBlock:^(NSNumber *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.boolValue) {
            if (idx == 0) {
                presentation = @"错误";
            }else {
                presentation = @"正确";
            }
            *stop = YES;
        }
    }];
    return presentation;
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
            *stop = YES;
        }
    }];
    return [NSArray arrayWithArray:answerArray];
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
        if (arr.count > 0) {
            NSString *answer = arr[0];
            [self setAnsweredIndex:answer.integerValue toAnswerArray:self.myAnswers];
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
