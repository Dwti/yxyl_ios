//
//  YXServerEnvHelper.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/8/22.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, YXServerEnv) {
    YXServerEnv_Test,
    YXServerEnv_Dev,
    YXServerEnv_Rel,
    YXServerEnv_None
};

@interface YXServerEnvHelper : NSObject
+ (void)setServerEnv:(YXServerEnv)env;
+ (YXServerEnv)currentEnv;
+ (void)setupConfigrationForCurrentEnv:(YXConfigManager *)manager;
@end
