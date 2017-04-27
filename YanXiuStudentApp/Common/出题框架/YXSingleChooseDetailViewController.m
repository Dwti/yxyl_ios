//
//  YXSingleChooseDetailViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/8/3.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXSingleChooseDetailViewController.h"

@interface YXSingleChooseDetailViewController ()

@end

@implementation YXSingleChooseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"单选题配置";
    self.descLabel.text = @"单选题答案都是 A";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)answerBtnAction:(UIButton *)sender{
    if (sender.selected) {
        sender.selected = NO;
    }else{
        for (UIButton *b in self.answerButtons) {
            b.selected = NO;
        }
        sender.selected = YES;
    }
}

@end
