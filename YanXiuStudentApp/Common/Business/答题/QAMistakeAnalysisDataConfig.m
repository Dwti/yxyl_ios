//
//  QAMistakeAnalysisDataConfig.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 3/14/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "QAMistakeAnalysisDataConfig.h"

@implementation QAMistakeAnalysisDataConfig

- (BOOL)shouldShowAnalysisDataWithQAItemType:(YXQATemplateType)qaType analysisType:(YXQAAnalysisType)analysisType{
    if (qaType == YXQATemplateSingleChoose ||
        qaType == YXQATemplateMultiChoose ||
        qaType == YXQATemplateYesNo ) {
        if (analysisType == YXAnalysisCurrentStatus ||
            analysisType == YXAnalysisDifficulty ||
            analysisType == YXAnalysisAnalysis ||
            analysisType == YXAnalysisKnowledgePoint ||
            analysisType == YXAnalysisNote ||
            analysisType == YXAnalysisNoteImage) {
            return YES;
        }else{
            return NO;
        }
    } else if (qaType == YXQATemplateFill ||
               qaType == YXQATemplateConnect ||
               qaType == YXQATemplateClassify) {
        if (analysisType == YXAnalysisCurrentStatus ||
            analysisType == YXAnalysisDifficulty ||
            analysisType == YXAnalysisAnalysis ||
            analysisType == YXAnalysisKnowledgePoint ||
            analysisType == YXAnalysisAnswer ||
            analysisType == YXAnalysisNote ||
            analysisType == YXAnalysisNoteImage) {
            return YES;
        }else{
            return NO;
        }
        
    } else if (qaType == YXQATemplateSubjective){
        if (analysisType == YXAnalysisAudioComment ||
            analysisType == YXAnalysisResult ||
            analysisType == YXAnalysisScore ||
            analysisType == YXAnalysisDifficulty ||
            analysisType == YXAnalysisAnalysis ||
            analysisType == YXAnalysisAnswer ||
            analysisType == YXAnalysisKnowledgePoint ||
            analysisType == YXAnalysisNote ||
            analysisType == YXAnalysisNoteImage
        ) {
            return YES;
        }else{
            return NO;
        }
    } else if (qaType == YXQATemplateOral) {
        if (analysisType == YXAnalysisCurrentStatus  ||
            analysisType == YXAnalysisDifficulty ||
            analysisType == YXAnalysisAnalysis ||
            analysisType == YXAnalysisKnowledgePoint ||
            analysisType == YXAnalysisAnswer) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}
@end
