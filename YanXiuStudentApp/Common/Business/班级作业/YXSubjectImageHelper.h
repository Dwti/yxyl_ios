//
//  YXSubjectImageHelper.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/10.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXSubjectConstants.h"

@interface YXSubjectImageHelper : NSObject

// 智能练习界面
+ (NSString *)smartExerciseImageNameWithType:(YXSubjectType)type;
// 作业界面
+ (NSString *)homeworkImageNameWithType:(YXSubjectType)type;
// 我的界面
+ (NSString *)myImageNameWithType:(YXSubjectType)type;

@end
