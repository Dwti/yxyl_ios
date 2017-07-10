//
//  QANumberGroupAnswerQuestion.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/9/12.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QANumberGroupAnswerQuestion.h"

@implementation QANumberGroupAnswer
@end

@implementation QANumberGroupAnswerQuestion
#pragma mark - get correct answer
- (NSArray *)correctAnswersWithRawData:(YXQuestion *)rawData{
    [self adjustQuestionCorrectAnswerOrderIfNeeded:rawData];
    NSMutableArray *correctAnswerArray = [NSMutableArray array];
    [rawData.answer enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *answerDic = (NSDictionary *)obj;
        NSString *answerString = [answerDic valueForKey:@"answer"];
        NSString *name = [answerDic valueForKey:@"name"];
        
        QANumberGroupAnswer *groupAnswer = [[QANumberGroupAnswer alloc]init];
        groupAnswer.name = name;
        groupAnswer.answers = [self groupAnswerArrayWithElementCount:rawData.content.choices.count answerString:answerString];
        [correctAnswerArray addObject:groupAnswer];
    }];
    return [NSArray arrayWithArray:correctAnswerArray];
}

- (void)adjustQuestionCorrectAnswerOrderIfNeeded:(YXQuestion *)rawData {
    if (self.templateType == YXQATemplateConnect) {
        NSArray *array = [rawData.answer sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *  _Nonnull obj1, NSDictionary *  _Nonnull obj2) {
            NSString *answer1 = [obj1 valueForKey:@"answer"];
            NSString *answer2 = [obj2 valueForKey:@"answer"];
            return [answer1 compare:answer2];
        }];
        rawData.answer = array;
    }
}

- (NSMutableArray *)groupAnswerArrayWithElementCount:(NSInteger)count answerString:(NSString *)answerString{
    NSMutableArray *groupAnswerArray = [self initializedAnswerArrayWithElementCount:count];
    [self setupGroupAnswerArray:groupAnswerArray withAnswerString:answerString];
    return groupAnswerArray;
}

- (NSMutableArray *)initializedAnswerArrayWithElementCount:(NSInteger)count{
    NSMutableArray *answers = [NSMutableArray array];
    for (int i=0; i<count; i++) {
        [answers addObject:@NO];
    }
    return answers;
}

- (void)setupGroupAnswerArray:(NSMutableArray *)groupAnswerArray withAnswerString:(NSString *)answerString{
    NSArray *rawAnswerArray = [self rawAnswerArrayWithAnswerString:answerString];
    [rawAnswerArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *indexString = (NSString *)obj;
        NSInteger index = indexString.integerValue;
        [self addAnsweredIndex:index toAnswerArray:groupAnswerArray];
    }];
}

- (NSArray *)rawAnswerArrayWithAnswerString:(NSString *)answerString{
    if (answerString.length == 0) {
        return nil;
    }
    return [answerString componentsSeparatedByString:@","];
}

- (void)addAnsweredIndex:(NSInteger)index toAnswerArray:(NSMutableArray *)answerArray{
    answerArray[index] = @YES;
}

#pragma mark - get my answer
- (NSMutableArray *)myAnswersWithRawData:(YXQuestion *)rawData{
    NSMutableArray *myAnswerArray = [self initializedMyAnswerArrayWithRawData:rawData];
    [rawData.pad.jsonAnswer enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QANumberGroupAnswer *groupAnswer = myAnswerArray[idx];
        [self setupGroupAnswerArray:groupAnswer.answers withAnswerString:obj];
    }];
    return myAnswerArray;
}

- (NSMutableArray *)initializedMyAnswerArrayWithRawData:(YXQuestion *)rawData{
    NSMutableArray *myAnswerArray = [NSMutableArray array];
    [rawData.answer enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dic = (NSDictionary *)obj;
        QANumberGroupAnswer *groupAnswer = [[QANumberGroupAnswer alloc]init];
        groupAnswer.name = [dic valueForKey:@"name"];
        groupAnswer.answers = [self initializedAnswerArrayWithElementCount:rawData.content.choices.count];
        [myAnswerArray addObject:groupAnswer];
    }];
    return myAnswerArray;
}

