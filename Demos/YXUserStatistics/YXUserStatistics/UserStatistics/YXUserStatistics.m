//
//  YXUserStatistics.m
//  YXUserStatistics
//
//  Created by ChenJianjun on 16/5/26.
//  Copyright © 2016年 yanxiu. All rights reserved.
//

#import "YXUserStatistics.h"

@implementation YXUserStatistics

+ (void)config
{
    
}

+ (void)enterPageViewWithPageId:(NSString *)pageId
{
    NSLog(@"===进入页面：%@===", pageId);
}

+ (void)leavePageViewWithPageId:(NSString *)pageId
{
    NSLog(@"===离开页面：%@===", pageId);
}

+ (void)sendActionWithEventId:(NSString *)eventId
{
    NSLog(@"===操作事件：%@===", eventId);
}

+ (void)sendDataWithParams:(NSDictionary *)params
{
    NSLog(@"===参数数据：%@===", params);
}

@end
