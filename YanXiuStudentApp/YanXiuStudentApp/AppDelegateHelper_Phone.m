//
//  AppDelegateHelper_Phone.m
//  AppDelegateTest
//
//  Created by niuzhaowang on 2016/9/26.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "AppDelegateHelper_Phone.h"
#import "YXLoginViewController.h"
#import "YXGuideViewController.h"
#import "YXTabBarController.h"
#import "YXApnsHomeworkViewController.h"
#import "YXHomeworkListFetcher.h"
#import "LoginViewController.h"

@implementation AppDelegateHelper_Phone

- (UIViewController *)rootViewController{
    if (![YXGuideViewController isGuideViewShowed]) {
        return [self guideViewController];
    }else if (![[YXUserManager sharedManager] isLogin]) {
        return [self loginViewController];
    }else {
        return [self mainViewController];
    }
}

- (UIViewController *)guideViewController {
    YXGuideViewController *vc = [[YXGuideViewController alloc] init];
    return [[YXNavigationController alloc] initWithRootViewController:vc];
}

- (UIViewController *)loginViewController {
    LoginViewController *vc = [[LoginViewController alloc] init];
    return [[YXNavigationController alloc] initWithRootViewController:vc];
}

- (UIViewController *)mainViewController {
    YXTabBarController *tabBarController = [[YXTabBarController alloc] init];
    UIViewController *homeVC = [[NSClassFromString(@"YXSmartExerciseViewController") alloc] init];
    homeVC.title = @"练习";
    [self configTabbarItem:homeVC.tabBarItem image:@"底部导航栏-智能学习-线框" selectedImage:@"底部导航栏-智能学习-填充"];
    YXNavigationController *homeNavi = [[YXNavigationController alloc] initWithRootViewController:homeVC];
    
    UIViewController *groupVC = [[NSClassFromString(@"YXHomeworkGroupViewController") alloc] init];
    groupVC.title = @"作业";
    [self configTabbarItem:groupVC.tabBarItem image:@"底部导航栏-作业群组-线框" selectedImage:@"底部导航栏-作业群组-填充"];
    YXNavigationController *groupNavi = [[YXNavigationController alloc] initWithRootViewController:groupVC];
    
    UIViewController *mineVC = [[NSClassFromString(@"YXMineViewController") alloc] init];
    mineVC.title = @"我的";
    [self configTabbarItem:mineVC.tabBarItem image:@"底部导航栏-我的-线框" selectedImage:@"底部导航栏-我的-填充"];
    YXNavigationController *mineNavi = [[YXNavigationController alloc] initWithRootViewController:mineVC];
    
    tabBarController.viewControllers = @[homeNavi, groupNavi, mineNavi];
    tabBarController.tabBar.tintColor = YXMainBlueColor;
    return tabBarController;
}

- (void)configTabbarItem:(UITabBarItem *)tabBarItem image:(NSString *)image selectedImage:(NSString *)selectedImage {
    tabBarItem.image = [UIImage imageNamed:image];
    tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName: YXTextGrayColor} forState:UIControlStateNormal];
    [tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor colorWithHexString:@"b28f47"]} forState:UIControlStateSelected];
}

#pragma mark -
- (void)handleLoginSuccess {
    YXTabBarController *tabBarController = (YXTabBarController *)[self mainViewController];
    if ([[YXUserManager sharedManager] isRegisterByJoinClass]) {
        [tabBarController setSelectedIndex:1];
    }
    self.window.rootViewController = tabBarController;
}

- (void)handleLogoutSuccess {
    [self.window.rootViewController presentViewController:[self loginViewController] animated:YES completion:nil];
}

#pragma mark -
- (void)apnsGoHomeworkList:(YXApnsContentModel *)model {
    YXHomeworkListFetcher *fetcher = [[YXHomeworkListFetcher alloc] init];
    fetcher.gid = model.uid;
    YXApnsHomeworkViewController *vc = [[YXApnsHomeworkViewController alloc] initWithFetcher:fetcher];
    vc.groupInfoData = [[YXHomeworkListGroupsItem_Data alloc] init];
    vc.groupInfoData.groupId = model.uid;
    [vc.navigationItem setTitle:model.name];
    YXNavigationController *navi = [[YXNavigationController alloc] initWithRootViewController:vc];
    [[self lastPresentedViewController] presentViewController:navi animated:YES completion:nil];
}

- (UIViewController *)lastPresentedViewController {
    UIViewController *vc = self.window.rootViewController;
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
    }
    return vc;
}

- (void)apnsGoHomework:(YXApnsContentModel *)model {
    [self switchToTabIndex:1];
}

- (void)switchToTabIndex:(NSInteger)index {
    if ([self.window.rootViewController isKindOfClass:[YXTabBarController class]]) {
        YXTabBarController *tabBarVC = (YXTabBarController *)self.window.rootViewController;
        [tabBarVC setSelectedIndex:index];
    }
}

#pragma mark -
- (void)handleStageChange {
    [self switchToTabIndex:0];
}

@end
