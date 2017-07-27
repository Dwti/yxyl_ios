//
//  YXApnsQAReportViewController.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 9/28/15.
//  Copyright © 2015 yanxiu.com. All rights reserved.
//

#import "YXApnsQAReportViewController.h"

@interface YXApnsQAReportViewController ()

@end

@implementation YXApnsQAReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WEAK_SELF
    [self nyx_setupLeftWithImage:[UIImage imageWithColor:[UIColor redColor] rect:CGRectMake(0, 0, 26, 26)] action:^{
        STRONG_SELF
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

@end
