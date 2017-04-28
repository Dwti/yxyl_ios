//
//  AppDelegate.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 6/30/15.
//  Copyright (c) 2015 yanxiu. All rights reserved.
//
static const BOOL kTestEntrance = NO;

#import "AppDelegate.h"
#import "YXTestViewController.h"
#import "UIResponder+FirstResponder.h"

#import "YXRedManager.h"
#import "YXRecordBase.h"
#import "YXRecordManager.h"

#import "YXGeTuiManager.h"
#import "YXSSOAuthManager.h"
#import "YXInitRequest.h"
#import "AppDelegateHelper.h"
#import "YXUpdateUserInfoRequest.h"
#import "LaunchAppItem.h"
#import "UIDevice+HardwareName.h"


@interface AppDelegate ()<YXApnsDelegate>
@property (nonatomic, strong) AppDelegateHelper *appDelegateHelper;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 基础配置
    [GlobalUtils setupCore];
    // 三方登录
    [[YXSSOAuthManager sharedManager] registerWXApp];
    [[YXSSOAuthManager sharedManager] registerQQApp];
    // Talking Data统计
    [TalkingData setExceptionReportEnabled:YES];
    [TalkingData setSignalReportEnabled:YES];
    [TalkingData sessionStarted:[YXConfigManager sharedInstance].TalkingDataAppID withChannelId:[YXConfigManager sharedInstance].channel];
    // 初始化请求，检测版本更新等
    [[YXInitHelper sharedHelper] requestCompeletion:nil];
    // 内部统计
    [YXRecordManager startRegularReport];
    [self addLaunchAppStatisticWithType:YXRecordStartType];
    // 推送
    [[YXGeTuiManager sharedInstance] registerGeTuiWithDelegate:self];
    // 未完成作业红点
    [YXRedManager requestPendingHomeWorkNumber];
    
    // 首次启动 数据统计
    [self firstTimeLaunchAppStatistic];
    
    [self setupTricks];
    [self registerNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.appDelegateHelper = [[AppDelegateHelper alloc]initWithWindow:self.window];
    
    if (kTestEntrance) {
        YXTestViewController *vc = [[YXTestViewController alloc] init];
        self.window.rootViewController = [[YXNavigationController alloc] initWithRootViewController:vc];
    }else{
        self.window.rootViewController = [self.appDelegateHelper rootViewController];
    }
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)setupTricks {
    [YXLoadingView aspect_hookSelector:@selector(startLoading) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated) {
        [[UIResponder currentFirstResponder] resignFirstResponder];
    } error:NULL];
}

- (void)registerNotifications {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:YXUserLoginSuccessNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        [YXRedManager requestPendingHomeWorkNumber];
        [[YXGeTuiManager sharedInstance] loginSuccess];
        [self.appDelegateHelper handleLoginSuccess];
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:YXUserLogoutSuccessNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        [[YXGeTuiManager sharedInstance] logoutSuccess];
        [self.appDelegateHelper handleLogoutSuccess];
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:YXUpdateUserInfoSuccessNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = x;
        NSDictionary *userInfo = noti.userInfo;
        if ([[userInfo objectForKey:YXUpdateUserInfoTypeKey] integerValue] == YXUpdateUserInfoTypeStage) {
            [self.appDelegateHelper handleStageChange];
        }
    }];

    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:YXTokenInValidNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        [[YXUserManager sharedManager] logout];
        [[UIApplication sharedApplication].keyWindow.rootViewController yx_showToast:@"帐号授权已失效，请重新登录"];
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [YXRecordManager addRecordWithType:YXRecordBackgroundType];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [YXRecordManager addRecordWithType:YXRecordActiveType];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [YXRecordManager addRecordWithType:YXRecordQuitType];
    [GlobalUtils clearCore];
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [GeTuiSdk resume]; // 后台恢复SDK 运行
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[YXGeTuiManager sharedInstance] registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    DDLogError(@"%@",[NSString stringWithFormat: @"Error: %@",err]);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    [[YXGeTuiManager sharedInstance] handleApnsContent:userInfo];
    application.applicationIconBadgeNumber -= 1;
    completionHandler(UIBackgroundFetchResultNewData);
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [YXSSOAuthManager handleOpenURL:url];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
   
}

// 9.0
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    return [YXSSOAuthManager handleOpenURL:url];
}

#pragma mark - Apns Delegate
- (void)apnsHomeworkList:(YXApnsContentModel *)apns {
    [self.appDelegateHelper apnsGoHomeworkList:apns];
}

- (void)apnsHomework:(YXApnsContentModel *)apns {
    [self.appDelegateHelper apnsGoHomework:apns];
}

#pragma mark - First time app launch
- (void)firstTimeLaunchAppStatistic {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [self addLaunchAppStatisticWithType:YXRecordLaunchType];
    }
}

- (void)addLaunchAppStatisticWithType:(YXRecordType)type {
    LaunchAppItem *record = [[LaunchAppItem alloc] init];
    record.type = type;
    record.mobileModel = [[UIDevice currentDevice] platformString];
    record.brand = @"Apple";
    record.system = [UIDevice currentDevice].systemVersion;
    record.resolution = [LaunchAppItem screenResolution];
    record.netModel = [LaunchAppItem networkStatus];
    
    [YXRecordManager addRecord:record];
}

@end
