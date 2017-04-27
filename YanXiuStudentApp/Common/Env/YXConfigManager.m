//
//  YXConfigManager.m
//  YanXiuApp
//
//  Created by Lei Cai on 5/15/15.
//  Copyright (c) 2015 yanxiu. All rights reserved.
//

#import "YXConfigManager.h"
#import <OpenUDID.h>
#import <UIDevice+HardwareName.h>
#import "YXServerEnvHelper.h"

@implementation YXConfigManager

+ (YXConfigManager *)sharedInstance {
    NSAssert([YXConfigManager class] == self, @"Incorrect use of singleton : %@, %@", [YXConfigManager class], [self class]);
    static dispatch_once_t once;
    static YXConfigManager *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] initWithConfigFile:@"yxConfig"];
        [sharedInstance setupServerEnv];
#ifdef DEBUG
        [YXServerEnvHelper setupConfigrationForCurrentEnv:sharedInstance];
#endif
    });
    
    return sharedInstance;
}

- (id)initWithConfigFile:(NSString *)filename {
    NSString *filepath = [[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filepath];
    NSError *error = nil;
    self = [super initWithDictionary:dict error:&error];
    if (error) {
        // make sure works even without a config plist
        self = [super init];
    }
    return self;
}

- (void)setupServerEnv {
    NSString *envPath = [[NSBundle mainBundle]pathForResource:@"env_config" ofType:@"json"];
    NSData *envData = [NSData dataWithContentsOfFile:envPath];
    NSDictionary *envDic = [NSJSONSerialization JSONObjectWithData:envData options:kNilOptions error:nil];
    self.server = [envDic valueForKey:@"server"];
    self.loginServer = [envDic valueForKey:@"loginServer"];
    self.uploadServer = [envDic valueForKey:@"uploadServer"];
    self.initializeUrl = [envDic valueForKey:@"initializeUrl"];
    self.mode = [envDic valueForKey:@"mode"];
    DDLogDebug(@"server env : %@",envDic);
}

#pragma mark - properties
- (NSString *)server {
    if ([_server hasSuffix:@"/"]) {
        return _server;
    } else {
        return [_server stringByAppendingString:@"/"];
    }
}

- (NSString *)loginServer
{
    if ([_loginServer hasSuffix:@"/"]) {
        return _loginServer;
    } else {
        return [_loginServer stringByAppendingString:@"/"];
    }
}

#pragma mark - network

- (NSString *)appName
{
    if (!_appName) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        _appName = [infoDictionary objectForKey:@"CFBundleName"];
    }
    return _appName;
}

- (NSString *)clientVersion
{
    if (!_clientVersion) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        _clientVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    }
    return _clientVersion;
}

- (NSString *)deviceID
{
    return [FCUUID uuidForDevice];    
//    if (!_deviceID) {
//        _deviceID = [OpenUDID value];
//    }
//    return _deviceID;
}

- (NSString *)deviceType
{
    if (!_deviceType) {
        _deviceType = [[UIDevice currentDevice] platform];
    }
    return _deviceType;
}

- (NSString *)osType {
    return @"ios";
}

- (NSString *)osVersion {
    return [UIDevice currentDevice].systemVersion;
}

- (NSString *)deviceName {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return @"iPad";
    } else {
        return @"iPhone";
    }
}

@end
