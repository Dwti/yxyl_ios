//
//  YXQuestionBlock.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/13.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXIntelligenceQuestion.h"

//@implementation YXIntelligenceQuestion_PaperTest_Extend
//
//@end
//
//@implementation YXIntelligenceQuestion_PaperTest_Extend_Data
//
//@end
//
//@implementation YXIntelligenceQuestion_PaperTest_Pad_TeacherCheck
//
//@end

@implementation YXIntelligenceQuestion_PaperStatus

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"paperstatusid":@"id"}];
}
@end

//@implementation YXIntelligenceQuestion_PaperTest_Pad
//
//+ (JSONKeyMapper *)keyMapper
//{
//    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"padid"}];
//}
//@end

@implementation YXIntelligenceQuestion_PaperTest

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"paperid":@"id"}];
}

- (void)clearMyAnswers {
    self.questions.pad.jsonAnswer = @[];
    for (YXIntelligenceQuestion_PaperTest *pt in self.questions.children) {
        [pt clearMyAnswers];
    }
}

@end

@implementation YXIntelligenceQuestion

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"qid":@"id"}];
}

- (NSTimeInterval)reportDuration
{
    NSTimeInterval interval = 0;
    for (YXIntelligenceQuestion_PaperTest *test in self.paperTest) {
        interval += test.questions.pad.costtime.doubleValue;
    }
    return interval;
}

@end

