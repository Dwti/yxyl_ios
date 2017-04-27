//
//  QAUnknownQuestionViewContainer.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/2/13.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAUnknownQuestionViewContainer.h"
#import "QAUnknownQuestionView.h"

@implementation QAUnknownQuestionViewContainer
- (QAQuestionBaseView *)questionAnswerView{
    return [[QAUnknownQuestionView alloc]init];
}

- (QAQuestionBaseView *)questionAnalysisView{
    return [[QAUnknownQuestionView alloc]init];
}

- (QAQuestionBaseView *)questionRedoView {
    return [[QAUnknownQuestionView alloc]init];
}
@end
