//
//  QAOralQuestionViewContainer.m
//  YanXiuStudentApp-iPhone
//
//  Created by LiuWenXing on 2017/10/17.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAOralQuestionViewContainer.h"
#import "QAOralQuestionView.h"
#import "QAOralQuestionAnalysisView.h"

@implementation QAOralQuestionViewContainer

- (QAQuestionBaseView *)questionAnswerView{
    return [[QAOralQuestionView alloc]init];
}

- (QAQuestionBaseView *)questionAnalysisView{
    return [[QAOralQuestionAnalysisView alloc]init];
}

@end
