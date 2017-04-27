//
//  QAQuestionTemplateMappingTable.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/9/14.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAQuestionTemplateMappingTable.h"

@implementation QAQuestionTemplateMappingTable
+ (YXQATemplateType)templateTypeForTemplate:(NSString *)templateString{
    NSDictionary *mappingDic = @{@"choice":@(YXQATemplateSingleChoose),
                                        @"multi-choice":@(YXQATemplateMultiChoose),
                                        @"fill":@(YXQATemplateFill),
                                        @"alter":@(YXQATemplateYesNo),
                                        @"connect":@(YXQATemplateConnect),
                                        @"classify":@(YXQATemplateClassify),
                                        @"answer":@(YXQATemplateSubjective),
                                        @"multi":@(YXQATemplateReadComplex),
                                        @"cloze":@(YXQATemplateClozeComplex),
                                        @"listen":@(YXQATemplateListenComplex)};
    NSNumber *number = [mappingDic valueForKey:templateString];
    if (number) {
        return number.integerValue;
    }
    return YXQATemplateUnknown;
}
@end
