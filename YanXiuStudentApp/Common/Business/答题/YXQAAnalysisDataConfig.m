//
//  YXAnalysisDataConfig.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/15.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQAAnalysisDataConfig.h"

@implementation YXQAAnalysisDataConfig

- (BOOL)shouldShowAnalysisDataWithQAItemType:(YXQATemplateType)qaType analysisType:(YXQAAnalysisType)analysisType{
    if (qaType == YXQATemplateSingleChoose ||
        qaType == YXQATemplateMultiChoose ||
        qaType == YXQATemplateYesNo ) {
        if (analysisType == YXAnalysisCurrentStatus ||
            analysisType == YXAnalysisDifficulty ||
            analysisType == YXAnalysisAnalysis ||
            analysisType == YXAnalysisKnowledgePoint
         ) {
            return YES;
        }else{
            return NO;
        }
    } else if (qaType == YXQATemplateFill ||
               qaType == YXQATemplateConnect ||
               qaType == YXQATemplateClassify) {
        if (analysisType == YXAnalysisCurrentStatus  ||
            analysisType == YXAnalysisDifficulty ||
            analysisType == YXAnalysisAnalysis ||
            analysisType == YXAnalysisKnowledgePoint ||
            analysisType == YXAnalysisAnswer
        ) {
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
            analysisType == YXAnalysisKnowledgePoint) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}

@end