#pragma mark - 答题状态
- (YXQAAnswerState)answerState{
    __block BOOL answered = FALSE;
    __block BOOL correct = TRUE;
    __block NSInteger answeredCount = 0;
    for (int i = 0; i < self.myAnswers.count; i++) {
        QANumberGroupAnswer *myAnswer = self.myAnswers[i];
        QANumberGroupAnswer *correctAnswer = self.correctAnswers[i];
        [myAnswer.answers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSNumber *answer = (NSNumber *)obj;
            NSNumber *correctAns = correctAnswer.answers[idx];
            if (answer.boolValue) {
                answered = TRUE;
                answeredCount++;
            }
            if (answer.boolValue != correctAns.boolValue) {
                correct = FALSE;
            }
        }];
    }
    BOOL allAnswered = (answeredCount == self.options.count);
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

#pragma mark - 答案描述
- (NSString *)answerPresentation {
    if (self.templateType == YXQATemplateConnect) {
        NSMutableArray *answerStringArray = [NSMutableArray array];
        for (QANumberGroupAnswer *groupAnswer in self.correctAnswers) {
            NSMutableArray *array = [NSMutableArray array];
            [groupAnswer.answers enumerateObjectsUsingBlock:^(NSNumber *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.boolValue) {
                    [array addObject:@(idx%(groupAnswer.answers.count/2)+1)];
                }
            }];
            [answerStringArray addObject:[NSString stringWithFormat:@"左%@连右%@",array.firstObject,array.lastObject]];
        }
        return [answerStringArray componentsJoinedByString:@","];
    }else if (self.templateType == YXQATemplateClassify) {
        NSMutableArray *answerStringArray = [NSMutableArray array];
        for (QANumberGroupAnswer *groupAnswer in self.correctAnswers) {
            NSMutableArray *array = [NSMutableArray array];
            [groupAnswer.answers enumerateObjectsUsingBlock:^(NSNumber *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.boolValue) {
                    [array addObject:self.options[idx]];
                }
            }];
            NSString *optionString = [array componentsJoinedByString:@","];
            [answerStringArray addObject:[NSString stringWithFormat:@"%@:%@",groupAnswer.name,optionString]];
        }
        return [answerStringArray componentsJoinedByString:@";"];
    }else {
        return [super answerPresentation];
    }
}

#pragma mark - 答题报告
- (NSArray *)answerForReport{
    NSMutableArray *answerArray = [NSMutableArray array];
    [self.myAnswers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QANumberGroupAnswer *answer = (QANumberGroupAnswer *)obj;
        [answerArray addObject:[self answerStringForGroupAnswer:answer]];
    }];
    return [NSArray arrayWithArray:answerArray];
}

- (NSString *)answerStringForGroupAnswer:(QANumberGroupAnswer *)groupAnswer{
    NSMutableArray *answeredIndexArray = [self answeredIndexArrayWithGroupAnswer:groupAnswer];
    NSString *answerString = @"";
    if (answeredIndexArray.count > 0) {
        answerString = [answeredIndexArray componentsJoinedByString:@","];
    }
    return answerString;
}

- (NSMutableArray *)answeredIndexArrayWithGroupAnswer:(QANumberGroupAnswer *)groupAnswer{
    NSMutableArray *answeredIndexArray = [NSMutableArray array];
    [groupAnswer.answers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSNumber *num = (NSNumber *)obj;
        if (num.boolValue) {
            [answeredIndexArray addObject:[NSString stringWithFormat:@"%@",@(idx)]];
        }
    }];
    return answeredIndexArray;
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
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            QANumberGroupAnswer *groupAnswer = self.myAnswers[idx];
            [self setupGroupAnswerArray:groupAnswer.answers withAnswerString:obj];
        }];
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
