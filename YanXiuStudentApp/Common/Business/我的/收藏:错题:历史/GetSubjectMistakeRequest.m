//
//  GetSubjectMistakeRequest.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2016/11/1.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "GetSubjectMistakeRequest.h"
@implementation GetSubjectMistakeRequestItem_subjectMistake_data
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"wrongQuestionsCount":@"wrongNum",}];
}
@end

@implementation GetSubjectMistakeRequestItem_subjectMistake
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"subjectID":@"id"}];
}
@end

@implementation GetSubjectMistakeRequestItem
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"subjectMistakes":@"data"}];
}
@end

@implementation GetSubjectMistakeRequest
//- (NSString *)stageId {
//    return @"0";//server端要求传0
//}
- (instancetype)init {
    if (self = [super init]) {
             self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"app/personalData/getSubjectMistakeV2.do"];
    }
    return self;
}
@end
