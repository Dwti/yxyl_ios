//
//  NSObject+YXUserStatistics.m
//  YXUserStatistics
//
//  Created by ChenJianjun on 16/5/30.
//  Copyright © 2016年 yanxiu. All rights reserved.
//

#import "NSObject+YXUserStatistics.h"
#import "YXUserStatistics.h"
#import "YXUserStatisticsConfig.h"

@implementation NSObject (YXUserStatistics)

- (void)sendUserStatisticsParams:(NSDictionary *)params
{
    NSString *paramsEventId = [self paramsEventId];
    if (params.count > 0 && paramsEventId) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
        dict[YXEventIdKey] = paramsEventId;
        [YXUserStatistics sendDataWithParams:dict];
    }
}

- (NSString *)paramsEventId
{
    NSDictionary *configDict = [YXUserStatisticsConfig configPlist];
    NSString *selfClassName = NSStringFromClass([self class]);
    NSString *methodName = @"sendUserStatisticsParams:";
    NSString *paramsEventId = configDict[selfClassName][methodName];
    if ([paramsEventId hasPrefix:YXParamsEventIdPrefix]) {
        return paramsEventId;
    }
    return nil;
}

@end
