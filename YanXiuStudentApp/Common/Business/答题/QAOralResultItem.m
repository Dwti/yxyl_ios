//
//  QAOralResultItem.m
//  YanXiuStudentApp-iPhone
//
//  Created by LiuWenXing on 2017/10/20.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAOralResultItem.h"

@implementation QAOralResultItemWord
@end

@implementation QAOralResultItemLine
@end

@implementation QAOralResultItem
- (QAOralResultGrade)oralResultGrade {
    QAOralResultItemLine *line = self.lines.firstObject;
    if (line.score.floatValue < 30) {
        return QAOralResultGradeD;
    } else if (line.score.floatValue >= 30 && line.score.floatValue < 60) {
        return QAOralResultGradeC;
    } else if (line.score.floatValue >= 60 && line.score.floatValue < 80) {
        return QAOralResultGradeB;
    } else {
        return QAOralResultGradeA;
    }
}

- (NSString *)oralGradeImageName {
    NSString *gradeName;
    if ([self oralResultGrade] == QAOralResultGradeA) {
        gradeName = @"作答结果太棒了";
    } else if ([self oralResultGrade] == QAOralResultGradeB) {
        gradeName = @"作答结果还不错";
    } else if ([self oralResultGrade] == QAOralResultGradeC) {
        gradeName = @"作答结果再努力";
    } else {
        gradeName = @"作答结果再来一次";
    }
    return gradeName;
}
@end
