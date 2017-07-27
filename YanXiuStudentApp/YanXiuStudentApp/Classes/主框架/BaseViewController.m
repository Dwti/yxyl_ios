//
//  BaseViewController.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/1/15.
//  Copyright (c) 2015 yanxiu. All rights reserved.
//

#import "BaseViewController.h"
#import "UIImage+YXImage.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"89e00d"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    NSArray *vcArray = self.navigationController.viewControllers;
    if (!isEmpty(vcArray)) {
        if (vcArray[0] != self) {
            WEAK_SELF
            [self nyx_setupLeftWithImage:[UIImage imageWithColor:[UIColor redColor] rect:CGRectMake(0, 0, 26, 26)] action:^{
                STRONG_SELF
                [self backAction];
            }];
        }
    }
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view nyx_stopLoading];
    [self.view endEditing:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [MTA trackPageViewBegin:NSStringFromClass([self class])];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:NSStringFromClass([self class])];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    NSLog(@"-----%@", [self class]);
    YXNavigationController *navi = (YXNavigationController *)self.navigationController;
    if ([navi isKindOfClass:[YXNavigationController class]]) {
        navi.theme = self.naviTheme;
    }
}

#pragma mark -

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

- (void)setNaviTheme:(NavigationBarTheme)naviTheme {
    _naviTheme = naviTheme;
    if (self.navigationController) {
        YXNavigationController *navi = (YXNavigationController *)self.navigationController;
        navi.theme = self.naviTheme;
    }
}
@end
