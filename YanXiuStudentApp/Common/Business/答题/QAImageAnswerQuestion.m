//
//  QAImageAnswerQuestion.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/9/12.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAImageAnswerQuestion.h"

@implementation QAImageAnswer

@end

@implementation QAImageAnswerQuestion
- (NSArray *)correctAnswersWithRawData:(YXQuestion *)rawData{
    return rawData.answer;
}

- (NSMutableArray *)myAnswersWithRawData:(YXQuestion *)rawData{
    NSMutableArray *myAnswerArray = [NSMutableArray array];
    for (NSString *url in rawData.pad.jsonAnswer) {
        QAImageAnswer *answer = [self imageAnswerWithUrl:url];
        [myAnswerArray addObject:answer];
    }
    return myAnswerArray;
}

- (QAImageAnswer *)imageAnswerWithUrl:(NSString *)url{
    QAImageAnswer *answer = [[QAImageAnswer alloc]init];
    answer.url = url;
    return answer;
}

#pragma mark - 答题状态
- (YXQAAnswerState)answerState{
    if (self.isMarked) {
        NSInteger score = self.score;
        if (score == 0) {
            return YXAnswerStateWrong;
        }else if (score == kFullMarkScore){
            return YXAnswerStateCorrect;
        }else{
            return YXAnswerStateHalfCorrect;
        }
    }else{
        if ([self.myAnswers count] > 0) {
            return YXAnswerStateAnswered;
        }else{
            return YXAnswerStateNotAnswer;
        }
    }
}

#pragma mark - 答题报告
- (NSArray *)answerForReport{
    NSMutableArray *answerArray = [NSMutableArray array];
    [self.myAnswers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QAImageAnswer *answer = (QAImageAnswer *)obj;
        if (!isEmpty(answer.url)) {
            [answerArray addObject:answer.url];
        }
    }];
    return [NSArray arrayWithArray:answerArray];
}

@end
