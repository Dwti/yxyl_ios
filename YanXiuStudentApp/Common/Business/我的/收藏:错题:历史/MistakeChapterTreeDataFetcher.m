//
//  MistakeChapterTreeDataFetcher.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 3/31/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "MistakeChapterTreeDataFetcher.h"
#import "MistakeChapterListRequest.h"
#import "MistakeMockDataManager.h"

@interface MistakeChapterTreeDataFetcher ()
@property (nonatomic, strong) MistakeChapterListRequest *request;
@end

@implementation MistakeChapterTreeDataFetcher
- (void)fetchTreeDataWithCompleteBlock:(TreeDataBlock)completeBlock {
    [self.request stopRequest];
    self.request = [[MistakeChapterListRequest alloc] init];
    self.request.stageId = [YXUserManager sharedManager].userModel.stageid;
    self.request.subjectId = self.subjectId;
    self.request.editionId = self.editionId;
    [self.request startRequestWithRetClass:[MistakeChapterListRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        if (error) {
            BLOCK_EXEC(completeBlock, nil, error);
            return ;
        }
        MistakeChapterListRequestItem *item = retItem;
//      MistakeChapterListRequestItem *item = [[MistakeChapterListRequestItem alloc] initWithString:[MistakeMockDataManager getJsonData] error:nil];
        BLOCK_EXEC(completeBlock, item.chapters, nil);
    }];
}
@end
