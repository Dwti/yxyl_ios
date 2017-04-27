//
//  YXAnswerQuestionViewController.h
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/14/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "BaseViewController.h"
#import "YXSubmitQuestionRequest.h"

@interface YXAnswerQuestionViewController : BaseViewController

@property (nonatomic, strong) QAPaperModel *model;
@property (nonatomic, assign) YXPType pType;
@property (nonatomic, strong) YXQARequestParams *requestParams;

@end
