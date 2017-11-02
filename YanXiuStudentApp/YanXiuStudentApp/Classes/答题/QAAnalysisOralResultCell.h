//
//  QAAnalysisOralResultCell.h
//  YanXiuStudentApp-iPhone
//
//  Created by LiuWenXing on 2017/10/26.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAAnalysisBaseCell.h"

@interface QAAnalysisOralResultCell : QAAnalysisBaseCell
@property (nonatomic, assign) BOOL hasAnswer;
@property (nonatomic, strong) NSString *oralScore;

+ (CGFloat)height;
@end
