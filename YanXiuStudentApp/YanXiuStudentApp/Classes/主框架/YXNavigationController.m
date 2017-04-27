//
//  YXNavigationController.m
//  YXPublish
//
//  Created by ChenJianjun on 15/5/21.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXNavigationController.h"
#import "UIImage+YXImage.h"

@interface YXNavigationController () <UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@end

@implementation YXNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = self;
        self.interactivePopGestureRecognizer.enabled = NO;
        self.delegate =self;
    }
    
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"00ccccc"]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    UIView *v0 = [[UIView alloc] init];
    v0.backgroundColor = [UIColor colorWithHexString:@"00a3a3"];
    v0.frame = CGRectMake(0, self.navigationBar.frame.size.height - 4 - 2, self.navigationBar.frame.size.width, 4);
    [self.navigationBar addSubview:v0];
    
    UIView *v1 = [[UIView alloc] init];
    v1.backgroundColor = [UIColor colorWithHexString:@"007373"];
    v1.frame = CGRectMake(0, self.navigationBar.frame.size.height - 2, self.navigationBar.frame.size.width, 2);
    [self.navigationBar addSubview:v1];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithHexString:@"33ffff"];
    shadow.shadowOffset = CGSizeMake(0, 1);
    
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                    [UIColor colorWithHexString:@"006666"], NSForegroundColorAttributeName,
                                                    shadow, NSShadowAttributeName,
                                                    [UIFont boldSystemFontOfSize:18], NSFontAttributeName,
                                                    nil]];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count == 1) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [super pushViewController:viewController animated:YES];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
        if (navigationController.viewControllers.count ==1) {
            self.interactivePopGestureRecognizer.enabled =NO;
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - auto rotate

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
