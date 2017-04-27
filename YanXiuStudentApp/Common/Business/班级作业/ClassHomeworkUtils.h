//
//  ClassHomeworkUtils.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2016/12/20.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassHomeworkUtils : NSObject
+ (BOOL)classNumberFormatIsCorrect:(NSString *)classNumber;
+ (BOOL)classNumberLengthIsCorrect:(NSString *)classNumber;
@end
