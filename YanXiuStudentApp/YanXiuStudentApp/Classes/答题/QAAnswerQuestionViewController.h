//
//  QAAnswerQuestionViewController.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/22.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QABaseViewController.h"

@interface QAAnswerQuestionViewController : QABaseViewController
@property (nonatomic, assign) YXPType pType;
@property (nonatomic, strong) YXQARequestParams *requestParams;
@property(nonatomic, copy) NSString *rmsPaperId;//仅用于BC资源
@end
