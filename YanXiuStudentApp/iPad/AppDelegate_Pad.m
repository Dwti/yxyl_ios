//
//  AppDelegate_Pad.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 1/13/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//
#import "YXLoginRequest.h"

static const BOOL kTestEntrance = NO;
#import "AppDelegate_Pad.h"
#import "YXTestViewController.h"
#import "YXSplitViewController.h"
#import "YXSideMenuViewController_Pad.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "YXNavigationController_Pad.h"
#import "YXAppStartupManager.h"

#import "YXLoginViewController_Pad.h"
#import "YXGuideViewController_Pad.h"

#import "YXExerciseChooseEditionViewController_Pad.h"
#import "YXSettingViewController_Pad.h"
#import "YXPersonInfoViewController_Pad.h"
#import "YXImagePickerController_Pad.h"
#import "YXHomeworkGroupViewController_Pad.h"
#import "YXRankViewController_Pad.h"

#import "YXGetSubjectRequest.h"
#import "YXGetEditionsRequest.h"
// 收藏、错题、练习历史
#import "YXMyFavorViewController_Pad.h"
#import "YXMyMistakeViewController_Pad.h"
#import "YXExerciseHistoryViewController_Pad.h"

#import "YXRedManager.h"
// Apns
#import "YXApnsContentModel.h"
#import "YXIntelligenceQuestion.h"
#import "YXApnsQAReportViewController_Pad.h"
#import "YXApnsHomeworkViewController_Pad.h"
#import "YXBaseWebViewController.h"
#import "YXRecordManager.h"

@interface AppDelegate_Pad () <YXApnsDelegate, YXLoginDelegate>
@property (nonatomic, strong) YXSideMenuViewController_Pad *menuVC;
@end

@implementation AppDelegate_Pad

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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [YXAppStartupManager sharedInstance].role = YXRoleStudent;
    [self setupUI];
    [YXRedManager requestPendingHomeWorkNumber];
    [[YXAppStartupManager sharedInstance] setupForAppdelegate:self withLauchOptions:launchOptions];
    [YXRecordManager startRegularReport];
    [YXRecordManager addRecordWithType:YXRecordStartType];
    return YES;
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window
{
    if ([YXImagePickerController_Pad instance].isShow) {
        return UIInterfaceOrientationMaskAll;
    } else {
        return UIInterfaceOrientationMaskLandscape;
    }
}

- (void)setupUI {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    if (kTestEntrance) {
        YXTestViewController *vc = [[YXTestViewController alloc] init];
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
    } else {
        [self resetUIAfterLogin];
    }
    
    [self.window makeKeyAndVisible];
}

- (void)resetUIAfterLogin {
    YXSplitViewController *splitVC = [[YXSplitViewController alloc]init];
    
    // 侧边栏
    _menuVC = [[YXSideMenuViewController_Pad alloc] init];
    _menuVC.delegate = splitVC;
    YXNavigationController_Pad *menuNavi = [[YXNavigationController_Pad alloc]initWithRootViewController:_menuVC];
    
    // 个人信息
    YXPersonInfoViewController_Pad *personalInfoVC = [[YXPersonInfoViewController_Pad alloc] init];
    YXNavigationController_Pad *personalInfoNavi = [[YXNavigationController_Pad alloc]initWithRootViewController:personalInfoVC];
    
    // 练习
    YXExerciseChooseEditionViewController_Pad *exerciseVC = [[YXExerciseChooseEditionViewController_Pad alloc] init];
    YXNavigationController_Pad *exerciseNavi = [[YXNavigationController_Pad alloc] initWithRootViewController:exerciseVC];
    
    // 班级作业
    YXHomeworkGroupViewController_Pad *homeworkVC = [[YXHomeworkGroupViewController_Pad alloc] init];
    YXNavigationController_Pad *homeworkNavi = [[YXNavigationController_Pad alloc]initWithRootViewController:homeworkVC];
    
    // 排行榜
    YXRankViewController_Pad *rankVC = [[YXRankViewController_Pad alloc] init];
    YXNavigationController_Pad *rankNavi = [[YXNavigationController_Pad alloc]initWithRootViewController:rankVC];
    rankNavi.navigationBarHidden = YES;
    
    // 我的收藏
//    YXMyFavorViewController_Pad *favorVC = [[YXMyFavorViewController_Pad alloc] init];
//    YXNavigationController_Pad *favorNavi = [[YXNavigationController_Pad alloc]initWithRootViewController:favorVC];
    
    // 我的错题
    YXMyMistakeViewController_Pad *mistakeVC = [[YXMyMistakeViewController_Pad alloc] init];
    YXNavigationController_Pad *mistakeNavi = [[YXNavigationController_Pad alloc]initWithRootViewController:mistakeVC];
    
    // 练习历史
    YXExerciseHistoryViewController_Pad *historyVC = [[YXExerciseHistoryViewController_Pad alloc] init];
    YXNavigationController_Pad *historyNavi = [[YXNavigationController_Pad alloc]initWithRootViewController:historyVC];
    
    // 设置
    YXSettingViewController_Pad *settingVC = [[YXSettingViewController_Pad alloc] init];
    YXNavigationController_Pad *settingNavi = [[YXNavigationController_Pad alloc]initWithRootViewController:settingVC];
    
    [splitVC setupWithLeftVC:menuNavi rightVCArray:@[
                                                     personalInfoNavi,
                                                     exerciseNavi,
                                                     homeworkNavi,
                                                     rankNavi,
//                                                     favorNavi,
                                                     mistakeNavi,
                                                     historyNavi,
                                                     settingNavi
                                                     ]];
    
    if ([[YXUserManager sharedManager] isLogin]) {
        YXNavigationController_Pad *navi = [[YXNavigationController_Pad alloc]initWithRootViewController:splitVC];
        navi.navigationBarHidden = YES;
        self.window.rootViewController = navi;
    } else {
        [self showLoginViewController];
    }
}

