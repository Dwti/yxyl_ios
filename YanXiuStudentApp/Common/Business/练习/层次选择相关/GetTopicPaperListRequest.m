//
//  GetTopicPaperListRequest.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/10/18.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "GetTopicPaperListRequest.h"

@implementation GetTopicPaperListItem
@end

@implementation GetTopicPaperListRequest

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"topicId":@"id"}];
}

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"app/topic/getTopicPaperList.do"];
    }
    return self;
}
@end
