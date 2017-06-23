//
//  QAAnalysisKnowledgePointCell.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/27.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAAnalysisBaseCell.h"

@interface QAAnalysisKnowledgePointCell : QAAnalysisBaseCell
@property (nonatomic, strong) NSArray *knowledgePointArray;
//- (CGFloat)height;
- (CGFloat)heightWithKnowledgePointArray:(NSArray *)array;
@end
