//
//  QAAnalysisViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/22.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAAnalysisViewController.h"
#import "YXQAAnalysisDataConfig.h"
#import "QAReportErrorViewController.h"

@interface QAAnalysisViewController ()
@property (nonatomic, strong) YXQAAnalysisDataConfig *analysisDataDelegate;
@end

@implementation QAAnalysisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"题目解析";
    UIButton *naviRightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 35)];
    [naviRightButton setTitle:@"报错" forState:UIControlStateNormal];
    [naviRightButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    [naviRightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [naviRightButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"cccccc"]] forState:UIControlStateHighlighted];
    naviRightButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    naviRightButton.layer.cornerRadius = 6;
    naviRightButton.layer.borderWidth = 2;
    naviRightButton.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
    naviRightButton.clipsToBounds = YES;
    WEAK_SELF
    [[naviRightButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        STRONG_SELF
        [self reportError];
    }];
    [self nyx_setupRightWithCustomView:naviRightButton];
    
    self.analysisDataDelegate = [[YXQAAnalysisDataConfig alloc]init];
    self.slideView.currentIndex = self.firstLevel;
    self.switchView.lastButtonHidden = YES;
    if (self.model.allQuestions.count == 1) {
        self.switchView.hidden = YES;
    }else {
        self.switchView.hidden = NO;
    }
}

- (void)reportError {
    QAQuestion *question = self.model.questions[self.slideView.currentIndex];
    QAReportErrorViewController * viewController = [[QAReportErrorViewController alloc] init];
    viewController.questionID = question.questionID;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - QASlideViewDataSource
- (QASlideItemBaseView *)slideView:(QASlideView *)slideView itemViewAtIndex:(NSInteger)index {
    QAQuestion *data = [self.model.questions objectAtIndex:index];
    
    QAQuestionViewContainer *container = [QAQuestionViewContainerFactory containerWithQuestion:data];
    QAQuestionBaseView *view = [container questionAnalysisView];
    view.data = data;
    view.isPaperSubmitted = [self.model isPaperSubmitted];
    view.title = self.model.paperTitle;
    view.isSubQuestionView = NO;
    view.slideDelegate = self;
    //    view.canDoExerciseFromKnp = self.canDoExerciseFromKnp;
    //    view.pointClickDelegate = self;
    //    view.reportErrorDelegate = self;
    //    view.editNoteDelegate = self;
    view.analysisDataDelegate = self.analysisDataDelegate;
    if (index == self.firstLevel) {
        if (self.secondLevel >= 0) {
            view.nextLevelStartIndex = self.secondLevel;
            self.secondLevel = -1;
        }
    }
    
    return view;
}


@end
