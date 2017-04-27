//
//  YXGetQuestionListRequest.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/15.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXGetRequest.h"
#import "YXIntelligenceQuestionListItem.h"

// 获取试题列表
@interface YXGetQuestionListRequest : YXGetRequest

@property (nonatomic, strong) NSString *paperId; //练习Id

@end
