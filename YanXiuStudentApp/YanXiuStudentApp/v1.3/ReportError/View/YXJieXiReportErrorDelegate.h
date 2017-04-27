//
//  Header.h
//  YanXiuStudentApp
//
//  Created by wd on 15/11/18.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXSubmitQuestionRequest.h"
@protocol YXJieXiReportErrorDelegate <NSObject>
@optional
- (void)jieXiReportErrorWithQId:(NSString *)quesId;
- (YXPType)jixXiType;

@end