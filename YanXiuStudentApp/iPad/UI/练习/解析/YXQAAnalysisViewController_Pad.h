//
//  YXQAAnalysisViewController_Pad.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/29.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXBaseViewController_Pad.h"
#import "YXSubmitQuestionRequest.h"
#import "YXQAProgressView_Pad.h"
#import "YXQAAnalysisDataDelegate.h"
#import "YXQAAnalysisYesNoView_Pad.h"
#import "YXQAAnalysisFillBlankView_Pad.h"
#import "YXQAAnalysisSingleChooseView_Pad.h"
#import "YXQAAnalysisMultiChooseView_Pad.h"
#import "YXQAAnalysisMaterialView_Pad.h"
#import "YXQAAnalysisSubjectiveView_Pad.h"
#import "YXQASubjectiveAddPhotoHandler.h"

@interface YXQAAnalysisViewController_Pad : YXBaseViewController_Pad<YXSlideViewDataSource, YXSlideViewDelegate,YXQAAnalysisKnpClickDelegate,YXQAAnalysisReportErrorDelegate>
@property (nonatomic, strong) UIImageView *bookView;
@property (nonatomic, strong) YXSlideView *slideView;
@property (nonatomic, assign) NSInteger firstLevel;
@property (nonatomic, assign) NSInteger secondLevel;
@property (nonatomic, assign) BOOL canDoExerciseFromKnp;
@property (nonatomic, strong) YXQARequestParams *requestParams;
@property (nonatomic, strong) QAPaperModel *model;
@property (nonatomic, assign) YXPType pType;
@property (nonatomic, strong) YXQAProgressView_Pad *progressView;
@property (nonatomic, strong) id<YXQAAnalysisDataDelegate> analysisDataDelegate;

- (void)setupRightFavorStatus:(BOOL)isFavor;

@property (nonatomic, strong) YXQASubjectiveAddPhotoHandler *addPhotoHandler;
@end
