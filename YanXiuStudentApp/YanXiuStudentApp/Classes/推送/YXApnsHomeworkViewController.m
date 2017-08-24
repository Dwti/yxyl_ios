//
//  YXApnsHomeworkViewController.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 9/28/15.
//  Copyright © 2015 yanxiu.com. All rights reserved.
//

#import "YXApnsHomeworkViewController.h"

@interface YXApnsHomeworkViewController ()

@end

@implementation YXApnsHomeworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WEAK_SELF
    [self nyx_setupLeftWithImageName:@"返回上一页icon绿色正常态" highlightImageName:@"返回上一页icon绿色点击态" action:^{
        STRONG_SELF
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

@end
