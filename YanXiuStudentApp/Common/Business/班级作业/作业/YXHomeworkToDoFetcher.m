//
//  YXHomeworkToDoFetcher.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/2/18.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXHomeworkToDoFetcher.h"
#import "YXHomeworkToDoListRequest.h"

@interface YXHomeworkToDoFetcher ()

@property (nonatomic, strong) YXHomeworkToDoListRequest *toDoListRequest;

@end

@implementation YXHomeworkToDoFetcher

- (void)startWithBlock:(void(^)(int total, NSArray *retItemArray, NSError *error))aCompleteBlock
{
    [self stop];
    self.toDoListRequest = [[YXHomeworkToDoListRequest alloc] init];
    self.toDoListRequest.pageSize = [NSString stringWithFormat:@"%@", @(self.pagesize)];
    self.toDoListRequest.page = [NSString stringWithFormat:@"%@", @(self.pageindex+1)];
    @weakify(self);
    [self.toDoListRequest startRequestWithRetClass:[YXHomeworkToDoListItem class]
                                  andCompleteBlock:^(id retItem, NSError *error) {
                                      @strongify(self);
                                      YXHomeworkToDoListItem *ret = retItem;
                                      if (error) {
                                          aCompleteBlock(0, nil, error);
                                          return;
                                      }
                                      
                                      if (ret.data.count == 0 && self.emptyBlock) {
                                          self.emptyBlock();
                                          return;
                                      }
                                      aCompleteBlock([ret.page.totalCou intValue], ret.data, nil);
                                  }];
}

- (void)stop
{
    [self.toDoListRequest stopRequest];
}

@end
