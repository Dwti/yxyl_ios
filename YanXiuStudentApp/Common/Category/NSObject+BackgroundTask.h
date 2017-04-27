//
//  NSObject+BackgroundTask.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/1/6.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (BackgroundTask)
- (void)performBackgroundTaskWithBlock:(void(^)())taskBlock completeBlock:(void(^)())completeBlock;
@end
