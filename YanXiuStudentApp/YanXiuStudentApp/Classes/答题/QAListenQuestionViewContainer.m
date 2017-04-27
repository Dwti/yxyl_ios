//
//  QAListenQuestionViewContainer.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/11.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAListenQuestionViewContainer.h"
#import "QARedoListenComplexView.h"

@implementation QAListenQuestionViewContainer

- (QAQuestionBaseView *)questionAnswerView{
    return [[QAListenComplexView alloc]init];
}

- (QAQuestionBaseView *)questionAnalysisView{
    return [[QAAnalysisListenComplexView alloc]init];
}

- (QAQuestionBaseView *)questionRedoView {
    return [[QARedoListenComplexView alloc]init];
}

@end
