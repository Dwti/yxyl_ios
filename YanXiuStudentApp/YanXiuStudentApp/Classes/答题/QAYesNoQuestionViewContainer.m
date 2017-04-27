//
//  QAYesNoQuestionViewContainer.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/11.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAYesNoQuestionViewContainer.h"
#import "QAYesNoQuestionView.h"
#import "QAYesNoQuestionAnalysisView.h"
#import "QAYesNoQuestionRedoView.h"

@implementation QAYesNoQuestionViewContainer

- (QAQuestionBaseView *)questionAnswerView{
    return [[QAYesNoQuestionView alloc]init];
}
- (QAQuestionBaseView *)questionAnalysisView{
    return [[QAYesNoQuestionAnalysisView alloc]init];
}
- (QAQuestionBaseView *)questionRedoView {
    return [[QAYesNoQuestionRedoView alloc] init];
}

@end
