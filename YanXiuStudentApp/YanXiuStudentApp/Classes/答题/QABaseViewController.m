//
//  QABaseViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/22.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QABaseViewController.h"
#import "UIViewController+VisibleViewController.h"

@interface QABaseViewController ()

@end

@implementation QABaseViewController

+ (UIView *)currentSwitchBarSnapshotView {
    UIViewController *vc = [[UIApplication sharedApplication].keyWindow.rootViewController nyx_visibleViewController];
    if ([vc isKindOfClass:[QABaseViewController class]]) {
        QABaseViewController *qaVC = (QABaseViewController *)vc;
        return [qaVC.switchView snapshotViewAfterScreenUpdates:NO];
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTheme = NavigationBarTheme_White;
    self.view.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.layer.shadowColor = [UIColor clearColor].CGColor;
}

- (void)setupUI {
    self.slideView = [[QASlideView alloc]init];
    self.slideView.dataSource = self;
    self.slideView.delegate = self;
    [self.view addSubview:self.slideView];
    [self.slideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.switchView = [[QAQuestionSwitchView alloc]init];
    [self.view addSubview:self.switchView];
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(45);
    }];
    WEAK_SELF
    [self.switchView setPreBlock:^{
        STRONG_SELF
        QASlideItemBaseView *view = [self.slideView itemViewAtIndex:self.slideView.currentIndex];
        if ([view isKindOfClass:[QAComlexQuestionAnswerBaseView class]]) {
            QAComlexQuestionAnswerBaseView *complexView = (QAComlexQuestionAnswerBaseView *)view;
            if (complexView.slideView.currentIndex == 0) {
                [self.slideView scrollToItemIndex:self.slideView.currentIndex-1 animated:YES];
            }else {
                [complexView.slideView scrollToItemIndex:complexView.slideView.currentIndex-1 animated:YES];
            }
        }else {
            [self.slideView scrollToItemIndex:self.slideView.currentIndex-1 animated:YES];
        }
    }];
    [self.switchView setNextBlock:^{
        STRONG_SELF
        QASlideItemBaseView *view = [self.slideView itemViewAtIndex:self.slideView.currentIndex];
        if ([view isKindOfClass:[QAComlexQuestionAnswerBaseView class]]) {
            QAComlexQuestionAnswerBaseView *complexView = (QAComlexQuestionAnswerBaseView *)view;
            if (complexView.slideView.currentIndex == complexView.data.childQuestions.count-1) {
                [self.slideView scrollToItemIndex:self.slideView.currentIndex+1 animated:YES];
            }else {
                [complexView.slideView scrollToItemIndex:complexView.slideView.currentIndex+1 animated:YES];
            }
        }else {
            [self.slideView scrollToItemIndex:self.slideView.currentIndex+1 animated:YES];
        }
    }];
    [self.switchView setCompleteBlock:^{
        STRONG_SELF
        DDLogInfo(@"Complete button triggered!");
        SAFE_CALL(self, completeButtonAction);
    }];
}

#pragma mark - QASlideViewDataSource
- (NSInteger)numberOfItemsInSlideView:(QASlideView *)slideView {
    return self.model.questions.count;
}

- (QASlideItemBaseView *)slideView:(QASlideView *)slideView itemViewAtIndex:(NSInteger)index {
    return nil;
}

#pragma mark - QASlideViewDelegate
- (void)slideView:(QASlideView *)slideView didSlideFromIndex:(NSInteger)from toIndex:(NSInteger)to{
    // 复合题滑出当前页时要把小题索引设为0
    QASlideItemBaseView *view = [self.slideView itemViewAtIndex:from];
    if ([view isKindOfClass:[QAComlexQuestionAnswerBaseView class]] && from != to) {
        QAComlexQuestionAnswerBaseView *complexView = (QAComlexQuestionAnswerBaseView *)view;
        if (complexView.slideView.currentIndex != 0) {
            [complexView.slideView scrollToItemIndex:0 animated:NO];
        }
    }
    // 更新上一题/下一题
    NSInteger index = 0;
    QASlideItemBaseView *curView = [self.slideView itemViewAtIndex:to];
    if ([curView isKindOfClass:[QAComlexQuestionAnswerBaseView class]]) {
        QAComlexQuestionAnswerBaseView *complexView = (QAComlexQuestionAnswerBaseView *)curView;
        index = complexView.slideView.currentIndex;
    }
    [self.switchView updateWithTotal:self.model.questions.count question:self.model.questions[to] childIndex:index];
}

#pragma mark - QAQuestionViewSlideDelegate
- (void)questionView:(QAQuestionBaseView *)view didSlideToChildQuestion:(QAQuestion *)question{
    if (view != [self.slideView itemViewAtIndex:self.slideView.currentIndex]) {
        return;
    }
    
    QAComlexQuestionAnswerBaseView *complexView = (QAComlexQuestionAnswerBaseView *)view;
    [self.switchView updateWithTotal:self.model.questions.count question:self.model.questions[self.slideView.currentIndex] childIndex:complexView.slideView.currentIndex];
}

- (void)completeButtonAction {
    //子类提交答案时实现
}
@end
