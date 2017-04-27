//
//  QASingleChooseQuestionViewContainer.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/11.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QASingleChooseQuestionViewContainer.h"
#import "QASingleChooseQuestionView.h"
#import "QASingleChooseQuestionAnalysisView.h"
#import "QASingleChooseQuestionRedoView.h"
@implementation QASingleChooseQuestionViewContainer

- (QAQuestionBaseView *)questionAnswerView{
    return [[QASingleChooseQuestionView alloc]init];
}
- (QAQuestionBaseView *)questionAnalysisView{
    return [[QASingleChooseQuestionAnalysisView alloc]init];
}
- (QAQuestionBaseView *)questionRedoView{
    return [[QASingleChooseQuestionRedoView alloc]init];
}
@end
