//
//  QAOralQuestionViewContainer.m
//  YanXiuStudentApp-iPhone
//
//  Created by LiuWenXing on 2017/10/17.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAOralQuestionViewContainer.h"

@implementation QAOralQuestionViewContainer

- (QAQuestionBaseView *)questionAnswerView{
    return [[QAListenComplexView alloc]init];
}

- (QAQuestionBaseView *)questionAnalysisView{
    return [[QAAnalysisListenComplexView alloc]init];
}

@end
