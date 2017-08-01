//
//  GetKnpListRequest.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/27.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "GetKnpListRequest.h"

@implementation GetKnpListRequestItem_knp_data

@end

@implementation GetKnpListRequestItem_knp
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"knpID":@"id"
                                                                  }];
}

- (NSArray *)subNodes{
    return self.children;
}

- (void)setSubNodes:(NSArray *)subNodes {
    self.children = (NSArray<GetKnpListRequestItem_knp,Optional> *)subNodes;
}

@end

@implementation GetKnpListRequestItem
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"knps":@"data"}];
}
@end

@implementation GetKnpListRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"app/anaofstd/listKnpStatNew.do"];
    }
    return self;
}

@end
