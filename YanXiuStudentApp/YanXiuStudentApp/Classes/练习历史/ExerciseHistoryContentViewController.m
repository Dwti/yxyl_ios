//
//  ExerciseHistoryContentViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/11/3.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "ExerciseHistoryContentViewController.h"
#import "YXChapterPointSegmentControl.h"
#import "YXGetPracticeEditionRequest.h"
#import "ExerciseHistoryKnpViewController.h"
#import "ExerciseHistoryChapterViewController.h"

@interface ExerciseHistoryContentViewController ()
@property (nonatomic, strong) ExerciseHistoryKnpViewController *knpVC;
@property (nonatomic, strong) ExerciseHistoryChapterViewController *chapterVC;
@end

@implementation ExerciseHistoryContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.subject.name;
    [self yx_setupLeftBackBarButtonItem];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.image = [UIImage imageNamed:@"我的背景"];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];

    UIView *topContainerView = [[UIView alloc] init];
    topContainerView.backgroundColor = [UIColor colorWithHexString:@"008080"];
    topContainerView.clipsToBounds = YES;
    [self.view addSubview:topContainerView];
    UIView *sepView = [[UIView alloc] init];
    sepView.backgroundColor = [UIColor colorWithHexString:@"007373"];
    [topContainerView addSubview:sepView];
    [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo(2);
    }];
    [topContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(58);
    }];

    YXChapterPointSegmentControl *chooseChapterPointControl = [[YXChapterPointSegmentControl alloc] init];
    [topContainerView addSubview:chooseChapterPointControl];
    [chooseChapterPointControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(chooseChapterPointControl.frame.size);
    }];
    [chooseChapterPointControl addTarget:self action:@selector(chapterPointValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.chapterVC = [[ExerciseHistoryChapterViewController alloc]init];
    self.chapterVC.subject = self.subject;
    [self.view addSubview:self.chapterVC.view];
    [self.chapterVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topContainerView.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    self.knpVC = [[ExerciseHistoryKnpViewController alloc]init];
    self.knpVC.subject = self.subject;
    [self.view addSubview:self.knpVC.view];
    [self.knpVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topContainerView.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
    self.knpVC.view.hidden = YES;
    
    [self addChildViewController:self.chapterVC];
    [self addChildViewController:self.knpVC];
}

#pragma mark - Actions
- (void)chapterPointValueChanged:(YXChapterPointSegmentControl *)seg {
    if (seg.curSelectedIndex == 0) {
        self.chapterVC.view.hidden = NO;
        self.knpVC.view.hidden = YES;
    }else{
        self.chapterVC.view.hidden = YES;
        self.knpVC.view.hidden = NO;
    }
}


@end
