//
//  UIControl+YXUserStatistics.m
//  YXUserStatistics
//
//  Created by ChenJianjun on 16/5/26.
//  Copyright © 2016年 yanxiu. All rights reserved.
//

#import "UIControl+YXUserStatistics.h"
#import "NSObject+YXHookMethod.h"
#import "YXUserStatistics.h"
#import "YXUserStatisticsConfig.h"

@implementation UIControl (YXUserStatistics)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(sendAction:to:forEvent:);
        SEL swizzledSelector = @selector(swiz_sendAction:to:forEvent:);
        [self swizzlingInClass:[self class]
              originalSelector:originalSelector
              swizzledSelector:swizzledSelector];
    });
}

- (void)swiz_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    //事件统计
    [self performUserStatisticsAction:action to:target forEvent:event];
    [self swiz_sendAction:action to:target forEvent:event];
}

- (void)performUserStatisticsAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    NSString *eventId = nil;
    //只统计触摸结束时操作
    if ([[[event allTouches] anyObject] phase] == UITouchPhaseEnded) {
        NSString *actionString = NSStringFromSelector(action);
        NSString *targetName = NSStringFromClass([target class]);
        eventId = [self controlEventIdWithTargetName:targetName
                                        actionString:actionString];
    }
    if (eventId) {
        [YXUserStatistics sendActionWithEventId:eventId];
    }
}

- (NSString *)controlEventIdWithTargetName:(NSString *)targetName
                              actionString:(NSString *)actionString
{
    NSDictionary *configDict = [YXUserStatisticsConfig configPlist];
    NSString *eventId = configDict[targetName][actionString];
    if ([eventId hasPrefix:YXControlEventIdPrefix]) {
        return eventId;
    }
    return nil;
}

@end
