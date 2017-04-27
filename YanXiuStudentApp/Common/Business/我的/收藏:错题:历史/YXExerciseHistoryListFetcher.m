//
//  YXExerciseHistoryListFetcher.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/2/19.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXExerciseHistoryListFetcher.h"
#import "YXGetPracticeHistoryRequest.h"
#import "YXGetPracticeHistoryByKnowRequest.h"
#import "YXGetPracticeEditionRequest.h"

@interface YXExerciseHistoryListFetcher ()

@property (nonatomic, strong) YXGetPracticeHistoryRequest *request;

@end

@implementation YXExerciseHistoryListFetcher

- (void)startWithBlock:(void(^)(int total, NSArray *retItemArray, NSError *error))aCompleteBlock
{
    [self stop];
    _request = [self historyRequest];
    _request.pageSize = [NSString stringWithFormat:@"%@", @(self.pagesize)];
    _request.nextPage = [NSString stringWithFormat:@"%@", @(self.pageindex+1)];
    _request.stageId = [YXUserManager sharedManager].userModel.stageid;
    _request.subjectId = self.subject.subjectID;
    _request.beditionId = self.subject.edition.editionId;
    [_request startRequestWithRetClass:[YXGetPracticeHistoryItem class]
                      andCompleteBlock:^(id retItem, NSError *error) {
                          YXGetPracticeHistoryItem *ret = retItem;
                          if (error) {
                              if (error.code == 65 && ret) { // 65 表示空，擦！
                                  aCompleteBlock(0, ret.data, nil);
                              }else {
                                  aCompleteBlock(0, nil, error);
                                  return;
                              }
                          }
                          aCompleteBlock([ret.page.totalCou intValue], ret.data, nil);
                      }];
}

- (YXGetPracticeHistoryRequest *)historyRequest
{
    return [[YXGetPracticeHistoryRequest alloc] init];
}

- (void)stop
{
    [self.request stopRequest];
}

@end

@implementation YXExerciseHistoryByKnowListFetcher

- (YXGetPracticeHistoryRequest *)historyRequest
{
    return [[YXGetPracticeHistoryByKnowRequest alloc] init];
}

@end
