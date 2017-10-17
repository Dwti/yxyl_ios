//
//  GCDTimer.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/5.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "GCDTimer.h"

@interface GCDTimer()
@property (nonatomic, strong) dispatch_source_t timerSource;
@property (nonatomic, strong) void(^triggerBlock) (void);
@end

@implementation GCDTimer

- (void)dealloc {
//    [self suspend];
    dispatch_source_cancel(self.timerSource);
}

- (instancetype)initWithInterval:(NSTimeInterval)interval repeats:(BOOL)repeats triggerBlock:(void(^)(void))triggerBlock {
    if (self = [super init]) {
        self.triggerBlock = triggerBlock;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        self.timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        uint64_t timerInterval = interval * NSEC_PER_SEC;
        if (!repeats) {
            timerInterval = DISPATCH_TIME_FOREVER;
        }
        dispatch_source_set_timer(self.timerSource, dispatch_walltime(NULL, 0), timerInterval, 0.0f);
        WEAK_SELF
        dispatch_source_set_event_handler(self.timerSource, ^{
            STRONG_SELF
            [self sendTriggerEvent];
        });
    }
    
    return self;
}

- (void)sendTriggerEvent {
    dispatch_async(dispatch_get_main_queue(), ^{
        BLOCK_EXEC(self.triggerBlock);
    });
}

- (void)resume {
    dispatch_resume(self.timerSource);
}

- (void)suspend {
    dispatch_suspend(self.timerSource);
}

@end
