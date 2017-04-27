//
//  QAQuestionUtil.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/9/13.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QAQuestionUtil : NSObject
+ (NSString *)stringByReplacingUnderlineInsideParentheses:(NSString *)string template:(NSString*)template;
+ (NSString *)stemByAddingIndexNumber:(NSInteger)index inFrontOfStem:(NSString *)stem;
+ (NSString *)answerPlaceholderWithQuestion:(QAQuestion *)data maxLength:(CGFloat)maxLength;
+ (NSString *)stemByReplacingUnderlineInsideParenthesesWithIndexNumber:(NSString *)stem;
@end