- (void)showLoginViewController
{
    UIViewController *vc = nil;
    if ([YXGuideViewController_Pad isGuideViewShowed]) {
        vc = [[YXLoginViewController_Pad alloc] init];
    } else {
        vc = [[YXGuideViewController_Pad alloc] init];
    }
    YXNavigationController_Pad *navigationController = [[YXNavigationController_Pad alloc] initWithRootViewController:vc];
    
    if (self.window.rootViewController) {
        [self.window.rootViewController presentViewController:navigationController animated:YES completion:nil];
    } else {
        self.window.rootViewController = navigationController;
    }
}

#pragma mark -

- (void)switchToTabIndex:(NSInteger)index
{
    [self.menuVC selectIndex:index];
}

#pragma mark - APNS

- (void)apnsHomeworkReport:(YXApnsContentModel *)apns paper:(YXIntelligenceQuestion *)paper {
    YXIntelligenceQuestion *q = paper;
    YXApnsQAReportViewController_Pad *vc = [[YXApnsQAReportViewController_Pad alloc] init];
    vc.pType = YXPTypeGroupHomework;
    
    YXQARequestParams *param = [[YXQARequestParams alloc] init];
    param.stageId = q.stageid;
    param.subjectId = q.subjectid;
    param.editionId = q.bedition;
    param.volumeId = q.volume;
    param.chapterId = q.chapterid;
    param.sectionId = q.sectionid;
    param.questNum = @"10";
    param.cellId = q.cellid;
    vc.model = [QAPaperModel modelFromRawData:q];
    vc.requestParams = param;

    if ([vc.model.questions count] == 0) {
        return;
    }
    
    YXNavigationController_Pad *navi = [[YXNavigationController_Pad alloc] initWithRootViewController:vc];
    [[self lastPresentedViewController] presentViewController:navi animated:YES completion:nil];
}

- (void)apnsHomeworkList:(YXApnsContentModel *)apns {
    YXApnsHomeworkViewController_Pad *vc = [[YXApnsHomeworkViewController_Pad alloc] init];
    vc.groupInfoData = [[YXHomeworkListGroupsItem_Data alloc] init];
    vc.groupInfoData.groupId = apns.uid;
    vc.title = apns.name;
    YXNavigationController_Pad *navi = [[YXNavigationController_Pad alloc] initWithRootViewController:vc];
    [[self lastPresentedViewController] presentViewController:navi animated:YES completion:nil];
}

- (void)apnsHomework:(YXApnsContentModel *)apns {
    
    [self switchToTabIndex:2];
}

- (void)apnsWebpage:(YXApnsContentModel *)apns {
    // check ok
    YXBaseWebViewController * webViewController = [[YXBaseWebViewController alloc] initWithUrlString:apns.name];
    webViewController.showType = WebViewshowType_Present;
    YXNavigationController_Pad *navi = [[YXNavigationController_Pad alloc] initWithRootViewController:webViewController];
    [[self lastPresentedViewController] presentViewController:navi animated:YES completion:nil];
}

- (UIViewController *)lastPresentedViewController
{
    UIViewController *vc = self.window.rootViewController;
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
    }
    return vc;
}

#pragma mark - YXLoginDelegate

- (void)userLogoutSuccess
{
    [[YXGetSubjectManager sharedManager] clearCache];
    [[YXGetEditionsManager sharedManager] clearCache];
    [self showLoginViewController];
}

- (void)userLoginSuccess
{
    [self resetUIAfterLogin];
}

@end


/**
 *  这个类是需要转移到YXAppStartupManager中的方法的集合
 */
@interface AppDelegate_Pad (ApiStubForTransfer)

@end

@implementation AppDelegate_Pad (ApiStubForTransfer)
- (void)applicationWillTerminate:(UIApplication *)application {
    [YXRecordManager addRecordWithType:YXRecordQuitType];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler{
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo {
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return NO;
}

// 9.0
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    return NO;
}

@end
