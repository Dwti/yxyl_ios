//
//  YXUserStatistics.h
//  YXUserStatistics
//
//  Created by ChenJianjun on 16/5/26.
//  Copyright © 2016年 yanxiu. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 上传统计数据类
@interface YXUserStatistics : NSObject

/// 初始化配置
+ (void)config;
/// 进入页面
+ (void)enterPageViewWithPageId:(NSString *)pageId;
/// 离开页面
+ (void)leavePageViewWithPageId:(NSString *)pageId;
/// 事件操作
+ (void)sendActionWithEventId:(NSString *)eventId;
/// 参数数据
+ (void)sendDataWithParams:(NSDictionary *)params;

@end
