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
#import "YXLoginViewController.h"
#import "YXGuideViewController.h"

#import "YXIntelligenceQuestion.h"
#import "YXApnsQAReportViewController.h"
#import "YXApnsHomeworkViewController.h"
#import "YXBaseWebViewController.h"

#import "YXApnsContentModel.h"
#import "UIResponder+FirstResponder.h"
#import "YXAppStartupManager.h"

#import "YXRoleSelectionViewController_Phone.h"
#import "YXTestLogoutViewController_Phone.h"
#import "YXParentNavigationController_Phone.h"
#import "YXPHomePageViewController_Phone.h"
#import "YXPWeeklyViewController_Phone.h"
#import "YXPLoginViewController_Phone.h"

#import "YXHonorViewController_Phone.h"
#import "YXPPersonalViewController_Phone.h"
#import "YXHonorRedFlagRequest.h"
#import "YXRedManager.h"
#import "YXPCombineChildViewController_Phone.h"
#import "YXRecordBase.h"
#import "YXRecordManager.h"
#import "JPEngine.h"
#import "NSData+Datas.h"

#import "YXGeTuiManager.h"

@interface AppDelegate ()<YXApnsDelegate, YXLoginDelegate>

@property (nonatomic, strong) UITabBarController *tabBarController;
@property (nonatomic, strong) YXNavigationController *navigationController;

@property (nonatomic, strong) YXHonorRedFlagRequest *honorRedFlagRequest;
@property (nonatomic, assign) BOOL isBindVCShowing;
@end

@implementation AppDelegate

- (void)checkHonorRedFlag {
    [self.honorRedFlagRequest stopRequest];
    self.honorRedFlagRequest = [[YXHonorRedFlagRequest alloc] init];
    @weakify(self);
    [self.honorRedFlagRequest startRequestWithRetClass:[YXHonorRedFlagRequestItem class]
                                      andCompleteBlock:^(id retItem, NSError *error) {
                                          @strongify(self);
                                          YXHonorRedFlagRequestItem *item = (YXHonorRedFlagRequestItem *)retItem;
                                          if ([item.property.shouldShow boolValue]) {
                                              [self setTabBarItemBadgeAtIndex:2 hidden:NO];
                                          } else {
                                              [self setTabBarItemBadgeAtIndex:2 hidden:YES];
                                          }
                                      }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"Parent Read Honor Flag" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self setTabBarItemBadgeAtIndex:2 hidden:YES];
    }];
}

- (void)setTabBarItemBadgeAtIndex:(NSUInteger)index hidden:(BOOL)hidden {
    NSInteger tagBase = 8383;
    NSInteger tag = tagBase + index;
    UITabBarController *tabBarController = (UITabBarController *)(self.window.rootViewController);
    if (![tabBarController isKindOfClass:[UITabBarController class]]) {
        return;
    }
    
    for (UIView *v in tabBarController.tabBar.subviews) {
        if (v.tag == tag) {
            [v removeFromSuperview];
        }
    }
    
    if (!hidden) {
        UIView *reddotView = [[UIView alloc] init];
        reddotView.tag = tag;
        CGFloat x = ([UIScreen mainScreen].bounds.size.width / 4) * (index + 1) - 35;
        reddotView.frame = CGRectMake(x, 4, 8, 8);
        reddotView.layer.cornerRadius = 4;
        reddotView.backgroundColor = [UIColor redColor];
        [tabBarController.tabBar addSubview:reddotView];
    }
}

