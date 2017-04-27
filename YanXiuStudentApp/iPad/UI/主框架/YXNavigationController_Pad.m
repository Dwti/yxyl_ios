//
//  YXNavigationController_Pad.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/25.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXNavigationController_Pad.h"

@interface YXNavigationController_Pad ()

@end

@implementation YXNavigationController_Pad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 禁用自动pop手势
    self.interactivePopGestureRecognizer.enabled = NO;
    
    // 设置导航背景
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"00ccccc"]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    // 设置导航下方色条
    UIView *v0 = [[UIView alloc] init];
    v0.backgroundColor = [UIColor colorWithHexString:@"00a3a3"];
    v0.frame = CGRectMake(0, self.navigationBar.frame.size.height - 4, self.navigationBar.frame.size.width, 4);
    [self.navigationBar addSubview:v0];
    
    // 设置标题样式
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithHexString:@"33ffff"];
    shadow.shadowOffset = CGSizeMake(0, 1);
    
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                [UIColor colorWithHexString:@"006666"], NSForegroundColorAttributeName,
                                                shadow, NSShadowAttributeName,
                                                [UIFont boldSystemFontOfSize:18], NSFontAttributeName,
                                                nil]];
    
    // 设置导航栏阴影
    self.navigationBar.layer.shadowColor = [[UIColor blackColor]colorWithAlphaComponent:0.2].CGColor;
    self.navigationBar.layer.shadowOffset = CGSizeMake(0, 3);
    self.navigationBar.layer.shadowRadius = 0;
    self.navigationBar.layer.shadowOpacity = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
