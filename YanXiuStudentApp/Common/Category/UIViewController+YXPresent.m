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

@end
