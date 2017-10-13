//
//  BCTopicPaper.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/10/18.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "BCTopicPaper.h"

@implementation BCTopicPaper_paperStatus
@end


@implementation BCTopicPaper
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"rmsPaperId": @"id"}];
}
@end
