//
//  QANoteCell.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/22.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAAnalysisBaseCell.h"

@interface QANoteCell : QAAnalysisBaseCell
- (void)updateWithText:(NSString *)text images:(NSArray<QAImageAnswer *> *)images;

+ (CGFloat)heightForText:(NSString *)text images:(NSArray<QAImageAnswer *> *)images;
@end
