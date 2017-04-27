//
//  YXHomeworkListFetcher.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/2/18.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXHomeworkListFetcher.h"
#import "YXHomeworkListRequest.h"

@interface YXHomeworkListFetcher ()

@property (nonatomic, strong) YXHomeworkListRequest *listRequest;

@end

@implementation YXHomeworkListFetcher

- (void)startWithBlock:(void(^)(int total, NSArray *retItemArray, NSError *error))aCompleteBlock
{
    [self.listRequest stopRequest];
    self.listRequest = [[YXHomeworkListRequest alloc] init];
    self.listRequest.groupId = self.gid;
    self.listRequest.pageSize = [NSString stringWithFormat:@"%@", @(self.pagesize)];
    self.listRequest.page = [NSString stringWithFormat:@"%@", @(self.pageindex+1)];
    [self.listRequest startRequestWithRetClass:[YXHomeworkListItem class]
                              andCompleteBlock:^(id retItem, NSError *error) {
                                  YXHomeworkListItem *ret = retItem;
                                  if (error) {
                                      aCompleteBlock(0, nil, error);
                                      return;
                                  }
                                  aCompleteBlock([ret.page.totalCou intValue], ret.data, nil);
                              }];
}

@end
