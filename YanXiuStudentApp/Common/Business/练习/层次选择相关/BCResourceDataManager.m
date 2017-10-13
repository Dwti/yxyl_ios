//
//  BCResourceDataManager.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/10/18.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "BCResourceDataManager.h"

NSString *const kResetTopicPaperHistorySuccessNotification = @"kResetTopicPaperHistorySuccessNotification";

@interface BCResourceDataManager ()
@property(nonatomic, strong) GetTopicTreeRequest *topicTreeRequest;
@property (nonatomic, strong) YXGetQuestionReportRequest *getQuestionReportRequest;
@property (nonatomic, strong) ResetTopicPaperHistoryRequest *resetTopicPaperHistoryRequest;
@property (nonatomic, strong) GetTopicPaperQuestionRequest *getTopicPaperQuestionRequest;

@end

@implementation BCResourceDataManager
+ (instancetype)sharedInstance {
    static BCResourceDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[BCResourceDataManager alloc] init];
    });
    return manager;
}

+ (void)requestTopicTreeWithSubjectId:(NSString *)subjectId type:(NSString *)type completeBlock:(TopicTreeRequestBlock)requestBlock {
    BCResourceDataManager *manager = [BCResourceDataManager sharedInstance];
    [manager.topicTreeRequest stopRequest];
    manager.topicTreeRequest = [[GetTopicTreeRequest alloc]init];
    manager.topicTreeRequest.subjectId = subjectId;
    manager.topicTreeRequest.type = type;
    WEAK_SELF
    [manager.topicTreeRequest startRequestWithRetClass:[GetTopicTreeRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(requestBlock,nil,error);
            return;
        }
        GetTopicTreeRequestItem *item = retItem;
        BLOCK_EXEC(requestBlock,item,nil);
    }];
}

+ (void)getQuestionReportWithPaperID:(NSString *)paperID completeBlock:(void (^)(YXIntelligenceQuestionListItem *, NSError *))completeBlock {
    BCResourceDataManager *manager = [BCResourceDataManager sharedInstance];
    [manager.getQuestionReportRequest stopRequest];
    manager.getQuestionReportRequest = [[YXGetQuestionReportRequest alloc] init];
    manager.getQuestionReportRequest.ppid = paperID;
    manager.getQuestionReportRequest.flag = @"1";
    WEAK_SELF
    [manager.getQuestionReportRequest startRequestWithRetClass:[YXIntelligenceQuestionListItem class] andCompleteBlock:^(id retItem, NSError *error) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,retItem,error);
            return;
        }
        BLOCK_EXEC(completeBlock,retItem,nil);
    }];
}

+ (void)resetTopicPaperHistoryWithPaperID:(NSString *)paperID completeBlock:(void (^)(YXIntelligenceQuestionListItem *, NSError *))completeBlock {
    BCResourceDataManager *manager = [BCResourceDataManager sharedInstance];
    [manager.resetTopicPaperHistoryRequest stopRequest];
    manager.resetTopicPaperHistoryRequest = [[ResetTopicPaperHistoryRequest alloc] init];
    manager.resetTopicPaperHistoryRequest.paperId = paperID;
    WEAK_SELF
    [manager.resetTopicPaperHistoryRequest startRequestWithRetClass:[YXIntelligenceQuestionListItem class] andCompleteBlock:^(id retItem, NSError *error) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,retItem,error);
            return;
        }
        BLOCK_EXEC(completeBlock,retItem,nil);
        [[NSNotificationCenter defaultCenter]postNotificationName:kResetTopicPaperHistorySuccessNotification object:nil];
    }];
}

+ (void)requestTopicPaperQuestionWithPaperID:(NSString *)paperID type:(NSString *)type completeBlock:(void (^)(YXIntelligenceQuestionListItem *, NSError *))completeBlock {
    BCResourceDataManager *manager = [BCResourceDataManager sharedInstance];
    [manager.getTopicPaperQuestionRequest stopRequest];
    manager.getTopicPaperQuestionRequest = [[GetTopicPaperQuestionRequest alloc] init];
    manager.getTopicPaperQuestionRequest.type = type;
    manager.getTopicPaperQuestionRequest.rmsPaperId = paperID;
    WEAK_SELF
    [manager.getTopicPaperQuestionRequest startRequestWithRetClass:[YXIntelligenceQuestionListItem class] andCompleteBlock:^(id retItem, NSError *error) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,retItem,error);
            return;
        }
        BLOCK_EXEC(completeBlock,retItem,nil);
    }];
}
@end
