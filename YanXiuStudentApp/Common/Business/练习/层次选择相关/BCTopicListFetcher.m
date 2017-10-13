//
//  BCTopicListFetcher.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/10/15.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "BCTopicListFetcher.h"
#import "GetTopicPaperListRequest.h"

@interface BCTopicListFetcher ()

@property (nonatomic, strong) GetTopicPaperListRequest *listRequest;

@end

@implementation BCTopicListFetcher

- (void)startWithBlock:(void(^)(int total, NSArray *retItemArray, NSError *error))aCompleteBlock
{
    [self.listRequest stopRequest];
    self.listRequest = [[GetTopicPaperListRequest alloc] init];
    self.listRequest.type = self.type;
    self.listRequest.topicId = self.topicId;
    self.listRequest.order = self.order;
    self.listRequest.scope = self.scope;
    self.listRequest.pageSize = [NSString stringWithFormat:@"%@", @(self.pagesize)];
    self.listRequest.page = [NSString stringWithFormat:@"%@", @(self.pageindex+1)];
    [self.listRequest startRequestWithRetClass:[GetTopicPaperListItem class]
                              andCompleteBlock:^(id retItem, NSError *error) {
                                  GetTopicPaperListItem *ret = retItem;
                                  if (error) {
                                      aCompleteBlock(0, nil, error);
                                      return;
                                  }
                                  aCompleteBlock([ret.page.totalCou intValue], ret.data, nil);
                              }];
}

@end
