//
//  GetTopicTreeRequest.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/10/18.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "GetTopicTreeRequest.h"

@implementation GetTopicTreeRequestItem_theme
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"themeId":@"id"
                                                                  }];
}
@end

@implementation GetTopicTreeRequestItem
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"themes":@"data"}];
}
@end


@implementation GetTopicTreeRequest
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"subjectId":@"id"}];
}
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"app/topic/getTopicTree.do"];
    }
    return self;
}
@end
