//
//  YXUserStatisticsConfig.m
//  YXUserStatistics
//
//  Created by ChenJianjun on 16/5/26.
//  Copyright © 2016年 yanxiu. All rights reserved.
//

#import "YXUserStatisticsConfig.h"

NSString *const YXEventIdKey = @"event_id_key";

#pragma mark - PageEvents
NSString *const YXPageEventIdPrefix = @"PAGE_EVENT";

#pragma mark - ControlEvents
NSString *const YXControlEventIdPrefix = @"CTRL_EVENT";

#pragma mark - ParamsEvents
NSString *const YXParamsEventIdPrefix = @"PARAMS_EVENT";

static NSDictionary *configPlistDict;

@implementation YXUserStatisticsConfig

+ (NSDictionary *)configPlist
{
    if (!configPlistDict) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"YXUserStatisticsConfig" ofType:@"plist"];
        configPlistDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    }
    return configPlistDict;
}

+ (BOOL)isValidEventId:(NSString *)eventId
{
    if ([eventId hasPrefix:YXPageEventIdPrefix]
        || [eventId hasPrefix:YXControlEventIdPrefix]
        || [eventId hasPrefix:YXParamsEventIdPrefix]) {
        return YES;
    }
    return NO;
}

@end
