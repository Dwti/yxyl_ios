//
//  MistakeClassifyQuestionView.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/11/30.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QASingleQuestionAnswerBaseView.h"

typedef  void(^MistakeClassifyQuestionAnswerStateChangeBlock) (NSUInteger answerState);

@interface MistakeClassifyQuestionView : QASingleQuestionAnswerBaseView<
UITableViewDelegate,
UITableViewDataSource,
YXHtmlCellHeightDelegate
>

@property (nonatomic, assign) BOOL isAnalysis;

- (void)setMistakeClassifyQuestionAnswerStateChangeBlock:(MistakeClassifyQuestionAnswerStateChangeBlock)block;
@end
