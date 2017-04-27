//
//  YXFillBlankDetailViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/8/3.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXFillBlankDetailViewController.h"

@interface YXFillBlankDetailViewController ()

@end

@implementation YXFillBlankDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"填空题配置";
    self.descLabel.text = @"填空题共3个空，答案分别是  one  two  three";
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
    self.answerFields = [NSMutableArray array];
    for (int i=0; i<3; i++) {
        UITextField *field = [[UITextField alloc]init];
        field.borderStyle = UITextBorderStyleRoundedRect;
        field.returnKeyType = UIReturnKeyDone;
        field.delegate = self;
        [self.containerView addSubview:field];       
        if (i == 0) {
            [field mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.answerLabel.mas_right).mas_offset(20);
                make.centerY.mas_equalTo(self.answerLabel.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(60, 30));
            }];
        }else{
            UIButton *preField = self.answerFields.lastObject;
            [field mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(preField.mas_right).mas_offset(10);
                make.centerY.mas_equalTo(self.answerLabel.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(60, 30));
            }];
        }
        [self.answerFields addObject:field];
    }
    [self.question.pad.jsonAnswer enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UITextField *field = (UITextField *)self.answerFields[idx];
        field.text = obj;
    }];
}

- (void)saveData{
    [super saveData];
    NSMutableArray *array = [NSMutableArray array];
    [self.answerFields enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UITextField *field = (UITextField *)obj;
        if (field.text.length > 0) {
            [array addObject:field.text];
        }else{
            [array addObject:@""];
        }
    }];
    self.question.pad.jsonAnswer = array;
}

@end
