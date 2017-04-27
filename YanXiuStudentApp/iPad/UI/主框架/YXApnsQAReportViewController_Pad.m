//
//  YXApnsQAReportViewController_Pad.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 2/18/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import "YXApnsQAReportViewController_Pad.h"

@implementation YXApnsQAReportViewController_Pad

- (void)viewDidLoad {
    [super viewDidLoad];
    [self yx_setupLeftCancelBarButtonItem];
}

- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
