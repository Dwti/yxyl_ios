//
//  YXQAReportViewController_Pad.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/29.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXBaseViewController_Pad.h"
#import "YXSubmitQuestionRequest.h"
#import "YXQAAnalysisDataConfig.h"

@interface YXQAReportViewController_Pad : YXBaseViewController_Pad
@property (nonatomic, strong) QAPaperModel *model;
@property (nonatomic, strong) YXQARequestParams *requestParams;
@property (nonatomic, assign) YXPType pType;
@property (nonatomic, assign) BOOL canDoExerciseAgain;
// 外部不要使用
@property (nonatomic, strong) YXQAAnalysisDataConfig *analysisDataConfig;
@property (nonatomic, strong) NSArray *oriItemArray;
@end
