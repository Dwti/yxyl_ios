//
//  MistakeKnpTreeDataFetcher.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 3/31/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "MistakeKnpTreeDataFetcher.h"
#import "MistakeKnpListRequest.h"
#import "MistakeMockDataManager.h"

@interface MistakeKnpTreeDataFetcher ()
@property (nonatomic, strong) MistakeKnpListRequest *request;
@end

@implementation MistakeKnpTreeDataFetcher
- (void)fetchTreeDataWithCompleteBlock:(TreeDataBlock)completeBlock {
    [self.request stopRequest];
    self.request = [[MistakeKnpListRequest alloc] init];
    self.request.stageId = [YXUserManager sharedManager].userModel.stageid;
    self.request.subjectId = self.subjectId;
    self.request.editionId = self.editionId;
    [self.request startRequestWithRetClass:[MistakeKnpListRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        if (error) {
            BLOCK_EXEC(completeBlock, nil, error);
            return ;
        }
        MistakeKnpListRequestItem *item = retItem;
//      MistakeKnpListRequestItem *item = [[MistakeKnpListRequestItem alloc] initWithString:[MistakeMockDataManager getJsonData] error:nil];

        BLOCK_EXEC(completeBlock, item.knps, nil);
    }];
}@end
