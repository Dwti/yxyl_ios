//
//  YXMineManager.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/9.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXMineManager.h"

@implementation YXMineManager

#pragma mark - 性别

+ (NSArray *)sexIds
{
    return @[[self stringWithType:YXSexTypeMan],
             [self stringWithType:YXSexTypeWoman],
              [self stringWithType:YXSexTypeUnknown]];
}

+ (NSArray *)sexNames
{
    return @[@"男生", @"女生" ,@"保密"];
}

+ (NSUInteger)indexWithSexId:(NSString *)sexId
{
    if (![[self sexIds] containsObject:sexId]) {
        return 2;
    }
    NSUInteger index = [[self sexIds] indexOfObject:sexId];
    return index;
}

#pragma mark - 学段

+ (NSArray *)stageIds
{
    return @[[self stringWithType:YXStageTypePrimarySchool],
             [self stringWithType:YXStageTypeJuniorHighSchool],
             [self stringWithType:YXStageTypeSeniorHighSchool]];
}

+ (NSArray *)stageNames
{
    return @[@"小学", @"初中", @"高中"];
    //return @[@"初中", @"高中"];
}

+ (NSUInteger)indexWithStageId:(NSString *)stageId
{
    NSUInteger index = [[self stageIds] indexOfObject:stageId];
    if (index == NSNotFound) {
        index = 0;
    }
    return index;
}

#pragma mark - 声音开关
+ (NSArray *)soundSwitchStates {
    return @[
             [self stringWithType:YXSoundSwitchStateOn],
             [self stringWithType:YXSoundSwitchStateOff]
             ];
}

+ (NSUInteger)indexWithSoundSwitchState:(NSString *)soundSwitchState {
    NSUInteger index = [[self soundSwitchStates] containsObject:soundSwitchState] ? [[self soundSwitchStates] indexOfObject:soundSwitchState] : 0;
    return index;
}

#pragma mark -

+ (NSString *)stringWithType:(NSInteger)type
{
    return [NSString stringWithFormat:@"%@", @(type)];
}

@end
