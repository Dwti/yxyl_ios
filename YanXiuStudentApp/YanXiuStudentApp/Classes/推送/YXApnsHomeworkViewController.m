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
    [self yx_setupLeftCancelBarButtonItem];
    
    //[self.navigationItem setTitle:@"WWWWWW"];
}

- (void)naviCloseAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
