//
//  QAClozeQuestionViewContainer.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/11.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAClozeQuestionViewContainer.h"
#import "QARedoClozeComplexView.h"

@implementation QAClozeQuestionViewContainer

- (QAQuestionBaseView *)questionAnswerView{
    return [[QAClozeComplexView alloc]init];
}

- (QAQuestionBaseView *)questionAnalysisView{
    return [[QAAnalysisClozeComplexView alloc]init];
}

- (QAQuestionBaseView *)questionRedoView{
    return [[QARedoClozeComplexView alloc]init];
}

@end
