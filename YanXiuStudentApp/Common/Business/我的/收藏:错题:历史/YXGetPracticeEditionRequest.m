//
//  YXGetPracticeEditionRequest.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/13.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXGetPracticeEditionRequest.h"

@implementation GetPracticeEditionRequestItem_subject_edition

@end

@implementation GetPracticeEditionRequestItem_subject
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"subjectID":@"id",
                                                                  @"edition":@"data"
                                                                  }];
}
@end

@implementation GetPracticeEditionRequestItem
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"subjects":@"data"}];
}
@end

@implementation YXGetPracticeEditionRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"app/personalData/getPracticeEdition.do"];
    }
    return self;
}

@end
