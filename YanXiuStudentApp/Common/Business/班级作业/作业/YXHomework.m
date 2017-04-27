//
//  YXHomework.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/28.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXHomework.h"

@implementation YXHomework_PaperStatus

@end

@implementation YXHomework_Group

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"groupId":@"id"}];
}

@end

@implementation YXHomework

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"paperId": @"id"}];
}

- (BOOL)hasTeacherComments
{
    if ([self.paperStatus.teachercomments yx_isValidString]
        && [self.paperStatus.teacherName yx_isValidString]) {
        return YES;
    }
    return NO;
}
- (BOOL)shouldDisplayTheReport {
    if (self.showana.integerValue == 0) {
        return YES;
    }else {
        return NO;
    }
}
@end
