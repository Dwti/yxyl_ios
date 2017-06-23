//
//  QAAnalysisScoreCell.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/27.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAAnalysisBaseCell.h"

@interface QAAnalysisScoreCell : QAAnalysisBaseCell
@property (nonatomic, assign) CGFloat score;
@property (nonatomic, assign) BOOL isMarked;

- (void)updateUI;
+ (CGFloat)height;
@end
