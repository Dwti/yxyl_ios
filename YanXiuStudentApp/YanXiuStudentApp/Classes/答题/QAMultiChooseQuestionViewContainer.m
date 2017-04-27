//
//  QAMultiChooseQuestionViewContainer.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/11.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAMultiChooseQuestionViewContainer.h"
#import "QAMultiChooseQuestionView.h"
#import "QAMultiChooseQuestionAnalysisView.h"
#import "QAMultiChooseQuestionRedoView.h"
@implementation QAMultiChooseQuestionViewContainer

- (QAQuestionBaseView *)questionAnswerView{
    return [[QAMultiChooseQuestionView alloc]init];
}
- (QAQuestionBaseView *)questionAnalysisView{
    return [[QAMultiChooseQuestionAnalysisView alloc]init];
}
- (QAQuestionBaseView *)questionRedoView{
    return [[QAMultiChooseQuestionRedoView alloc]init];
}
@end
