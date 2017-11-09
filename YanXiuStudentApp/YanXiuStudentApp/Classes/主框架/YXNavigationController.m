//
//  YXNavigationController.m
//  YXPublish
//
//  Created by ChenJianjun on 15/5/21.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXNavigationController.h"
#import "UIImage+YXImage.h"

@interface UINavigationBar (FlexibleHeight)
@end

@implementation UINavigationBar (FlexibleHeight)

//-(CGSize)sizeThatFits:(CGSize)size{
//    CGSize newSize = CGSizeMake(self.frame.size.width, 55);
//    return newSize;
//}

@end

@interface YXNavigationController () <UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@end

@implementation YXNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.navigationBar setTitleVerticalPositionAdjustment:-5.5 forBarMetrics:UIBarMetricsDefault];
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = self;
        self.interactivePopGestureRecognizer.enabled = NO;
        self.delegate =self;
    }
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.navigationBar.layer.shadowOffset = CGSizeMake(0, 1);
    self.navigationBar.layer.shadowRadius = 1;
    self.navigationBar.layer.shadowOpacity = 0.02;
    self.theme = NavigationBarTheme_Green;
}

- (void)setTheme:(NavigationBarTheme)theme {
    _theme = theme;
    if (theme == NavigationBarTheme_Green) {
        [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"89e00d"]] forBarMetrics:UIBarMetricsDefault];
        
        [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                    [UIColor whiteColor], NSForegroundColorAttributeName,
                                                    [UIFont boldSystemFontOfSize:19], NSFontAttributeName,
                                                    nil]];
        self.navigationBar.layer.shadowColor = [UIColor clearColor].CGColor;
    }else if (theme == NavigationBarTheme_White){
        [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
        
        [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                    [UIColor colorWithHexString:@"666666"], NSForegroundColorAttributeName,
                                                    [UIFont boldSystemFontOfSize:19], NSFontAttributeName,
                                                    nil]];
        self.navigationBar.layer.shadowColor = [UIColor colorWithHexString:@"002c0f"].CGColor;
    }
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
