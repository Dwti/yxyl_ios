//
//  QAComlexQuestionAnalysisBaseView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/11.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAComlexQuestionAnalysisBaseView.h"

@implementation QAComlexQuestionAnalysisBaseView

- (QASlideItemBaseView *)slideView:(QASlideView *)slideView itemViewAtIndex:(NSInteger)index {
    QAQuestion *data = [self.data.childQuestions objectAtIndex:index];
    data.wrongQuestionID = self.data.wrongQuestionID;

    QAQuestionViewContainer *container = [QAQuestionViewContainerFactory containerWithQuestion:data];
    QAQuestionBaseView *view = [container questionAnalysisView];
    
    view.data = data;
    view.isPaperSubmitted = self.isPaperSubmitted;
    view.isSubQuestionView = YES;
    view.delegate = self;
    view.analysisDataDelegate = self.analysisDataDelegate;
    view.canDoExerciseFromKnp = self.canDoExerciseFromKnp;
    view.pointClickDelegate = self.pointClickDelegate;
    view.analysisDataHidden = self.analysisDataHidden;
    view.editNoteDelegate = self.editNoteDelegate;
    
    return view;
}

@end
