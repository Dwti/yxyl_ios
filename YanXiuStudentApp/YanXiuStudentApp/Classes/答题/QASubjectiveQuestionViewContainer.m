//
//  QASubjectiveQuestionViewContainer.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/11.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QASubjectiveQuestionViewContainer.h"
#import "QASubjectiveQuestionView.h"
#import "QASubjectiveQuestionAnalysisView.h"
#import "QAUnknownQuestionView.h"

@implementation QASubjectiveQuestionViewContainer

- (QAQuestionBaseView *)questionAnswerView{
    return [[QASubjectiveQuestionView alloc]init];
}
- (QAQuestionBaseView *)questionAnalysisView{
    return [[QASubjectiveQuestionAnalysisView alloc]init];
}

- (QAQuestionBaseView *)questionRedoView {
    return [[QAUnknownQuestionView alloc] init];
}
@end
