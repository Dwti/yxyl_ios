//
//  YXHomeViewController.m
//  YXUserStatistics
//
//  Created by ChenJianjun on 16/5/26.
//  Copyright © 2016年 yanxiu. All rights reserved.
//

#import "YXHomeViewController.h"
#import "YXDetailViewController.h"

@interface YXHomeViewController ()

@end

@implementation YXHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"首页";
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    button.clipsToBounds = YES;
    button.layer.cornerRadius = 2.f;
    button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    button.layer.borderWidth = 1.f;
    [button setTitle:@"分享" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(onShareBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIButton *detailButton = [[UIButton alloc] init];
    detailButton.bounds = CGRectMake(0, 0, 100, 40);
    detailButton.center = self.view.center;
    detailButton.clipsToBounds = YES;
    detailButton.layer.cornerRadius = 2.f;
    detailButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    detailButton.layer.borderWidth = 1.f;
    [detailButton setTitle:@"详情页" forState:UIControlStateNormal];
    [detailButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [detailButton addTarget:self action:@selector(enterDetailPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:detailButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onShareBtnPressed:(id)sender
{
    UIButton *button = sender;
    button.selected = !button.selected;
}

- (void)enterDetailPage
{
    YXDetailViewController *vc = [[YXDetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
