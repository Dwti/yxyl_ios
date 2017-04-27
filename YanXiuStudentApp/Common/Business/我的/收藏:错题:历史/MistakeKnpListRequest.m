//
//  MistakeKnpListRequest.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 3/31/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "MistakeKnpListRequest.h"


@implementation MistakeKnpListRequestItem_knp
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"knpID" : @"id",
                                                                  @"count" : @"question_num"
                                                                  }];
}
- (NSArray *)subNodes {
    return self.children;
}

- (void)setSubNodes:(NSArray *)subNodes {
    self.children = (NSArray<MistakeKnpListRequestItem_knp, Optional> *)subNodes;
}
@end


@implementation MistakeKnpListRequestItem
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"knps":@"data"}];
}
@end


@implementation MistakeKnpListRequest
- (instancetype)init {
    self = [super init];
    if (self) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"app/q/getWrongQPointList.do"];
    }
    return self;
}
@end
