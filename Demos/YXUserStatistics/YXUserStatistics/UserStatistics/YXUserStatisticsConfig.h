//
//  YXUserStatisticsConfig.h
//  YXUserStatistics
//
//  Created by ChenJianjun on 16/5/26.
//  Copyright © 2016年 yanxiu. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const YXEventIdKey;

#pragma mark - PageEvents
extern NSString *const YXPageEventIdPrefix;

#pragma mark - ControlEvents
extern NSString *const YXControlEventIdPrefix;

#pragma mark - ParamsEvents
extern NSString *const YXParamsEventIdPrefix;

@interface YXUserStatisticsConfig : NSObject

///统计配置信息
+ (NSDictionary *)configPlist;
///判断事件Id是否有效
+ (BOOL)isValidEventId:(NSString *)eventId;

@end
