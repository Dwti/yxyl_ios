//
//  YXApnsContentModel.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 10/9/15.
//  Copyright © 2015 yanxiu.com. All rights reserved.
//

#import "YXApnsContentModel.h"

@implementation YXApnsContentModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"uid"       : @"id",
                                                                  }];
}


@end
 
