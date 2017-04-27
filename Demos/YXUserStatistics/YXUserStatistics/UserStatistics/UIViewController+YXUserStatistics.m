//
//  UIViewController+YXUserStatistics.m
//  YXUserStatistics
//
//  Created by ChenJianjun on 16/5/26.
//  Copyright © 2016年 yanxiu. All rights reserved.
//

#import "UIViewController+YXUserStatistics.h"
#import "NSObject+YXHookMethod.h"
#import "YXUserStatistics.h"
#import "YXUserStatisticsConfig.h"

@implementation UIViewController (YXUserStatistics)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(swiz_viewWillAppear:);
        [self swizzlingInClass:[self class]
              originalSelector:originalSelector
              swizzledSelector:swizzledSelector];
        
        SEL originalSelector2 = @selector(viewWillDisappear:);
        SEL swizzledSelector2 = @selector(swiz_viewWillDisappear:);
        [self swizzlingInClass:[self class]
              originalSelector:originalSelector2
              swizzledSelector:swizzledSelector2];
    });
}

#pragma mark - Method Swizzling

- (void)swiz_viewWillAppear:(BOOL)animated
{
    //页面统计
    [self inject_viewWillAppear];
    [self swiz_viewWillAppear:animated];
}

- (void)swiz_viewWillDisappear:(BOOL)animated
{
    [self inject_viewWillDisappear];
    [self swiz_viewWillDisappear:animated];
}

- (void)inject_viewWillAppear
{
    NSString *pageId = [self pageEventId:YES];
    if (pageId) {
        [YXUserStatistics enterPageViewWithPageId:pageId];
    }
}

- (void)inject_viewWillDisappear
{
    NSString *pageId = [self pageEventId:NO];
    if (pageId) {
        [YXUserStatistics leavePageViewWithPageId:pageId];
    }
}

- (NSString *)pageEventId:(BOOL)bEnterPage
{
    NSDictionary *configDict = [YXUserStatisticsConfig configPlist];
    NSString *selfClassName = NSStringFromClass([self class]);
    NSString *methodName = @"viewWillDisappear:";
    if (bEnterPage) {
        methodName = @"viewWillAppear:";
    }
    NSString *pageEventId = configDict[selfClassName][methodName];
    if ([pageEventId hasPrefix:YXPageEventIdPrefix]) {
        return pageEventId;
    }
    return nil;
}

@end
