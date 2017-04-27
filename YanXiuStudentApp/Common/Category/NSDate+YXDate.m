//
//  NSDate+YXDate.m
//  YanXiuApp
//
//  Created by ChenJianjun on 15/6/9.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "NSDate+YXDate.h"
#import <objc/runtime.h>

static const char *kCachedDateFormattersKey;

@implementation NSDate (YXDate)

+ (NSString *)yx_currentDate
{
    NSDateFormatter *formatter = [NSDateFormatter yx_cachedDateFormatter:@"yyyy-MM-dd HH:mm"]; //:ss
    return [formatter stringFromDate:[NSDate date]];
}

@end

@implementation NSDateFormatter (YXDateFormatter)

+ (NSDateFormatter *)yx_cachedDateFormatter:(NSString *)stringDateFormatter
{
    NSMutableDictionary *cachedDictionary = objc_getAssociatedObject(self, &kCachedDateFormattersKey);
    if (!cachedDictionary) {
        objc_setAssociatedObject(self, &kCachedDateFormattersKey, [NSMutableDictionary dictionary], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        cachedDictionary = objc_getAssociatedObject(self, &kCachedDateFormattersKey);
    }
    NSDateFormatter *dateFormatter = [cachedDictionary objectForKey:[NSString stringWithFormat:@"cachedDateFormatter_%@",stringDateFormatter]];
    if (dateFormatter == nil) {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setCalendar:calendar];
        [dateFormatter setDateFormat:stringDateFormatter];
        [cachedDictionary setObject:dateFormatter forKey:[NSString stringWithFormat:@"cachedDateFormatter_%@",stringDateFormatter]];
    }
    return dateFormatter;
}

@end