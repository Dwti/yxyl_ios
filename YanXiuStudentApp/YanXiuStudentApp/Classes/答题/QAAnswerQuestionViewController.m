//
//  QAAnswerQuestionViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/22.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAAnswerQuestionViewController.h"
#import "QAClockView.h"
#import "QAProgressView.h"
#import "QAAnswerStateChangeDelegate.h"

@interface QAAnswerQuestionViewController ()<QAAnswerStateChangeDelegate>
@property (nonatomic, strong) GCDTimer *timer;
@property (nonatomic, strong) QAClockView *clockView;
@property (nonatomic, strong) QAProgressView *progressView;
@property (nonatomic, assign) NSInteger totalQuestionCount;
@property (nonatomic, assign) NSInteger answeredQuestionCount;
@end

@implementation QAAnswerQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.clockView = [[QAClockView alloc]initWithFrame:CGRectMake(0, 0, 150, 20)];
    self.navigationItem.titleView = self.clockView;
    WEAK_SELF
    [self nyx_setupRightWithImage:[UIImage imageWithColor:[UIColor redColor] rect:CGRectMake(0, 0, 38, 38)] action:^{
        STRONG_SELF
    }];
    [self setupProgressData];
    [self refreshProgress];
    [self setupTimer];
    [self setupObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    [super setupUI];
    self.progressView = [[QAProgressView alloc]init];
    [self.view addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(3);
    }];
}

- (void)setupProgressData {
    NSArray *qArray = [self.model allQuestions];
    self.totalQuestionCount = qArray.count;
    self.answeredQuestionCount = 0;
    for (QAQuestion *q in qArray) {
        YXQAAnswerState state = [q answerState];
        if ([self isQuestionStateAnswered:state]) {
            self.answeredQuestionCount += 1;
        }
    }
}

- (BOOL)isQuestionStateAnswered:(YXQAAnswerState)state {
    if (state == YXAnswerStateCorrect
        ||state == YXAnswerStateWrong
        ||state == YXAnswerStateAnswered) {
        return YES;
    }
    return NO;
}

- (void)refreshProgress {
    self.progressView.progress = (CGFloat)self.answeredQuestionCount/self.totalQuestionCount;
}

- (void)setupTimer {
    [self refreshTimerView];
    WEAK_SELF
    self.timer = [[GCDTimer alloc]initWithInterval:1 repeats:YES triggerBlock:^{
        STRONG_SELF
        self.model.paperAnswerDuration += 1;
        [self refreshTimerView];
    }];
    [self.timer resume];
}

- (void)refreshTimerView {
    self.clockView.secondsPassed = self.model.paperAnswerDuration;
}

- (void)setupObserver {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UIApplicationWillResignActiveNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        [self.timer suspend];
        self.slideView.isActive = NO;
    }];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UIApplicationDidBecomeActiveNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        [self.timer resume];
        self.slideView.isActive = YES;
    }];
}

#pragma mark - QASlideViewDataSource
- (QASlideItemBaseView *)slideView:(QASlideView *)slideView itemViewAtIndex:(NSInteger)index {
    QAQuestion *data = [self.model.questions objectAtIndex:index];
    
    QAQuestionViewContainer *container = [QAQuestionViewContainerFactory containerWithQuestion:data];
    QAQuestionBaseView *view = [container questionAnswerView];
    view.data = data;
    view.isPaperSubmitted = [self.model isPaperSubmitted];
    view.isSubQuestionView = NO;
//    view.addPhotoHandler = self.addPhotoHandler;
//    view.delegate = self;
    view.slideDelegate = self;
    view.answerStateChangeDelegate = self;
//    view.photoDelegate = self.addPhotoHandler;
    
    return view;
}

#pragma mark - QAAnswerStateChangeDelegate
- (void)question:(QAQuestion *)question didChangeAnswerStateFrom:(YXQAAnswerState)from to:(YXQAAnswerState)to {
    if ([self isQuestionStateAnswered:from] && ![self isQuestionStateAnswered:to]) {
        self.answeredQuestionCount--;
        [self refreshProgress];
    }else if (![self isQuestionStateAnswered:from] && [self isQuestionStateAnswered:to]) {
        self.answeredQuestionCount++;
        [self refreshProgress];
    }
}

@end
