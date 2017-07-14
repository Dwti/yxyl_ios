//
//  QAAnalysisSubjectiveResultCell.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/7/11.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAAnalysisBaseCell.h"

@interface QAAnalysisSubjectiveResultCell : QAAnalysisBaseCell
@property (nonatomic, assign) BOOL isMarked;
@property (nonatomic, assign) BOOL isCorrect;

- (void)updateUI;
+ (CGFloat)height;
@end
