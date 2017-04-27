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
    [self yx_setupLeftCancelBarButtonItem];
}

- (void)naviCloseAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
