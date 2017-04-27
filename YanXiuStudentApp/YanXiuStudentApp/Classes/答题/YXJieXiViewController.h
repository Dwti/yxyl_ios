//
//  YXAnswerQuestionViewController.h
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/14/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "BaseViewController.h"
#import "QASlideView.h"
#import "YXSubmitQuestionRequest.h"
#import "YXQAProgressView_Phone.h"
#import "YXQASubjectiveAddPhotoHandler.h"
#import "YXQAAnalysisKnpClickDelegate.h"
#import "YXQAAnalysisReportErrorDelegate.h"
#import "YXQAAnalysisDataDelegate.h"
#import "QAAnalysisEditNoteDelegate.h"

@interface YXJieXiViewController : BaseViewController<QASlideViewDataSource, QASlideViewDelegate,YXQAAnalysisKnpClickDelegate,YXQAAnalysisReportErrorDelegate, QAAnalysisEditNoteDelegate>
@property (nonatomic, strong) QAPaperModel *model;
@property (nonatomic, strong) QASlideView *slideView;

@property (nonatomic, assign) NSInteger firstLevel;
@property (nonatomic, assign) NSInteger secondLevel;

@property (nonatomic, strong) YXQARequestParams *requestParams;

@property (nonatomic, assign) YXPType pType;
@property (nonatomic, assign) BOOL canDoExerciseFromKnp;

@property (nonatomic, strong) id<YXQAAnalysisDataDelegate> analysisDataDelegate;
@property (nonatomic, strong) YXQASubjectiveAddPhotoHandler *addPhotoHandler;

- (void)setupRightFavorStatus:(BOOL)isFavor;

@end
