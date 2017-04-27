//
//  FirstViewController.m
//  PadDemo
//
//  Created by niuzhaowang on 16/1/18.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "FirstViewController.h"
#import "NextViewController.h"
#import "YXSplitViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"First";
    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 200, 50)];
    lb.text = @"这是第一个VC";
    [self.view addSubview:lb];
    
    UIButton *b = [[UIButton alloc]initWithFrame:CGRectMake(100, 300, 80, 50)];
    [b setTitle:@"button" forState:UIControlStateNormal];
    [b setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [b addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];
    
    self.view.userInteractionEnabled = YES;
    b.userInteractionEnabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnAction{
    NextViewController *vc = [[NextViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    [self.yxSplitViewController hideLeft];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
