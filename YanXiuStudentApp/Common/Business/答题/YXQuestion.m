//
//  YXQuestion.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/13.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXQuestion.h"
#import "QAQuestionTemplateMappingTable.h"

@implementation YXQuestion_Extend_Data

@end

@implementation YXQuestion_Extend

@end

@implementation YXQuestion_Pad_TeacherCheck

@end

@implementation YXQuestion_Pad_AudioComment

@end

@implementation YXQuestion_Pad
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"padid":@"id"}];
}
@end

@implementation YXQuestion_Content

@end

@implementation YXQuestion_Point

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"pid":@"id"}];
}

@end

@implementation YXQuestion_jsonNote
@end

@implementation YXQuestion

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"aid":@"id",@"qTemplate":@"template"}];
}

- (YXQAItemType)questionType{
    return self.type_id.integerValue;
}

- (YXQATemplateType)templateType{
    return [QAQuestionTemplateMappingTable templateTypeForTemplate:self.qTemplate];
}

- (NSString *)completeStem{
    if (self.identifierForTest.length > 0) {
        return [NSString stringWithFormat:@"%@--%@",self.identifierForTest,self.stem];
    }
    return self.stem;
}

@end
