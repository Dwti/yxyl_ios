//
//  YXQAAnswerQuestionViewController_Pad.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/29.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXBaseViewController_Pad.h"
#import "YXExerciseListManager.h"
#import "YXSubmitQuestionRequest.h"

@interface YXQAAnswerQuestionViewController_Pad : YXBaseViewController_Pad

@property (nonatomic, strong) QAPaperModel *model;
@property (nonatomic, assign) YXPType pType;
@property (nonatomic, strong) YXQARequestParams *requestParams;
@end
