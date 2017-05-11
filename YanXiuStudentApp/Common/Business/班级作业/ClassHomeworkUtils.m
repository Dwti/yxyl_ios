//
//  ClassHomeworkUtils.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2016/12/20.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "ClassHomeworkUtils.h"

@implementation ClassHomeworkUtils
+ (BOOL)classNumberFormatIsCorrect:(NSString *)classNumber {
    NSString *classNum = [classNumber yx_stringByTrimmingCharacters];
    if ([classNum stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]].length) {
        return  NO;
    }else {
        return YES;
    }
}
+ (BOOL)classNumberLengthIsCorrect:(NSString *)classNumber {
    NSString *classNum = [classNumber yx_stringByTrimmingCharacters];
    if (
        ![classNum yx_isValidString]
        || classNum.length > 8
        || classNum.length < 6
        ) {
        return NO;
    }else {
        return YES;
    }
    
}

#pragma mark - new
+ (BOOL)isClassNumberValid:(NSString *)classNumber {
    return classNumber.length==8;
}

@end
