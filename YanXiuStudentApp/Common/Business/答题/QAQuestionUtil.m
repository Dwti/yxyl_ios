//
//  QAQuestionUtil.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/9/13.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAQuestionUtil.h"
#import "QAQuestion.h"

@implementation QAQuestionUtil
+ (NSString *)stringByReplacingUnderlineInsideParentheses:(NSString *)string template:(NSString*)template {
    NSString *pattern = @"\\(_\\)";
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    NSString *result = [reg stringByReplacingMatchesInString:string
                                                     options:NSMatchingReportCompletion
                                                       range:NSMakeRange(0, string.length)
                                                withTemplate:template];
    return result;
}
 
+ (NSString *)stemByAddingIndexNumber:(NSInteger)index inFrontOfStem:(NSString *)stem{
    return [NSString stringWithFormat:@"(%@) %@",@(index),stem];
}

+ (NSString *)answerPlaceholderWithQuestion:(QAQuestion *)data maxLength:(CGFloat)maxLength {
    NSString *space = @"-";
    NSDictionary *attrDic = @{NSFontAttributeName:[UIFont fontWithName:@"Times New Roman" size:15]};
    CGSize spaceSize = [space sizeWithAttributes:attrDic];
    CGFloat spaceWidth = ceilf(spaceSize.width);
    
    CGFloat maxAnswerWidth = 0;
    for (NSString *str in data.correctAnswers) {
        CGSize size = [str sizeWithAttributes:attrDic];
        if (size.width > maxAnswerWidth) {
            maxAnswerWidth = size.width;
        }
    }
    
    CGFloat minAnswerWidth = spaceWidth*10;
    CGFloat width = MIN(maxAnswerWidth+20, maxLength);
    width = MAX(width, minAnswerWidth);
    
    NSInteger spaceNum = width/spaceWidth;
    
    NSString *placeHolder = @"";
    for (NSInteger i = 0; i < spaceNum; i++) {
        placeHolder = [placeHolder stringByAppendingString:@"-"];
    }
    return placeHolder;
}

+ (NSString *)stemByReplacingUnderlineInsideParenthesesWithIndexNumber:(NSString *)stem{
    NSInteger index = 1;
    NSString *pattern = @"\\(_\\)";
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    
    NSString *finalStem = stem;
    NSTextCheckingResult *result = [reg firstMatchInString:finalStem options:NSMatchingReportCompletion range:NSMakeRange(0, finalStem.length)];
    while (result) {
        finalStem = [reg stringByReplacingMatchesInString:finalStem
                                                  options:NSMatchingReportCompletion
                                                    range:result.range
                                             withTemplate:[NSString stringWithFormat:@"(%@)____",@(index)]];
        result = [reg firstMatchInString:finalStem options:NSMatchingReportCompletion range:NSMakeRange(0, finalStem.length)];
        index++;
    }
    return finalStem;
}

@end
