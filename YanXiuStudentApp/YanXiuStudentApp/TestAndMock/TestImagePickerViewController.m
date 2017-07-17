//
//  TestImagePickerViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/17.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "TestImagePickerViewController.h"
#import "HeadImageHandler.h"

@interface TestImagePickerViewController ()
@property (nonatomic, strong) HeadImageHandler *handler;
@end

@implementation TestImagePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *b = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 100, 60)];
    [b setTitle:@"Image" forState:UIControlStateNormal];
    [b addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnAction {
    self.handler = [[HeadImageHandler alloc]init];
    [self.handler pickImageFromAlbumWithCompleteBlock:nil];
}

@end
