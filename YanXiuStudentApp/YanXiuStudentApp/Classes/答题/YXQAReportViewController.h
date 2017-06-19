//
//  YXQAAnalysisSheetViewController.h
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/17/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "BaseViewController.h"
#import "YXSubmitQuestionRequest.h" 
#import "YXQAAnalysisDataConfig.h"

@interface YXQAReportViewController : BaseViewController

@property (nonatomic, strong) QAPaperModel *model;
@property (nonatomic, strong) YXQARequestParams *requestParams;
@property (nonatomic, assign) YXPType pType;
@property (nonatomic, assign) BOOL canDoExerciseAgain;
// 外部不要使用
@property (nonatomic, strong) YXQAAnalysisDataConfig *analysisDataConfig;


@end
