//
//  QAQuestionFactory.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/9/12.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAQuestionFactory.h"
#import "QAOralAnswerQuestion.h"

@implementation QAQuestionFactory
+ (QAQuestion *)questionFromRawData:(YXIntelligenceQuestion_PaperTest *)rawData{
    QAQuestion *question = nil;
    YXQATemplateType type = [QAQuestionTemplateMappingTable templateTypeForTemplate:rawData.questions.qTemplate];
    if (type == YXQATemplateSingleChoose ||
        type == YXQATemplateMultiChoose) {
        question = [[QANumberAnswerQuestion alloc]initWithRawData:rawData];
    }else if (type == YXQATemplateYesNo){
        question = [[QATwoNumberAnswerQuestion alloc]initWithRawData:rawData];
    }else if (type == YXQATemplateFill) {
        question = [[QAStringAnswerQuestion alloc]initWithRawData:rawData];
    }else if (type == YXQATemplateSubjective){
        question = [[QAImageAnswerQuestion alloc]initWithRawData:rawData];
    }else if (type == YXQATemplateConnect ||
              type == YXQATemplateClassify){
        question = [[QANumberGroupAnswerQuestion alloc]initWithRawData:rawData];
    }else if (type == YXQATemplateReadComplex ||
              type == YXQATemplateClozeComplex ||
              type == YXQATemplateListenComplex){
        question = [[QAComplexAnswerQuestion alloc]initWithRawData:rawData];
    }else if (type == YXQATemplateOral) {
        question = [[QAOralAnswerQuestion alloc]initWithRawData:rawData];
    }
    return question;
}
@end
