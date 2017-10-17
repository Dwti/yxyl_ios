//
//  NSObject+BackgroundTask.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/1/6.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "NSObject+BackgroundTask.h"

@implementation NSObject (BackgroundTask)

- (void)performBackgroundTaskWithBlock:(void(^)(void))taskBlock completeBlock:(void(^)(void))completeBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        taskBlock();
        if (completeBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completeBlock();
            });
        }
    });
}

@end
