//
//  MistakeConnectQuestionView.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/11/30.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QASingleQuestionAnswerBaseView.h"

typedef  void(^MistakeConnectQuestionAnswerStateChangeBlock) (NSUInteger answerState);

@interface MistakeConnectQuestionView : QASingleQuestionAnswerBaseView

- (void)setMistakeConnectQuestionAnswerStateChangeBlock:(MistakeConnectQuestionAnswerStateChangeBlock)block;
@end
