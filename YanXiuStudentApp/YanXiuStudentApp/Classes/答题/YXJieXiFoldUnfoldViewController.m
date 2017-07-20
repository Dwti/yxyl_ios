//
//  YXJieXiFoldUnfoldViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/7/23.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXJieXiFoldUnfoldViewController.h"

@interface YXJieXiFoldUnfoldViewController ()

@end

@implementation YXJieXiFoldUnfoldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (QASlideItemBaseView *)slideView:(QASlideView *)slideView itemViewAtIndex:(NSInteger)index {
    QAQuestionBaseView *view = (QAQuestionBaseView *)[super slideView:slideView itemViewAtIndex:index];
    view.analysisDataHidden = YES;
//    view.showChildIndexFromOne = YES;
    view.isPaperSubmitted = YES;
    return view;
}

@end
