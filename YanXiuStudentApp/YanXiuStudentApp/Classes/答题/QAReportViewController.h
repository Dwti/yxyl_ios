//
//  QAReportViewController.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/20.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "BaseViewController.h"

@interface QAReportViewController : BaseViewController
@property (nonatomic, strong) QAPaperModel *model;
@property (nonatomic, assign) YXPType pType;
@property (nonatomic, assign) BOOL canDoExerciseAgain;
@property (nonatomic, strong) YXQARequestParams *requestParams;
@property(nonatomic, copy) NSString *rmsPaperId;//仅用于BC资源

@end
