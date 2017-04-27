//
//  YXSubmitQuestionRequest.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/10.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXSubmitQuestionRequest.h"

//NSString *const YXSubmitQuestionSuccessNotification = @"kYXSubmitQuestionSuccessNotification";

@implementation YXSubmitQuestionRequestItem

@end

@implementation YXAnswersItem_PaperDetail
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"paperDetailId":@"id"}];
}
@end

@implementation YXAnswersItem_PaperStatus
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"paperStatusId":@"id"}];
}
@end

@implementation YXAnswersItem

@end

@implementation YXSubmitQuestionRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"app/q/submitQ.do"];
    }
    return self;
}

@end
