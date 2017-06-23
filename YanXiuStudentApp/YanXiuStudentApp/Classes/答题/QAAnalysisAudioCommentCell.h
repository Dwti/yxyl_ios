//
//  QAAnalysisAudioCommentCell.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/27.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAAnalysisBaseCell.h"

@interface QAAnalysisAudioCommentCell : QAAnalysisBaseCell
@property (nonatomic, strong) QAQuestion *questionItem;
- (void)stop;
+ (CGFloat)heightForAudioComment:(NSArray *)array;

@end
