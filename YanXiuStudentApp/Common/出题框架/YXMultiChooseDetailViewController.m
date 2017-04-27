//
//  YXMultiChooseDetailViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/8/3.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXMultiChooseDetailViewController.h"

@interface YXMultiChooseDetailViewController ()

@end

@implementation YXMultiChooseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"多选题配置";
    self.descLabel.text = @"多选题答案都是 AB";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)answerBtnAction:(UIButton *)sender{
    sender.selected = !sender.selected;
}

@end
