//
//  YXServerEnvHelper.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/8/22.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXServerEnvHelper.h"

@interface EnvConfig : JSONModel
@property (nonatomic, strong) NSString<Optional> *server;
@property (nonatomic, strong) NSString<Optional> *loginServer;
@property (nonatomic, strong) NSString<Optional> *uploadServer;
@property (nonatomic, strong) NSString<Optional> *initializeUrl;
@property (nonatomic, strong) NSString<Optional> *mode;
@end
@implementation EnvConfig

@end

@implementation YXServerEnvHelper

+ (void)setServerEnv:(YXServerEnv)env{
    NSString *value = nil;
    if (env == YXServerEnv_Test) {
        value = @"test";
    }else if (env == YXServerEnv_Dev){
        value = @"dev";
    }else if (env == YXServerEnv_Rel){
        value = @"rel";
    }
    [[NSUserDefaults standardUserDefaults]setValue:value forKey:@"kYXServerEnvKey"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+ (YXServerEnv)currentEnv{
    NSString *value = [[NSUserDefaults standardUserDefaults]valueForKey:@"kYXServerEnvKey"];
    if ([value isEqualToString:@"test"]) {
        return YXServerEnv_Test;
    }
    if ([value isEqualToString:@"dev"]) {
        return YXServerEnv_Dev;
    }
    if ([value isEqualToString:@"rel"]) {
        return YXServerEnv_Rel;
    }
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"env_config" ofType:@"json"];
    NSString *json = [[NSString alloc]initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    EnvConfig *config = [[EnvConfig alloc]initWithString:json error:nil];
    if ([config.server isEqualToString:@"http://test.hwk.yanxiu.com/"]) {
        return YXServerEnv_Test;
    }
    if ([config.server isEqualToString:@"http://dev.hwk.yanxiu.com/"]) {
        return YXServerEnv_Dev;
    }
    return YXServerEnv_Rel;
}

+ (void)setupConfigrationForCurrentEnv:(YXConfigManager *)manager{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"yxConfig" ofType:@"plist"];
    NSDictionary *contentDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSDictionary *serverList = contentDic[@"serverList"];
    NSString *testServer = [serverList valueForKey:@"TestServer"];
    NSString *devServer = [serverList valueForKey:@"DevServer"];
    NSString *relServer = [serverList valueForKey:@"RelServer"];
    
    YXServerEnv env = [self currentEnv];
    if (env == YXServerEnv_Test) {
        manager.server = testServer;
        manager.loginServer = testServer;
    }else if (env == YXServerEnv_Dev){
        manager.server = devServer;
        manager.loginServer = devServer;
    }else if (env == YXServerEnv_Rel){
        manager.server = relServer;
        manager.loginServer = relServer;
    }
}



@end
