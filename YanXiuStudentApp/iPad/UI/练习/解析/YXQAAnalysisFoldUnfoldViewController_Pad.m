//
//  YXQAAnalysisFoldUnfoldViewController_Pad.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/2/2.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQAAnalysisFoldUnfoldViewController_Pad.h"

@interface YXQAAnalysisFoldUnfoldViewController_Pad ()

@end

@implementation YXQAAnalysisFoldUnfoldViewController_Pad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (YXSlideViewItemViewBase *)slideView:(YXSlideView *)sender viewForIndex:(NSInteger)index {
    QAQuestion *data = [self.model.questions objectAtIndex:index];
    if (data.templateType == YXQATemplateSingleChoose) {
        YXQAAnalysisSingleChooseView_Pad *bv = [[YXQAAnalysisSingleChooseView_Pad alloc] init];
        bv.data = data;
        bv.title = self.model.paperTitle;
        bv.bShowTitleState = YES;
        bv.canDoExerciseFromKnp = self.canDoExerciseFromKnp;
        bv.pointClickDelegate = self;
        bv.reportErrorDelegate = self;
        bv.analysisDataDelegate = self.analysisDataDelegate;
        bv.analysisDataHidden = YES;
        return bv;
    }
    if (data.templateType == YXQATemplateMultiChoose) {
        YXQAAnalysisMultiChooseView_Pad *bv = [[YXQAAnalysisMultiChooseView_Pad alloc] init];
        bv.data = data;
        bv.title = self.model.paperTitle;
        bv.bShowTitleState = YES;
        bv.canDoExerciseFromKnp = self.canDoExerciseFromKnp;
        bv.pointClickDelegate = self;
        bv.reportErrorDelegate = self;
        bv.analysisDataDelegate = self.analysisDataDelegate;
        bv.analysisDataHidden = YES;
        return bv;
    }
    if (data.templateType == YXQATemplateYesNo) {
        YXQAAnalysisYesNoView_Pad *bv = [[YXQAAnalysisYesNoView_Pad alloc] init];
        bv.data = data;
        bv.title = self.model.paperTitle;
        bv.bShowTitleState = YES;
        bv.canDoExerciseFromKnp = self.canDoExerciseFromKnp;
        bv.pointClickDelegate = self;
        bv.reportErrorDelegate = self;
        bv.analysisDataDelegate = self.analysisDataDelegate;
        bv.analysisDataHidden = YES;
        return bv;
    }
    if (data.templateType == YXQATemplateFill) {
        YXQAAnalysisFillBlankView_Pad *bv = [[YXQAAnalysisFillBlankView_Pad alloc] init];
        bv.data = data;
        bv.title = self.model.paperTitle;
        bv.bShowTitleState = YES;
        bv.canDoExerciseFromKnp = self.canDoExerciseFromKnp;
        bv.pointClickDelegate = self;
        bv.reportErrorDelegate = self;
        bv.analysisDataDelegate = self.analysisDataDelegate;
        bv.analysisDataHidden = YES;
        return bv;
    }
    if (data.templateType == YXQATemplateSubjective) {
        YXQAAnalysisSubjectiveView_Pad *bv = [[YXQAAnalysisSubjectiveView_Pad alloc] init];
        bv.data = data;
        bv.title = self.model.paperTitle;
        bv.bShowTitleState = YES;
        bv.canDoExerciseFromKnp = self.canDoExerciseFromKnp;
        bv.pointClickDelegate = self;
        bv.reportErrorDelegate = self;
        bv.analysisDataDelegate = self.analysisDataDelegate;
        bv.analysisDataHidden = YES;
        bv.delegate = self.addPhotoHandler;
        return bv;
    }
//    if (data.itemType == YXQAItemMaterial) {
//        YXQAAnalysisMaterialView_Pad *bv = [[YXQAAnalysisMaterialView_Pad alloc] init];
//        bv.data = (YXQAComplexItem *)data;
//        bv.title = self.model.title;
//        bv.canDoExerciseFromKnp = self.canDoExerciseFromKnp;
//        bv.pointClickDelegate = self;
//        bv.reportErrorDelegate = self;
//        bv.analysisDataDelegate = self.analysisDataDelegate;
//        bv.analysisDataHidden = YES;
//        if (index == self.firstLevel) {
//            if (self.secondLevel >= 0) {
//                bv.nextLevelStartIndex = self.secondLevel;
//                self.secondLevel = -1;
//            }
//        }
//        return bv;
//    }
    
    return nil;
}

@end
