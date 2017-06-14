//
//  QAPhotoBrowseViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/20.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAPhotoBrowseViewController.h"
#import "QAPhotoBrowseView.h"
#import "QAPhotoBrowseTopBarView.h"

@interface QAPhotoBrowseViewController ()<QASlideViewDataSource,QASlideViewDelegate>
@property (nonatomic, strong) QASlideView *slideView;
@property (nonatomic, strong) QAPhotoBrowseTopBarView *topBarView;
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
@property (nonatomic, assign) BOOL isFirstLoad;
@end

@implementation QAPhotoBrowseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    self.isFirstLoad = YES;
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)setupUI {
    self.slideView = [[QASlideView alloc]init];
    self.slideView.dataSource = self;
    self.slideView.delegate = self;
    self.slideView.currentIndex = self.oriIndex;
    [self.view addSubview:self.slideView];
    [self.slideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.topBarView = [[QAPhotoBrowseTopBarView alloc]init];
    self.topBarView.canDelete = self.canDelete;
    [self.topBarView updateWithCurrentIndex:self.oriIndex total:self.itemArray.count];
    WEAK_SELF
    [self.topBarView setExitBlock:^{
        STRONG_SELF
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.topBarView setDeleteBlock:^{
        STRONG_SELF
        [self.itemArray removeObjectAtIndex:self.slideView.currentIndex];
        self.isFirstLoad = YES;
        [self.slideView reloadData];
        if (self.itemArray.count == 0) {
            self.topBarView.canDelete = NO;
        }
        BLOCK_EXEC(self.deleteBlock);
    }];
    [self.view addSubview:self.topBarView];
    [self.topBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(55);
    }];
    
    self.singleTap = [[UITapGestureRecognizer alloc] init];
    [self.view addGestureRecognizer:self.singleTap];
    [[self.singleTap rac_gestureSignal] subscribeNext:^(id x) {
        STRONG_SELF
        if (self.topBarView.alpha == 0.f) {
            [self showTopBar];
        }else {
            [self hideTopBar];
        }
    }];
}

- (void)showTopBar {
    [UIView animateWithDuration:0.1 animations:^{
        self.topBarView.alpha = 1.f;
    }];
}

- (void)hideTopBar {
    [UIView animateWithDuration:0.1 animations:^{
        self.topBarView.alpha = 0.f;
    }];
}

#pragma mark - QASlideViewDataSource
- (NSInteger)numberOfItemsInSlideView:(QASlideView *)slideView {
    return self.itemArray.count;
}

- (QASlideItemBaseView *)slideView:(QASlideView *)slideView itemViewAtIndex:(NSInteger)index {
    QAPhotoBrowseView *view = [[QAPhotoBrowseView alloc]init];
    view.imageAnswer = self.itemArray[index];
    [self.singleTap requireGestureRecognizerToFail:view.doubleTapGesture];
    return view;
}

#pragma mark - QASlideViewDelegate
- (void)slideView:(QASlideView *)slideView didSlideFromIndex:(NSInteger)from toIndex:(NSInteger)to {
    [self.topBarView updateWithCurrentIndex:to total:self.itemArray.count];
    if (!self.isFirstLoad) {
        [self hideTopBar];
    }
    self.isFirstLoad = NO;
}

@end
