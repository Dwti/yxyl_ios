//
//  YXQAAnalysisSubjectiveView_Pad.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/2/16.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQASubjectiveView_Pad.h"
#import "YXQAAnalysisKnpClickDelegate.h"
#import "YXQAAnalysisReportErrorDelegate.h"
#import "YXQAAnalysisDataDelegate.h"

@interface YXQAAnalysisSubjectiveView_Pad : YXQASubjectiveView_Pad
@property (nonatomic, assign) BOOL analysisDataHidden;
@property (nonatomic, assign) BOOL canDoExerciseFromKnp;
@property (nonatomic, weak) id<YXQAAnalysisKnpClickDelegate> pointClickDelegate;
@property (nonatomic, weak) id<YXQAAnalysisReportErrorDelegate> reportErrorDelegate;
@property (nonatomic, weak) id<YXQAAnalysisDataDelegate> analysisDataDelegate;

@end
