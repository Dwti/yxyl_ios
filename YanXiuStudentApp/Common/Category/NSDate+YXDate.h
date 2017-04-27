//
//  NSDate+YXDate.h
//  YanXiuApp
//
//  Created by ChenJianjun on 15/6/9.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (YXDate)

+ (NSString *)yx_currentDate;

@end

@interface NSDateFormatter (YXDateFormatter)

+ (NSDateFormatter *)yx_cachedDateFormatter:(NSString *)stringDateFormatter;

@end