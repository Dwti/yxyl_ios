//
//  YXSubjectConstants.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/3/18.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXSubjectConstants.h"

@implementation YXSubjectConstants

+ (NSString *)subjectNameWithType:(YXSubjectType)type
{
    switch (type) {
        case YXSubjectTypeChinese:
            return @"语文";
        case YXSubjectTypeMath:
            return @"数学";
        case YXSubjectTypeEnglish:
            return @"英语";
        case YXSubjectTypePhysics:
            return @"物理";
        case YXSubjectTypeChemistry:
            return @"化学";
        case YXSubjectTypeBiology:
            return @"生物";
        case YXSubjectTypeGeography:
            return @"地理";
        case YXSubjectTypePolitics:
            return @"政治";
        case YXSubjectTypeHistory:
            return @"历史";
        default:
            return @"其它";
    }
}

@end
