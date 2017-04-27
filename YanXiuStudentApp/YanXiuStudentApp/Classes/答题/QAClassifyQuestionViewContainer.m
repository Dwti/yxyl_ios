//
//  QAClassifyQuestionViewContainer.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/11.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAClassifyQuestionViewContainer.h"
#import "QAClassifyRedoView.h"

@implementation QAClassifyQuestionViewContainer

- (QAQuestionBaseView *)questionAnswerView{
    return [[QAClassifyQuestionView alloc]init];
}

- (QAQuestionBaseView *)questionAnalysisView{
    return [[QAClassifyQuestionAnalysisView alloc]init];
}

- (QAQuestionBaseView *)questionRedoView {
    return [[QAClassifyRedoView alloc] init];
}

@end
