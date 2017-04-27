//
//  KnpTreeDataFetcher.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/28.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "KnpTreeDataFetcher.h"
#import "GetKnpListRequest.h"

@interface KnpTreeDataFetcher ()
@property (nonatomic, strong) GetKnpListRequest *request;
@end

@implementation KnpTreeDataFetcher
- (void)fetchTreeDataWithCompleteBlock:(TreeDataBlock)completeBlock {
    [self.request stopRequest];
    self.request = [[GetKnpListRequest alloc]init];
    self.request.stageId = [YXUserManager sharedManager].userModel.stageid;
    self.request.subjectId = self.subjectID;
    [self.request startRequestWithRetClass:[GetKnpListRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        if (error) {
            BLOCK_EXEC(completeBlock,nil,error);
            return;
        }
        GetKnpListRequestItem *item = retItem;
        BLOCK_EXEC(completeBlock,item.knps,nil);
    }];
}
@end
