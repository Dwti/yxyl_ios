//
//  YXYesNoDetailViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/8/3.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXYesNoDetailViewController.h"

@interface YXYesNoDetailViewController ()

@end

@implementation YXYesNoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"判断题配置";
    self.descLabel.text = @"判断题答案都是   正确";
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
    
    self.wrongButton = [self giveMeButtonWithTitle:@"错误"];
    [self.wrongButton addTarget:self action:@selector(wrongAction) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:self.wrongButton];
    [self.wrongButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.answerLabel.mas_right).mas_offset(20);
        make.centerY.mas_equalTo(self.answerLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    self.correctButton = [self giveMeButtonWithTitle:@"正确"];
    [self.correctButton addTarget:self action:@selector(correctAction) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:self.correctButton];
    [self.correctButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.wrongButton.mas_right).mas_offset(20);
        make.centerY.mas_equalTo(self.answerLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    if (self.question.pad.jsonAnswer.count > 0) {
        NSString *a = self.question.pad.jsonAnswer.firstObject;
        if (a.integerValue == 0) {
            self.wrongButton.selected = YES;
        }else{
            self.correctButton.selected = YES;
        }
    }
}

- (UIButton *)giveMeButtonWithTitle:(NSString *)title{
    UIButton *b = [[UIButton alloc]init];
    [b setTitle:title forState:UIControlStateNormal];
    [b setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    UIImage *selectImage = [UIImage imageWithColor:[UIColor redColor]];
    [b setBackgroundImage:selectImage forState:UIControlStateSelected];
    b.layer.borderColor = [UIColor blueColor].CGColor;
    b.layer.borderWidth = 1;
    b.layer.cornerRadius = 3;
    b.clipsToBounds = YES;
    return b;
}

- (void)wrongAction{
    if (self.wrongButton.selected) {
        self.wrongButton.selected = NO;
    }else{
        self.wrongButton.selected = YES;
        self.correctButton.selected = NO;
    }
}

- (void)correctAction{
    if (self.correctButton.selected) {
        self.correctButton.selected = NO;
    }else{
        self.correctButton.selected = YES;
        self.wrongButton.selected = NO;
    }
}

- (void)saveData{
    [super saveData];
    NSMutableArray *array = [NSMutableArray array];
    if (self.wrongButton.selected) {
        [array addObject:@"0"];
    }else if (self.correctButton.selected){
        [array addObject:@"1"];
    }
    self.question.pad.jsonAnswer = array;
}

@end
