//
//  YXConnectClassifyDetailViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/8/11.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXConnectClassifyDetailViewController.h"

@interface YXConnectClassifyDetailViewController ()

@end

@implementation YXConnectClassifyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.descLabel.text = @"答案都是 0,2;1,3...连续的形式，数字为选项的索引，不要写错了";
    if ([self.question templateType] == YXQATemplateConnect) {
        self.navigationItem.title = @"连线题配置";
    }else{
        self.navigationItem.title = @"归类题配置";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI{
    [super setupUI];
    self.answerLabel = [[UILabel alloc]init];
    self.answerLabel.text = @"我的答案:";
    [self.containerView addSubview:self.answerLabel];
    [self.answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.identifierLabel.mas_left);
        make.top.mas_equalTo(self.identifierLabel.mas_bottom).mas_offset(20);
    }];
    
    self.answerField = [[UITextField alloc]init];
    self.answerField.borderStyle = UITextBorderStyleRoundedRect;
    self.answerField.returnKeyType = UIReturnKeyDone;
    self.answerField.delegate = self;
    [self.containerView addSubview:self.answerField];
    [self.answerField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.answerLabel.mas_right).mas_offset(20);
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(self.answerLabel.mas_centerY);
        make.height.mas_equalTo(30);
    }];
    
    self.answerField.text = [self.question.pad.jsonAnswer componentsJoinedByString:@";"];
}


- (void)saveData{
    [super saveData];
    if (self.answerField.text.length > 0) {
        NSArray *array = [self.answerField.text componentsSeparatedByString:@";"];
        self.question.pad.jsonAnswer = array;
    }
}

@end
