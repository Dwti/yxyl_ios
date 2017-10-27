//
//  QAOralResultViewController.m
//  YanXiuStudentApp-iPhone
//
//  Created by LiuWenXing on 2017/10/22.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAOralResultViewController.h"

@interface QAOralResultViewController ()
@end

@implementation QAOralResultViewController

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view removeFromSuperview];
    });
}

#pragma mark - setupUI
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"89e00d"];
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"发散背景"]];
    [self.view addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(56);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(backImageView.mas_width);
    }];
    
    UIImageView *gradeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self.resultItem oralGradeImageName]]];
    [backImageView addSubview:gradeImageView];
    [gradeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(47.5f, 47.5f, 47.5f, 47.5f));
    }];
}

@end
