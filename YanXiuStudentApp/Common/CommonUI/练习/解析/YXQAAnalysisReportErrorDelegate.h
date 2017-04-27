//
//  YXQAAnalysisReportErrorDelegate.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/28.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YXQAAnalysisReportErrorDelegate <NSObject>
- (void)reportAnalysisErrorWithID:(NSString *)qid;

- (BOOL)canReportError;
@end
