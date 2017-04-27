//
//  NextViewController.m
//  PadDemo
//
//  Created by niuzhaowang on 16/1/18.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "NextViewController.h"
#import "YXSplitViewController.h"

@interface NextViewController ()

@end

@implementation NextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(100, 200, 300, 70)];
    lb.text = @"Next VC";
    [self.view addSubview:lb];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)naviLeftAction{
    [super naviLeftAction];
    
    [self.yxSplitViewController showLeft];
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
