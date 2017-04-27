//
//  YXSubjectImageHelper.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/10.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXSubjectImageHelper.h"
#import "YXSubjectConstants.h"

@implementation YXSubjectImageHelper

+ (NSString *)smartExerciseImageNameWithType:(YXSubjectType)type
{
    NSString *subjectName = [YXSubjectConstants subjectNameWithType:type];
    return [NSString stringWithFormat:@"%@_a", subjectName];
}

+ (NSString *)homeworkImageNameWithType:(YXSubjectType)type
{
    NSString *subjectName = [YXSubjectConstants subjectNameWithType:type];
    return [NSString stringWithFormat:@"%@_b", subjectName];
}

+ (NSString *)myImageNameWithType:(YXSubjectType)type
{
    NSString *subjectName = [YXSubjectConstants subjectNameWithType:type];
    return [NSString stringWithFormat:@"%@_b", subjectName];
}

@end
