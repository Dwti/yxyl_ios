//
//  QAComplexAnswerQuestion.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/9/12.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAComplexAnswerQuestion.h"

@implementation QAComplexAnswerQuestion

- (instancetype)initWithRawData:(YXIntelligenceQuestion_PaperTest *)rawData{
    if (self == [super initWithRawData:rawData]) {
        if (self.questionType == YXQAItemSolve || self.questionType == YXQAItemCalculate) {
            [self.childQuestions enumerateObjectsUsingBlock:^(QAQuestion *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.stem = [QAQuestionUtil stemByAddingIndexNumber:idx+1 inFrontOfStem:obj.stem];
            }];
        }
    }
    return self;
}

- (NSArray *)correctAnswersWithRawData:(YXQuestion *)rawData{
    return nil;
}

- (NSMutableArray *)myAnswersWithRawData:(YXQuestion *)rawData{
    return nil;
}

#pragma mark - 答题状态
- (YXQAAnswerState)answerState{
    BOOL allCorrect = YES;
    for (QAQuestion *q in self.childQuestions) {
        YXQAAnswerState state = [q answerState];
        if (state == YXAnswerStateWrong) {
            allCorrect = NO;
        }else if (state != YXAnswerStateCorrect) {
            return YXAnswerStateUnKnown;
        }
    }
    if (allCorrect) {
        return YXAnswerStateCorrect;
    }
    return YXAnswerStateWrong;
}

#pragma mark - 答题报告
- (NSArray *)answerForReport{
    return nil;
}

@end