#pragma mark- JSPatch
- (void)JSPatchWithUrl:(NSString *)url
{
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [directoryPaths objectAtIndex:0];
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *file = [NSString stringWithFormat:@"%@.js", version];
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:file];
    NSString *script = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    if (script.length) {
        [JPEngine evaluateScript:script];
    }
    ASIHTTPRequest *asi = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    __weak ASIHTTPRequest *wAsi = asi;
    [asi setCompletionBlock:^{
        NSString *script = [[NSString alloc] initWithData:wAsi.responseData encoding:NSUTF8StringEncoding];
        if (script.length) {
            [script writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
    }];
    [asi setFailedBlock:^{
        NSLog(@"%@", wAsi.error);
    }];
    [asi startAsynchronous];
}

- (void)loadJSPatchURL
{
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    __block  NSString *urlStr = [[NSString stringWithFormat:@"https://api.leancloud.cn/1.1/classes/JSPatch?keys=-version,-ACL,-createdAt,-updatedAt,-objectId&where={\"version\":\"%@\"}", version] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSDictionary *headers = @{
                              @"X-LC-Id": @"G6VltVc9puBtkECnytYxv8p5-gzGzoHsz",
                              @"X-LC-Key": @"4rvpKczH9nkdEbJO3FXkvca9",
                              @"Content-Type": @"application/json",
                              };
    
    ASIHTTPRequest *asi = [ASIHTTPRequest requestWithURL:url];
    [asi setRequestHeaders:[headers mutableCopy]];
    __weak ASIHTTPRequest *wAsi = asi;
    WEAK_SELF
    [asi setCompletionBlock:^{
        STRONG_SELF
        NSDictionary *dicts = [wAsi.rawResponseData leanCloudDictionary];
        if (dicts[@"state"]) {
            NSString *urlStr = dicts[@"url"];
            [self JSPatchWithUrl:urlStr];
        }
    }];
    [asi startAsynchronous];
    
}

#pragma mark- setupUI
- (void)setupParentUI{
    YXPHomePageViewController_Phone *homeVC = [[NSClassFromString(@"YXPHomePageViewController_Phone") alloc] init];
    homeVC.title = @"首页";
    [self configTabbarItem:homeVC.tabBarItem image:@"首页2b" selectedImage:@"首页2a"];
    YXParentNavigationController_Phone *homeNavi = [[YXParentNavigationController_Phone alloc] initWithRootViewController:homeVC];
    
    YXPWeeklyViewController_Phone *reportVC = [[NSClassFromString(@"YXPWeeklyViewController_Phone") alloc] init];
    reportVC.title = @"周报";
    [self configTabbarItem:reportVC.tabBarItem image:@"周报-0b" selectedImage:@"周报-0a"];
    YXParentNavigationController_Phone *reportNavi = [[YXParentNavigationController_Phone alloc] initWithRootViewController:reportVC];
    
    UIViewController *honorVC = [[NSClassFromString(@"YXHonorViewController_Phone") alloc] init];
    honorVC.title = @"荣誉";
    [self configTabbarItem:honorVC.tabBarItem image:@"荣誉-0b" selectedImage:@"荣誉-0a"];
    YXParentNavigationController_Phone *honorNavi = [[YXParentNavigationController_Phone alloc] initWithRootViewController:honorVC];
    
    YXPPersonalViewController_Phone *mineVC = [[NSClassFromString(@"YXPPersonalViewController_Phone") alloc] init];
    mineVC.title = @"个人";
    [self configTabbarItem:mineVC.tabBarItem image:@"个人-0b" selectedImage:@"个人-0a"];
    YXParentNavigationController_Phone *mineNavi = [[YXParentNavigationController_Phone alloc] initWithRootViewController:mineVC];
    
    UITabBarController *tabBarController = [[UITabBarController alloc]init];
    tabBarController.viewControllers = @[homeNavi, reportNavi, honorNavi, mineNavi];
    tabBarController.tabBar.tintColor = YXMainBlueColor;
    
    if ([YXParentUserManager sharedInstance].bindStatus) {
        self.window.rootViewController = tabBarController;
        self.tabBarController = tabBarController;
        [self checkHonorRedFlag];
    }else if ([YXParentUserManager sharedInstance].loginStatus){
        [self showParentBindViewController];
    }else {
        [self showParentLoginViewController];
    }
}

- (void)setupTricks {
    [YXLoadingView aspect_hookSelector:@selector(startLoading) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated) {
        [[UIResponder currentFirstResponder] resignFirstResponder];
    } error:NULL];
}

- (void)setupUI {
    _tabBarController = [[YXTabBarController alloc] init];
    UIViewController *homeVC = [[NSClassFromString(@"YXSmartExerciseViewController") alloc] init];
    homeVC.title = @"练习";
    [self configTabbarItem:homeVC.tabBarItem image:@"底部导航栏-智能学习-线框" selectedImage:@"底部导航栏-智能学习-填充"];
    YXNavigationController *homeNavi = [[YXNavigationController alloc] initWithRootViewController:homeVC];
    
    UIViewController *groupVC = [[NSClassFromString(@"YXHomeworkGroupViewController") alloc] init];
    //刷新红点
    [groupVC performSelector:@selector(firstPageFetch)];
    groupVC.title = @"作业";
    [self configTabbarItem:groupVC.tabBarItem image:@"底部导航栏-作业群组-线框" selectedImage:@"底部导航栏-作业群组-填充"];
    YXNavigationController *groupNavi = [[YXNavigationController alloc] initWithRootViewController:groupVC];
    
    UIViewController *mineVC = [[NSClassFromString(@"YXMineViewController") alloc] init];
    mineVC.title = @"我的";
    [self configTabbarItem:mineVC.tabBarItem image:@"底部导航栏-我的-线框" selectedImage:@"底部导航栏-我的-填充"];
    YXNavigationController *mineNavi = [[YXNavigationController alloc] initWithRootViewController:mineVC];
    
    _tabBarController.viewControllers = @[homeNavi, groupNavi, mineNavi];
    
    _tabBarController.tabBar.tintColor = YXMainBlueColor;
    
    if ([[YXUserManager sharedManager] isLogin]) {
        if ([[YXUserManager sharedManager] isRegisterByJoinClass]) {
            [_tabBarController setSelectedIndex:1];
        }
        self.window.rootViewController = _tabBarController;
    } else {
        [self showLoginViewController];
    }
}

- (void)setupEntranceUI{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    if (kTestEntrance) {
        YXTestViewController *vc = [[YXTestViewController alloc] init];
        self.window.rootViewController = [[YXNavigationController alloc] initWithRootViewController:vc];
    }else{
        [self setupUI];
        //        if ([[YXUserManager sharedManager] isLogin]) {
        //            [self setupUI];
        //            [YXAppStartupManager sharedInstance].role = YXRoleStudent;
        //        }else if ([YXParentUserManager sharedInstance].loginStatus){
        //            [self setupParentUI];
        //            [YXAppStartupManager sharedInstance].role = YXRoleParent;
        //        }else{
        //            [self showRoleSelectionViewController];
        //            [YXAppStartupManager sharedInstance].role = YXRoleUnknown;
        //        }
        
    }
    [self.window makeKeyAndVisible];
}

#pragma mark- Application
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    [self setupUI];

    [self loadJSPatchURL];
    
    [self setupEntranceUI];
    
    [YXRedManager requestPendingHomeWorkNumber];
    
    [[YXAppStartupManager sharedInstance] setupForAppdelegate:self withLauchOptions:launchOptions];
    
    [self setupTricks];
    
    [YXRecordManager startRegularReport];
    /////
    [YXRecordManager addRecordWithType:YXRecordStartType];
//    id vc = [NSClassFromString(@"YXJieXiFoldUnfoldViewController") new];
//    id vc = [NSClassFromString(@"YXJieXiViewController") new];
//    id vc = [NSClassFromString(@"YXAnswerQuestionViewController") new];
//    self.window.rootViewController = vc;

    return YES;
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

#pragma mark - Show

- (void)showRoleSelectionViewController{
    if ([self.window.rootViewController isKindOfClass:[YXRoleSelectionViewController_Phone class]]) {
        self.window.rootViewController.view.hidden = NO;
        return;
    }
    YXRoleSelectionViewController_Phone *vc = [[YXRoleSelectionViewController_Phone alloc]init];
    @weakify(self);
    vc.roleSelectionBlock = ^(YXRoleType type){
        @strongify(self); if (!self) return;
        [YXAppStartupManager sharedInstance].role = type;
        if (type == YXRoleStudent) {
            [self setupUI];
        }else if (type == YXRoleParent){
            [self setupParentUI];
        }
    };
    self.window.rootViewController = vc;
    [YXAppStartupManager sharedInstance].role = YXRoleUnknown;
}

- (void)switchToTabIndex:(NSInteger)index
{
    [self.tabBarController setSelectedIndex:index];
}

- (void)configTabbarItem:(UITabBarItem *)tabBarItem image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    tabBarItem.image = [UIImage imageNamed:image];
    tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName: YXTextGrayColor} forState:UIControlStateNormal];
    [tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor colorWithHexString:@"b28f47"]} forState:UIControlStateSelected];
}

