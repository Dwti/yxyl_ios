//
//  QAConnectQuestionViewContainer.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/11.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAConnectQuestionViewContainer.h"
#import "QAConnectQuestionView.h"
#import "QAConnectQuestionAnalysisView.h"
#import "QAConnectQuestionRedoView.h"

@implementation QAConnectQuestionViewContainer

- (QAQuestionBaseView *)questionAnswerView{
    return [[QAConnectQuestionView alloc]init];
}

- (QAQuestionBaseView *)questionAnalysisView{
    return [[QAConnectQuestionAnalysisView alloc]init];
}

- (QAQuestionBaseView *)questionRedoView {
    return [[QAConnectQuestionRedoView alloc] init];
}

@end
