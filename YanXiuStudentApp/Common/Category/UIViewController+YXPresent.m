//
//  UIViewController+YXPresent.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/2/2.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "UIViewController+YXPresent.h"

@implementation UIViewController (YXPresent)

- (void)yx_presentViewController:(UIViewController *)vc completion:(void (^)(void))completion
{
    UIViewController *parentVC = self.navigationController;
    if (!parentVC) {
        parentVC = self;
    }
    [parentVC.view addSubview:vc.view];
    [parentVC addChildViewController:vc];
    vc.view.frame = CGRectMake(0, parentVC.view.bounds.size.height, parentVC.view.bounds.size.width, parentVC.view.bounds.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        vc.view.frame = parentVC.view.bounds;
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

- (void)yx_dismiss{
    UIViewController *childVC = self.navigationController;
    if (!childVC) {
        childVC = self;
    }
    [UIView animateWithDuration:0.3 animations:^{
        childVC.view.frame = CGRectMake(0, childVC.view.bounds.size.height, childVC.view.bounds.size.width, childVC.view.bounds.size.height);
    }completion:^(BOOL finished) {
        [childVC.view removeFromSuperview];
        [childVC removeFromParentViewController];
    }];
}

- (UIViewController *)nyx_visibleViewController{
    if(self.presentingViewController){
        return self;
    }
    else{
        UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        UIViewController *rootViewController = window.rootViewController;
        return [UIViewController nyx_getVisibleViewControllerFrom:rootViewController];
    }
}
+ (UIViewController *)nyx_getVisibleViewControllerFrom:(UIViewController *) vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [UIViewController nyx_getVisibleViewControllerFrom:[((UINavigationController *) vc) visibleViewController]];
    }
    else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [UIViewController nyx_getVisibleViewControllerFrom:[((UITabBarController *) vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [UIViewController nyx_getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
}

@end
