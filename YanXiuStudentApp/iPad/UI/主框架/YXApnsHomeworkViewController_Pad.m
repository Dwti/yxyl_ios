//
//  YXApnsHomeworkViewController_Pad.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 2/18/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import "YXApnsHomeworkViewController_Pad.h"

@implementation YXApnsHomeworkViewController_Pad

- (void)viewDidLoad {
    [super viewDidLoad];
    [self yx_setupLeftCancelBarButtonItem];
}

- (void)yx_leftCancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
