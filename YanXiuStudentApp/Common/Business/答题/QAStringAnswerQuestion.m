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

@end