- (UIViewController *)lastPresentedViewController
{
    UIViewController *vc = self.window.rootViewController;
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
    }
    return vc;
}

- (void)showLoginViewController
{
    if (self.window.rootViewController != self.navigationController && self.window.rootViewController.presentedViewController != self.navigationController) {
        self.navigationController = nil;
    }
    
    if (!self.navigationController) {
        UIViewController *vc = nil;
        if ([YXGuideViewController isGuideViewShowed]) {
            vc = [[YXLoginViewController alloc] init];
        } else {
            vc = [[YXGuideViewController alloc] init];
        }
        self.navigationController = [[YXNavigationController alloc] initWithRootViewController:vc];
        self.navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
        
        if (self.window.rootViewController) {
            [self.window.rootViewController presentViewController:self.navigationController animated:YES completion:nil];
        } else {
            self.window.rootViewController = self.navigationController;
        }
    }
}

- (void)showParentLoginViewController{
    
    YXPLoginViewController_Phone *vc = [[YXPLoginViewController_Phone alloc]init];
    YXParentNavigationController_Phone *navi = [[YXParentNavigationController_Phone alloc]initWithRootViewController:vc];
    if (self.window.rootViewController) {
        [self.window.rootViewController presentViewController:navi animated:YES completion:nil];
    } else {
        self.window.rootViewController = navi;
    }
}

