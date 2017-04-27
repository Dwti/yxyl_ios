//
//  YXQATimer.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/19.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXQATimer : NSObject

@property (nonatomic, assign) NSTimeInterval timePassed;
+ (instancetype)sharedInstance;

/**
 *  启动答题的计时器
 *
 *  @param interval     计时刷新间隔
 *  @param triggerBlock 答题用时的字符串形式
 */
+ (void)startWithInterval:(NSTimeInterval)interval triggerBlock:(void(^)(NSString *timeUsedString))triggerBlock;

/**
 *  停止答题计时
 */
+ (void)stop;

@end
