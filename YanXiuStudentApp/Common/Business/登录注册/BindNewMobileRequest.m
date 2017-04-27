//
//  BindNewMobileRequest.m
//  YanXiuStudentApp
//
//  Created by FanYu on 1/4/2017.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "BindNewMobileRequest.h"

@implementation BindNewMobileRequest
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"mobile" : @"newMobile",
                                                                  }];
}

- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].loginServer stringByAppendingString:@"app/user/bindNewMobile.do"];
    }
    return self;
}
@end
