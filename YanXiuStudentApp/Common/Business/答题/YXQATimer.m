//
//  YXQATimer.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/19.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQATimer.h"

@interface YXQATimer()
@property (nonatomic, assign) NSTimeInterval interval;
@property (nonatomic, copy) void(^triggerBlock)(NSString *timeUsedString);
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL isWorking;
@end

@implementation YXQATimer

+ (instancetype)sharedInstance
{
    static YXQATimer *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[YXQATimer alloc] init];
        [sharedInstance setupObservers];
    });
    return sharedInstance;
}

+ (void)startWithInterval:(NSTimeInterval)interval triggerBlock:(void(^)(NSString *timeUsedString))triggerBlock{
    [YXQATimer sharedInstance].interval = interval;
    [YXQATimer sharedInstance].triggerBlock = triggerBlock;
    [YXQATimer stop];
    [[YXQATimer sharedInstance] startTimer];
    [YXQATimer sharedInstance].isWorking = YES;
}

+ (void)stop{
    [[YXQATimer sharedInstance] stopTimer];
    [YXQATimer sharedInstance].isWorking = NO;
}

#pragma mark -
- (void)startTimer{
    self.timer = [NSTimer timerWithTimeInterval:self.interval target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)timerAction{
    self.timePassed += self.interval;
    NSString *timePassedString = [self stringFromTime:self.timePassed];
    if (self.triggerBlock) {
        self.triggerBlock(timePassedString);
    }
}

- (NSString *)stringFromTime:(NSTimeInterval)time {
    int minute = time/60;
    int second = time - minute*60;
    return [NSString stringWithFormat:@"%02d:%02d", minute, second];
}

#pragma mark - Notifications
- (void)setupObservers{
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UIApplicationWillResignActiveNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        if (self.isWorking) {
            [self stopTimer];
        }
    }];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UIApplicationDidBecomeActiveNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        if (self.isWorking) {
            [self startTimer];
        }
    }];
}

@end
