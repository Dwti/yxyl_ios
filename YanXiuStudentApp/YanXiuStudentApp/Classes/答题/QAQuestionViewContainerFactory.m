//
//  QAQuestionViewContainerFactory.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/11.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAQuestionViewContainerFactory.h"

@implementation QAQuestionViewContainerFactory

+ (QAQuestionViewContainer *)containerWithTemplate:(YXQATemplateType)templateType{
    if (templateType == YXQATemplateSingleChoose) {
        return [[QASingleChooseQuestionViewContainer alloc]init];
    }else if (templateType == YXQATemplateMultiChoose){
        return [[QAMultiChooseQuestionViewContainer alloc]init];
    }else if (templateType == YXQATemplateFill){
        return [[QAFillQuestionViewContainer alloc]init];
    }else if (templateType == YXQATemplateYesNo){
        return [[QAYesNoQuestionViewContainer alloc]init];
    }else if (templateType == YXQATemplateConnect){
        return [[QAConnectQuestionViewContainer alloc]init];
    }else if (templateType == YXQATemplateClassify){
        return [[QAClassifyQuestionViewContainer alloc]init];
    }else if (templateType == YXQATemplateSubjective){
        return [[QASubjectiveQuestionViewContainer alloc]init];
    }else if (templateType == YXQATemplateReadComplex){
        return [[QAReadQuestionViewContainer alloc]init];
    }else if (templateType == YXQATemplateClozeComplex){
        return [[QAClozeQuestionViewContainer alloc]init];
    }else if (templateType == YXQATemplateListenComplex){
        return [[QAListenQuestionViewContainer alloc]init];
    }else if (templateType == YXQATemplateUnknown){
        return [[QAUnknownQuestionViewContainer alloc]init];
    }else{
        return nil;
    }
}

@end
