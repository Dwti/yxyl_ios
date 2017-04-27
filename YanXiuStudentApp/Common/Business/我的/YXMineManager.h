//
//  YXMineManager.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/9.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

// 学段
typedef NS_ENUM(NSInteger, YXStageType) {
    YXStageTypePrimarySchool = 1202,    //小学
    YXStageTypeJuniorHighSchool = 1203, //初中
    YXStageTypeSeniorHighSchool = 1204  //高中
};

typedef NS_ENUM(NSInteger, YXSexType) {
    YXSexTypeWoman = 1,   //女
    YXSexTypeMan = 2      //男
};

// 我的数据管理
@interface YXMineManager : NSObject

// 性别Id及名称
+ (NSArray *)sexIds;
+ (NSArray *)sexNames;
+ (NSUInteger)indexWithSexId:(NSString *)sexId;

// 学段Id及名称
+ (NSArray *)stageIds;
+ (NSArray *)stageNames;
+ (NSUInteger)indexWithStageId:(NSString *)stageId;

@end
