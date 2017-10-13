//
//  BCResourceDataManager.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/10/18.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GetTopicTreeRequest.h"
#import "YXGetQuestionReportRequest.h"
#import "ResetTopicPaperHistoryRequest.h"
#import "GetTopicPaperQuestionRequest.h"

extern NSString *const kResetTopicPaperHistorySuccessNotification;

typedef void(^TopicTreeRequestBlock)(GetTopicTreeRequestItem *retItem, NSError *error);

@interface BCResourceDataManager : NSObject

+ (instancetype)sharedInstance;

//请求BC资源列表
+ (void)requestTopicTreeWithSubjectId:(NSString *)subjectId type:(NSString *)type completeBlock:(TopicTreeRequestBlock)requestBlock;

// 请求报告
+ (void)getQuestionReportWithPaperID:(NSString *)paperID completeBlock:(void(^)(YXIntelligenceQuestionListItem * item, NSError *error))completeBlock;

// 报告页重新作答
+ (void)resetTopicPaperHistoryWithPaperID:(NSString *)paperID completeBlock:(void(^)(YXIntelligenceQuestionListItem *, NSError *))completeBlock;

//请求题目列表
+ (void)requestTopicPaperQuestionWithPaperID:(NSString *)paperID type:(NSString *)type completeBlock:(void (^)(YXIntelligenceQuestionListItem *, NSError *))completeBlock;
@end

