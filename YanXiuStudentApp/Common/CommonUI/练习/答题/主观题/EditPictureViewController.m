//
//  EditPictureViewController.m
//  YanXiuStudentApp
//
//  Created by 贾培军 on 2016/11/3.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "EditPictureViewController.h"

@interface EditPictureViewController ()

@property (nonatomic, strong) EditPictureView *editPictureView;

@end

@implementation EditPictureViewController

#pragma mark-
- (void)viewDidLoad {
    [super viewDidLoad];
    self.editPictureView = [[EditPictureView alloc] initWithFrame:[UIScreen mainScreen].bounds image:self.image];
    self.editPictureView.editComplete = self.editComplete;
    self.editPictureView.cancel = self.cancel;
    [self.view addSubview:self.editPictureView];
    [self.editPictureView firstLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