- (void)showParentBindViewController{
    if (self.isBindVCShowing) {
        return;
    }
    YXPCombineChildViewController_Phone *vc = [[YXPCombineChildViewController_Phone alloc]init];
    YXParentNavigationController_Phone *navi = [[YXParentNavigationController_Phone alloc]initWithRootViewController:vc];
    if (self.window.rootViewController) {
        [self.window.rootViewController presentViewController:navi animated:YES completion:nil];
    } else {
        self.window.rootViewController = navi;
    }
    self.isBindVCShowing = YES;
}

#pragma mark - YXApnsDelegate

- (void)apnsHomeworkReport:(YXApnsContentModel *)apns paper:(YXIntelligenceQuestion *)paper
{
    YXIntelligenceQuestion *question = paper;
    YXApnsQAReportViewController *vc = [[YXApnsQAReportViewController alloc] init];
    vc.model = [QAPaperModel modelFromRawData:question];
    vc.pType = YXPTypeGroupHomework;
    
    YXNavigationController *navi = [[YXNavigationController alloc] initWithRootViewController:vc];
    [[self lastPresentedViewController] presentViewController:navi animated:YES completion:nil];
}

- (void)apnsHomeworkList:(YXApnsContentModel *)apns
{    
    YXApnsHomeworkViewController *vc = [[YXApnsHomeworkViewController alloc] init];
    vc.groupInfoData = [[YXHomeworkListGroupsItem_Data alloc] init];
    vc.groupInfoData.groupId = apns.uid;
    [vc.navigationItem setTitle:apns.name];
    YXNavigationController *navi = [[YXNavigationController alloc] initWithRootViewController:vc];
    [[self lastPresentedViewController] presentViewController:navi animated:YES completion:nil];
}

- (void)apnsHomework:(YXApnsContentModel *)apns
{
    [self switchToTabIndex:1];
}

- (void)apnsWebpage:(YXApnsContentModel *)apns
{
    YXBaseWebViewController * webViewController = [[YXBaseWebViewController alloc] initWithUrlString:apns.name];
    webViewController.showType = WebViewshowType_Present;
    YXNavigationController *navi = [[YXNavigationController alloc] initWithRootViewController:webViewController];
    [[self lastPresentedViewController] presentViewController:navi animated:YES completion:nil];
}

#pragma mark - YXLoginDelegate

- (void)userLogoutSuccess
{
    [self showLoginViewController];
}

- (void)userLoginSuccess
{
    [self setupUI];
}

- (void)parentUserLoginSuccess{
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    if ([YXParentUserManager sharedInstance].bindStatus) {
        self.window.rootViewController.view.hidden = YES;
    }
    [self setupParentUI];
}

- (void)parentUserLogoutSuccess{
    [self showRoleSelectionViewController];
}

- (void)parentUserBindSuccess{
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    self.window.rootViewController.view.hidden = YES;
    self.isBindVCShowing = NO;
    [self setupParentUI];
}

- (void)parentUserUnbindSuccess{
    [self showParentBindViewController];
}

- (void)parentUserExitBindSuccess{
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    self.window.rootViewController.view.hidden = YES;
    [self showRoleSelectionViewController];
    self.isBindVCShowing = NO;
}

@end

#pragma mark - ApiStubForTransfer

@interface AppDelegate (ApiStubForTransfer)

@end

@implementation AppDelegate (ApiStubForTransfer)

- (void)applicationWillTerminate:(UIApplication *)application
{
    [YXRecordManager addRecordWithType:YXRecordQuitType];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    __block UIBackgroundTaskIdentifier bgTask;// 后台任务标识
    
    // 结束后台任务
    void (^endBackgroundTask)() = ^(){
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    };
    
    bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        endBackgroundTask();
    }];
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{

}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return NO;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
   
}

// 9.0
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    return NO;
}


@end
