//
//  ChapterTreeDataFetcher.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/28.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "ChapterTreeDataFetcher.h"
#import "GetChapterListRequest.h"

@interface ChapterTreeDataFetcher ()
@property (nonatomic, strong) GetChapterListRequest *request;
@end

@implementation ChapterTreeDataFetcher
- (void)fetchTreeDataWithCompleteBlock:(TreeDataBlock)completeBlock {
    [self.request stopRequest];
    self.request = [[GetChapterListRequest alloc]init];
    self.request.stageId = [YXUserManager sharedManager].userModel.stageid;
    self.request.subjectId = self.subjectID;
    self.request.editionId = self.editionID;
    self.request.volume = self.volumeID;
    [self.request startRequestWithRetClass:[GetChapterListRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        if (error) {
            BLOCK_EXEC(completeBlock,nil,error);
            return;
        }
        GetChapterListRequestItem *item = retItem;
        BLOCK_EXEC(completeBlock,item.chapters,nil);
    }];
}
@end
