//
//  QAAnswerStateChangeDelegate.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/26.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QAAnswerStateChangeDelegate <NSObject>
- (void)question:(QAQuestion *)question didChangeAnswerStateFrom:(YXQAAnswerState)from to:(YXQAAnswerState)to;
@end
