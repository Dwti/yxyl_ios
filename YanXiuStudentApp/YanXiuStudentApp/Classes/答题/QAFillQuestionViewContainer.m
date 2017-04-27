//
//  QAFillQuestionViewContainer.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/11.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAFillQuestionViewContainer.h"
#import "QAFillQuestionView.h"
#import "QAFillQuestionAnalysisView.h"
#import "QAFillQuestionRedoView.h"

@implementation QAFillQuestionViewContainer

- (QAQuestionBaseView *)questionAnswerView{
    return [[QAFillQuestionView alloc]init];;
}

- (QAQuestionBaseView *)questionAnalysisView{
    return [[QAFillQuestionAnalysisView alloc]init];
}

- (QAQuestionBaseView *)questionRedoView {
    return [[QAFillQuestionRedoView alloc] init];
}

@end
