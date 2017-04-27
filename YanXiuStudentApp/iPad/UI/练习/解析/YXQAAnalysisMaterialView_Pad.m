//
//  YXQAAnalysisMaterialView_Pad.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/29.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQAAnalysisMaterialView_Pad.h"
#import "YXQAAnalysisYesNoView_Pad.h"
#import "YXQAAnalysisSingleChooseView_Pad.h"
#import "YXQAAnalysisMultiChooseView_Pad.h"
#import "YXQAAnalysisFillBlankView_Pad.h"

@implementation YXQAAnalysisMaterialView_Pad

- (YXSlideViewItemViewBase *)slideView:(YXSlideView *)sender viewForIndex:(NSInteger)index {
    QAQuestion *data = [self.data.childQuestions objectAtIndex:index];
    if (data.templateType == YXQATemplateSingleChoose) {
        YXQAAnalysisSingleChooseView_Pad *v = [[YXQAAnalysisSingleChooseView_Pad alloc] init];
        v.data = data;
        v.bShowTitleState = NO;
        v.analysisDataHidden = self.analysisDataHidden;
        v.canDoExerciseFromKnp = self.canDoExerciseFromKnp;
        v.pointClickDelegate = self.pointClickDelegate;
        v.reportErrorDelegate = self.reportErrorDelegate;
        v.analysisDataDelegate = self.analysisDataDelegate;
        return v;
    }
    if (data.templateType == YXQATemplateMultiChoose) {
        YXQAAnalysisMultiChooseView_Pad *v = [[YXQAAnalysisMultiChooseView_Pad alloc] init];
        v.data = data;
        v.bShowTitleState = NO;
        v.analysisDataHidden = self.analysisDataHidden;
        v.canDoExerciseFromKnp = self.canDoExerciseFromKnp;
        v.pointClickDelegate = self.pointClickDelegate;
        v.reportErrorDelegate = self.reportErrorDelegate;
        v.analysisDataDelegate = self.analysisDataDelegate;
        return v;
    }
    if (data.templateType == YXQATemplateYesNo) {
        YXQAAnalysisYesNoView_Pad *v = [[YXQAAnalysisYesNoView_Pad alloc] init];
        v.data = data;
        v.bShowTitleState = NO;
        v.analysisDataHidden = self.analysisDataHidden;
        v.canDoExerciseFromKnp = self.canDoExerciseFromKnp;
        v.pointClickDelegate = self.pointClickDelegate;
        v.reportErrorDelegate = self.reportErrorDelegate;
        v.analysisDataDelegate = self.analysisDataDelegate;
        return v;
    }
    if (data.templateType == YXQATemplateFill) {
        YXQAAnalysisFillBlankView_Pad *v = [[YXQAAnalysisFillBlankView_Pad alloc] init];
        v.data = data;
        v.bShowTitleState = NO;
        v.analysisDataHidden = self.analysisDataHidden;
        v.canDoExerciseFromKnp = self.canDoExerciseFromKnp;
        v.pointClickDelegate = self.pointClickDelegate;
        v.reportErrorDelegate = self.reportErrorDelegate;
        v.analysisDataDelegate = self.analysisDataDelegate;
        return v;
    }
//    if (data.itemType == YXQAItemMaterial) {
//        YXQAAnalysisMaterialView_Pad *v = [[YXQAAnalysisMaterialView_Pad alloc]init];
//        v.data = (YXQAComplexItem *)data;
//        v.analysisDataHidden = self.analysisDataHidden;
//        v.canDoExerciseFromKnp = self.canDoExerciseFromKnp;
//        v.pointClickDelegate = self.pointClickDelegate;
//        v.reportErrorDelegate = self.reportErrorDelegate;
//        v.analysisDataDelegate = self.analysisDataDelegate;
//        return v;
//    }
    
    return nil;

}

@end
