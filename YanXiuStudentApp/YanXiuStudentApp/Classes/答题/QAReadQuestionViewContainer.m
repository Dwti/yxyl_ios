//
//  QAReadQuestionViewContainer.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/11.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAReadQuestionViewContainer.h"
#import "QARedoReadComplexView.h"

@implementation QAReadQuestionViewContainer

- (QAQuestionBaseView *)questionAnswerView{
    return [[QAReadComplexView alloc]init];
}

- (QAQuestionBaseView *)questionAnalysisView{
    return [[QAAnalysisReadComplexView alloc]init];
}

- (QAQuestionBaseView *)questionRedoView {
    return [[QARedoReadComplexView alloc]init];
}

@end
