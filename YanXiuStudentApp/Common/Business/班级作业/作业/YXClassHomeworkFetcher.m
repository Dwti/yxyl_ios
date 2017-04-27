//
//  YXClassHomeworkFetcher.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/2/18.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXClassHomeworkFetcher.h"
#import "YXHomeworkListGroupsRequest.h"

@interface YXClassHomeworkFetcher ()

@property (nonatomic, strong) YXHomeworkListGroupsRequest *request;

@end

@implementation YXClassHomeworkFetcher

- (void)startWithBlock:(void(^)(int total, NSArray *retItemArray, NSError *error))aCompleteBlock
{
    [self stop];
    self.request = [[YXHomeworkListGroupsRequest alloc] init];
    self.request.pageSize = [NSString stringWithFormat:@"%@", @(self.pagesize)];
    self.request.page = [NSString stringWithFormat:@"%@", @(self.pageindex+1)];
    @weakify(self);
    [self.request startRequestWithRetClass:[YXHomeworkListGroupsItem class]
                          andCompleteBlock:^(id retItem, NSError *error) {
                              @strongify(self);
                              YXHomeworkListGroupsItem *ret = retItem;
                              if (error) {
                                  if (error.code == 71) {
                                      BLOCK_EXEC(aCompleteBlock,0,nil,nil);
                                      BLOCK_EXEC(self.classJoinBlock,ret,HomeworkFetch_NeedAddClass);
                                  }else if (error.code == 72) {
                                      BLOCK_EXEC(self.classJoinBlock,ret,HomeworkFetch_NeedVerify);
                                  }else {
                                      BLOCK_EXEC(aCompleteBlock,0,nil,error);
                                      BLOCK_EXEC(self.classJoinBlock,ret,HomeworkFetch_Error);
                                  }
                              }else {
                                  self.totalUnfinish = [ret.property.totalUnfinish integerValue];
                                  BLOCK_EXEC(aCompleteBlock,[ret.page.totalCou intValue],ret.data,nil);
                                  BLOCK_EXEC(self.classJoinBlock,ret,HomeworkFetch_Success);
                              }
                          }];
}

- (void)stop
{
    [self.request stopRequest];
}

@end
