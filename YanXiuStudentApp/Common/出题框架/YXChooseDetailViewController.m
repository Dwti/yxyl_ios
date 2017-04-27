//
//  YXChooseDetailViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/8/2.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXChooseDetailViewController.h"

@interface YXChooseDetailViewController ()

@end

@implementation YXChooseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    self.answerButtons = [NSMutableArray array];
    for (int i=0; i<4; i++) {
        UIButton *b = [[UIButton alloc]init];
        char c = 'A' + i;
        NSString *cString = [NSString stringWithFormat:@"%c", c];
        [b setTitle:cString forState:UIControlStateNormal];
        [b setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        UIImage *selectImage = [UIImage imageWithColor:[UIColor redColor]];
        [b setBackgroundImage:selectImage forState:UIControlStateSelected];
        b.layer.borderColor = [UIColor blueColor].CGColor;
        b.layer.borderWidth = 1;
        b.layer.cornerRadius = 3;
        b.clipsToBounds = YES;
        [b addTarget:self action:@selector(answerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView addSubview:b];

        if (i == 0) {
            [b mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.answerLabel.mas_right).mas_offset(20);
                make.centerY.mas_equalTo(self.answerLabel.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(40, 30));
            }];
        }else{
            UIButton *preBtn = self.answerButtons.lastObject;
            [b mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(preBtn.mas_right).mas_offset(10);
                make.centerY.mas_equalTo(self.answerLabel.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(40, 30));
            }];
        }
        [self.answerButtons addObject:b];
    }
    for (NSString *a in self.question.pad.jsonAnswer) {
        UIButton *b = self.answerButtons[a.integerValue];
        b.selected = YES;
    }
}

- (void)answerBtnAction:(UIButton *)sender{
    
}

- (void)saveData{
    [super saveData];
    NSMutableArray *array = [NSMutableArray array];
    [self.answerButtons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *b = (UIButton *)obj;
        if (b.selected) {
            [array addObject:[NSString stringWithFormat:@"%@",@(idx)]];
        }
    }];
    self.question.pad.jsonAnswer = array;
}

@end
