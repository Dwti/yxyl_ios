//
//  QAQuestionViewContainerFactory.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/11.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QASingleChooseQuestionViewContainer.h"
#import "QAMultiChooseQuestionViewContainer.h"
#import "QAYesNoQuestionViewContainer.h"
#import "QAFillQuestionViewContainer.h"
#import "QASubjectiveQuestionViewContainer.h"
#import "QAConnectQuestionViewContainer.h"
#import "QAClassifyQuestionViewContainer.h"
#import "QAClozeQuestionViewContainer.h"
#import "QAListenQuestionViewContainer.h"
#import "QAReadQuestionViewContainer.h"
#import "QAOralQuestionViewContainer.h"
#import "QAUnknownQuestionViewContainer.h"

@interface QAQuestionViewContainerFactory : NSObject

+ (QAQuestionViewContainer *)containerWithQuestion:(QAQuestion *)question;

@end
