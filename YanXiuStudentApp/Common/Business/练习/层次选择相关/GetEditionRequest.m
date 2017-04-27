//
//  GetEditionRequest.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/25.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "GetEditionRequest.h"

@implementation GetEditionRequestItem_edition_data

@end

@implementation GetEditionRequestItem_edition_volume
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"volumeID":@"id"}];
}
@end

@implementation GetEditionRequestItem_edition
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"editionID":@"id",
                                                                  @"volumes":@"children"
                                                                  }];
}
@end

@implementation GetEditionRequestItem
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"editions":@"data"}];
}
@end

@implementation GetEditionRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"app/common/getEditions.do"];
    }
    return self;
}
@end
