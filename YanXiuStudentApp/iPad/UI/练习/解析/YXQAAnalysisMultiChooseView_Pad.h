//
//  YXQAAnalysisMultiChooseView_Pad.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/28.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQAMultiChooseView_Pad.h"
#import "YXQAAnalysisKnpClickDelegate.h"
#import "YXQAAnalysisReportErrorDelegate.h"
#import "YXQAAnalysisDataDelegate.h"

@interface YXQAAnalysisMultiChooseView_Pad : YXQAMultiChooseView_Pad
@property (nonatomic, assign) BOOL analysisDataHidden;
@property (nonatomic, assign) BOOL canDoExerciseFromKnp;
@property (nonatomic, weak) id<YXQAAnalysisKnpClickDelegate> pointClickDelegate;
@property (nonatomic, weak) id<YXQAAnalysisReportErrorDelegate> reportErrorDelegate;
@property (nonatomic, weak) id<YXQAAnalysisDataDelegate> analysisDataDelegate;
@end
