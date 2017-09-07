//
//  GetVolumesRequest.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/9/12.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "GetVolumesRequest.h"

@implementation GetVolumesRequestItem_volume
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"volumeID":@"id"
                                                                  }];
}
@end

@implementation GetVolumesRequestItem
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"volumes":@"data"}];
}
@end

@implementation GetVolumesRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"app/common/getVolumes.do"];
    }
    return self;
}
@end
