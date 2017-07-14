//
//  QAQuestionBaseView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/11.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QASlideItemBaseView.h"
#import "YXQAAnalysisKnpClickDelegate.h"
#import "YXQAAnalysisReportErrorDelegate.h"
#import "YXQAAnalysisDataDelegate.h"
#import "YXQASubjectiveAddPhotoHandler.h"
#import "YXAutoGoNextDelegate.h"
#import "QATitleView.h"
#import "QAAnalysisEditNoteDelegate.h"
#import "QAAnswerStateChangeDelegate.h"

@class QAQuestionBaseView;
@protocol QAQuestionViewSlideDelegate <NSObject>
- (void)questionView:(QAQuestionBaseView *)view didSlideToChildQuestion:(QAQuestion *)question;
@end

@interface QAQuestionBaseView : QASlideItemBaseView
@property (nonatomic, assign) BOOL isSubQuestionView;
@property (nonatomic, assign) BOOL hideQuestion;
@property (nonatomic, strong) QAQuestion *data;
@property (nonatomic, strong, readonly) QAQuestion *oriData;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL isPaperSubmitted;
@property (nonatomic, assign) NSInteger nextLevelStartIndex;
@property (nonatomic, assign) BOOL showChildIndexFromOne;
@property (nonatomic, strong) YXQASubjectiveAddPhotoHandler *addPhotoHandler;
@property (nonatomic, weak) id<YXAutoGoNextDelegate> delegate;
@property (nonatomic, weak) id<YXQASubjectiveAddPhotoDelegate> photoDelegate;
@property (nonatomic, weak) id<QAQuestionViewSlideDelegate> slideDelegate;
@property (nonatomic, weak) id<QAAnswerStateChangeDelegate> answerStateChangeDelegate;

@property (nonatomic, assign) BOOL analysisDataHidden;
@property (nonatomic, assign) BOOL canDoExerciseFromKnp;
@property (nonatomic, weak) id<YXQAAnalysisKnpClickDelegate> pointClickDelegate;
@property (nonatomic, weak) id<YXQAAnalysisReportErrorDelegate> reportErrorDelegate;
@property (nonatomic, weak) id<YXQAAnalysisDataDelegate> analysisDataDelegate;
@property (nonatomic, weak) id<QAAnalysisEditNoteDelegate> editNoteDelegate;
// UI
@property (nonatomic, strong) QATitleView *titleView; 
- (void)setupUI; // subclass need to override this func to implement specific UI

@end
