//
//  YXGetQuestionReportRequest.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/11.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXGetRequest.h"
#import "YXIntelligenceQuestionListItem.h"

// 答题报告
@interface YXGetQuestionReportRequest : YXGetRequest

@property (nonatomic, strong) NSString *ppid; // 试卷编号
@property (nonatomic, strong) NSString *flag; // 答案形式(0, 简短答案，只包含答案， 1 包含答案和解析)

@end
