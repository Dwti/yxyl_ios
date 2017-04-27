//
//  NSObject+YXUserStatistics.h
//  YXUserStatistics
//
//  Created by ChenJianjun on 16/5/30.
//  Copyright © 2016年 yanxiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (YXUserStatistics)

///传递参数统计
- (void)sendUserStatisticsParams:(NSDictionary *)params;

@end
