//
//  YXRedManager.h
//  YanXiuStudentApp
//
//  Created by 贾培军 on 16/4/12.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const YXRedNotification = @"YXRedNotification";

/**
 *  请求未完成作业的红点数
 */
@interface YXRedManager : NSObject

@property (nonatomic, strong) NSString *paperNum;

/**
 *  异步请求未完成作业
 */
+ (void)requestPendingHomeWorkNumber;

@end
