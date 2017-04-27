//
//  YXUserManager.m
//  YanXiuApp
//
//  Created by ChenJianjun on 15/6/2.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXUserManager.h"

NSString *const YXUserLoginSuccessNotification = @"kYXUserLoginSuccessNotification";
NSString *const YXUserLogoutSuccessNotification = @"kYXUserLogoutSuccessNotification";

@implementation YXUserManager

+ (instancetype)sharedManager
{
    static YXUserManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YXUserManager alloc] init];
        [manager loadLocalUserData];
    });
    return manager;
}

- (void)saveUserData
{
    [NSKeyedArchiver archiveRootObject:self.userModel toFile:[self userDataPath]];
}

- (void)login
{
    [self saveUserData];
    [[NSNotificationCenter defaultCenter] postNotificationName:YXUserLoginSuccessNotification
                                                        object:nil];
}

- (void)logout
{
    [self resetUserData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:YXUserLogoutSuccessNotification
                                                        object:nil];
}

- (BOOL)isLogin
{
    return [self.userModel.passport.token yx_isValidString];
}

- (BOOL)isThirdLogin
{
    return [self.userModel.isThirdLogin boolValue];
}

- (void)setIsThirdLogin:(BOOL)isThirdLogin
{
    self.userModel.isThirdLogin = [NSString stringWithFormat:@"%@", @(isThirdLogin)];
}

- (BOOL)isRegisterByJoinClass {
    return [self.userModel.isRegisterByJoinClass boolValue];
}

- (void)setIsRegisterByJoinClass:(BOOL)registerByJoinClass {
    self.userModel.isRegisterByJoinClass = [NSString stringWithFormat:@"%@", @(registerByJoinClass)];
}

#pragma mark -

// 重置用户数据
- (void)resetUserData
{
    self.userModel = nil;
    [NSKeyedArchiver archiveRootObject:self.userModel toFile:[self userDataPath]];
    [self initUserModel];
}

- (void)loadLocalUserData
{
    NSString *userDataPath = [self userDataPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:userDataPath]) {
        self.userModel = [NSKeyedUnarchiver unarchiveObjectWithFile:userDataPath];
    }
    [self initUserModel];
}

- (NSString *)userDataPath
{
    return [NSString stringWithFormat:@"%@/userData.dat", [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]];
}

- (void)initUserModel
{
    if (!self.userModel) {
        self.userModel = [[YXUserModel alloc] init];
    }
}

@end
