//
//  YXErrorsPagedListFetcher.m
//  YanXiuStudentApp
//
//  Created by 贾培军 on 16/6/17.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXErrorsPagedListFetcher.h"

@interface YXErrorsPagedListFetcher()
@property (nonatomic, strong) YXErrorsRequest *mistakeListRequest;
@end

@implementation YXErrorsPagedListFetcher

- (void)startWithBlock:(void(^)(int total, NSArray *retItemArray, NSError *error))aCompleteBlock {
    NSString *page = [NSString stringWithFormat:@"%@", @(self.pageindex+1)];
    NSString *currentID = (self.pageindex>0? [NSString stringWithFormat:@"%@",@(self.lastID)]:nil);

    [self.mistakeListRequest stopRequest];
    self.mistakeListRequest = [[YXErrorsRequest alloc]init];
    self.mistakeListRequest.subjectId = self.subjectID;
    self.mistakeListRequest.pageSize = @"10";
    self.mistakeListRequest.currentPage = page;
    self.mistakeListRequest.currentId = currentID;
    self.mistakeListRequest.stageId = [YXUserManager sharedManager].userModel.stageid;
    [self.mistakeListRequest startRequestWithRetClass:[YXIntelligenceQuestionListItem class] andCompleteBlock:^(id retItem, NSError *error) {
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,nil,error);
            return;
        }
        YXIntelligenceQuestionListItem *item = retItem;
        QAPaperModel *model = [QAPaperModel modelFromRawData:item.data[0]];
        QAQuestion *lastQ = model.questions.lastObject;
        self.lastID = lastQ.wrongQuestionID.integerValue;
        BLOCK_EXEC(aCompleteBlock,item.page.totalCou.intValue,model.questions,nil);
    }];
}

@end
