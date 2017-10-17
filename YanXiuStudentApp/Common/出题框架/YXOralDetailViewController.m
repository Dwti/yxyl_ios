//
//  YXOralDetailViewController.m
//  YanXiuStudentApp-iPhone
//
//  Created by LiuWenXing on 2017/10/17.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "YXOralDetailViewController.h"

@interface YXOralDetailViewController ()

@end

@implementation YXOralDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"口语题配置";
    self.descLabel.text = @"口语题备注";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI{
    [super setupUI];
    self.answerLabel = [[UILabel alloc]init];
    self.answerLabel.text = @"评级:";
    [self.containerView addSubview:self.answerLabel];
    [self.answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.identifierLabel.mas_left);
        make.top.mas_equalTo(self.identifierLabel.mas_bottom).mas_offset(20);
    }];
    self.answerButtons = [NSMutableArray array];
    NSArray *scores = @[@"优", @"良", @"可", @"差"];
    for (int i=0; i<4; i++) {
        UIButton *b = [[UIButton alloc]init];
        [b setTitle:scores[i] forState:UIControlStateNormal];
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
    if (sender.selected) {
        sender.selected = NO;
    }else{
        for (UIButton *b in self.answerButtons) {
            b.selected = NO;
        }
        sender.selected = YES;
    }
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
