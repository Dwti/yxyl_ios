//
//  MistakePageListFetcher.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 3/31/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "MistakePageListFetcher.h"
#import "MistakeListByQIDsRequest.h"

@interface MistakePageListFetcher ()
@property (nonatomic, strong) MistakeListByQIDsRequest *request;
@end

@implementation MistakePageListFetcher
- (void)startWithBlock:(void(^)(int total, NSArray *retItemArray, NSError *error))aCompleteBlock {
    [self.request stopRequest];
    self.request = [[MistakeListByQIDsRequest alloc] init];
    self.request.qids = [self requestQIDs];
    self.request.subjectId = self.subjectID;
    [self.request startRequestWithRetClass:[YXIntelligenceQuestionListItem class] andCompleteBlock:^(id retItem, NSError *error) {
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,nil,error)
            return ;
        }
        YXIntelligenceQuestionListItem *item = retItem;
        QAPaperModel *model = [QAPaperModel modelFromRawData:item.data[0]];
        BLOCK_EXEC(aCompleteBlock,(int)[self.qids count],model.questions,nil)
    }];
}

- (void)startWithMistakeBlock:(void(^)(int total, YXIntelligenceQuestionListItem *retItem, NSError *error))aCompleteBlock {
    [self.request stopRequest];
    self.request = [[MistakeListByQIDsRequest alloc] init];
    self.request.qids = [self requestQIDs];
    self.request.subjectId = self.subjectID;
    [self.request startRequestWithRetClass:[YXIntelligenceQuestionListItem class] andCompleteBlock:^(id retItem, NSError *error) {
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,nil,error)
            return ;
        }
        BLOCK_EXEC(aCompleteBlock,(int)[self.qids count], retItem, nil)
    }];
}

- (NSString *)requestQIDs {
    NSUInteger length = MIN(10, (self.qids.count - (self.pageindex) * 10));
    NSUInteger loc = self.pageindex * 10;
    NSArray *qids = [self.qids subarrayWithRange:NSMakeRange(loc, length)];
    NSString *qidsStr = [qids componentsJoinedByString:@","];
    return qidsStr;
}

@end
