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
#import "QAAnswerSheetViewController.h"
#import "SimpleAlertView.h"
#import "QAImageUploadProgressView.h"

@interface QAAnswerQuestionViewController ()<QAAnswerStateChangeDelegate>
@property (nonatomic, strong) GCDTimer *timer;
@property (nonatomic, strong) QAClockView *clockView;
@property (nonatomic, strong) QAProgressView *progressView;
@property (nonatomic, assign) NSInteger totalQuestionCount;
@property (nonatomic, assign) NSInteger answeredQuestionCount;
@property (nonatomic, strong) NSDate *beginDate;

@end

@implementation QAAnswerQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.model.paperAnswerDuration = [[YXQADataManager sharedInstance]loadPaperDurationWithPaperID:self.model.paperID];
    for (QAQuestion *q in [self.model allQuestions]) {
        [q loadAnswer];
    }
    self.clockView = [[QAClockView alloc]initWithFrame:CGRectMake(0, 0, 150, 20)];
    self.navigationItem.titleView = self.clockView;
    WEAK_SELF
    [self nyx_setupRightWithImage:[UIImage imageWithColor:[UIColor redColor] rect:CGRectMake(0, 0, 38, 38)] action:^{
        STRONG_SELF
        [self showAnswerSheet];
    }];
    
    [self setupProgressData];
    [self refreshProgress];
    [self setupTimer];
    [self setupObserver];
    self.beginDate = [NSDate date];
}

- (void)backAction {
    
    if (self.pType == YXPTypeGroupHomework) {
        [[YXQADataManager sharedInstance]savePaperDurationWithPaperID:self.model.paperID duration:self.model.paperAnswerDuration];
        [[YXQADataManager sharedInstance]savePaperAnsweredQuestionNumWithPaperModel:self.model];
        [super backAction];
        return;
    }
    
    BOOL unAnswered = TRUE;
    for (QAQuestion *item in [self.model allQuestions]) {
        if (item.answerState != YXAnswerStateNotAnswer) {
            unAnswered = FALSE;
            break;
        }
    }
    if (self.model.paperStatusID) {
        unAnswered = FALSE;
    }
    if (unAnswered) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    [self.model.allQuestions enumerateObjectsUsingBlock:^(QAQuestion * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj clearAnswer];
    }];
    WEAK_SELF
    SimpleAlertView *alert = [[SimpleAlertView alloc] init];
    alert.describe = @"退出答题后，你可以在练习历史中找到作答记录并继续答题";
    alert.image = [UIImage imageNamed:@"提交成功图标"];
    [alert addButtonWithTitle:@"取消" style:SimpleAlertActionStyle_Cancel action:^{
        STRONG_SELF
        self.slideView.isActive = YES;
    }];
    [alert addButtonWithTitle:@"继续退出" style:SimpleAlertActionStyle_Default action:^{
        STRONG_SELF
        [self saveAndQuit];
    }];
    [alert showInView:self.navigationController.view];
}

- (void)saveAndQuit {
    if (![self isNetworkReachable]) {
        WEAK_SELF
        SimpleAlertView *alert = [[SimpleAlertView alloc] init];
        alert.describe = @"当前网络异常，退出答题进度将无法保存";
        alert.image = [UIImage imageNamed:@"提交成功图标"];
        [alert addButtonWithTitle:@"取消" style:SimpleAlertActionStyle_Cancel action:^{
            STRONG_SELF
            self.slideView.isActive = YES;
        }];
        [alert addButtonWithTitle:@"继续退出" style:SimpleAlertActionStyle_Default action:^{
            STRONG_SELF
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert showInView:self.navigationController.view];
        return;
    }
    WEAK_SELF
    [self.view nyx_startLoading];
    [[YXQADataManager sharedInstance]savePaperToHistoryWithModel:self.model beginDate:self.beginDate completeBlock:^(NSError *error) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self handleSaveFailure:error];
            return;
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)handleSaveFailure:(NSError *)error {
    if ([self isNetworkReachable]) {
        [self.view nyx_showToast:error.localizedDescription];
        return;
    }
    WEAK_SELF
    SimpleAlertView *alert = [[SimpleAlertView alloc] init];
    alert.title = @"保存失败，请检查网络后重试";
    alert.image = [UIImage imageNamed:@"提交成功图标"];
    [alert addButtonWithTitle:@"取消" style:SimpleAlertActionStyle_Cancel action:^{
        STRONG_SELF
    }];
    [alert addButtonWithTitle:@"再试一次" style:SimpleAlertActionStyle_Default action:^{
        STRONG_SELF
        [self saveAndQuit];
    }];
    [alert showInView:self.navigationController.view];
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

- (void)completeButtonAction {
    [self showAnswerSheet];
}

- (void)showAnswerSheet {
    self.slideView.isActive = NO;
    if ([self.navigationController.childViewControllers.lastObject isKindOfClass:[QAAnswerSheetViewController class]]) {
        return;
    }
    QAAnswerSheetViewController *vc = [[QAAnswerSheetViewController alloc]init];
    vc.model = self.model;
    vc.pType = self.pType;
    vc.requestParams = self.requestParams;
    vc.answeredQuestionCount = self.answeredQuestionCount;
    vc.totalQuestionCount = self.totalQuestionCount;
    WEAK_SELF
    [vc setSelectedActionBlock:^(QAQuestion *item) {
        STRONG_SELF
        [self slideToQAItem:item];
        self.slideView.isActive = YES;
    }];
    [vc setBackActionBlock:^{
        STRONG_SELF
        self.slideView.isActive = YES;
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)slideToQAItem:(QAQuestion *)item {
    [self.slideView scrollToItemIndex:item.position.firstLevelIndex animated:NO];
    QAComlexQuestionAnswerBaseView *mv = (QAComlexQuestionAnswerBaseView *)[self.slideView itemViewAtIndex:self.slideView.currentIndex];
    if ([mv isKindOfClass:[QAComlexQuestionAnswerBaseView class]]) {
        mv.nextLevelStartIndex = item.position.secondLevelIndex;
        [mv.slideView scrollToItemIndex:item.position.secondLevelIndex animated:NO];
    }
}

#pragma mark - QASlideViewDataSource
- (QASlideItemBaseView *)slideView:(QASlideView *)slideView itemViewAtIndex:(NSInteger)index {
    QAQuestion *data = [self.model.questions objectAtIndex:index];
    
    QAQuestionViewContainer *container = [QAQuestionViewContainerFactory containerWithQuestion:data];
    QAQuestionBaseView *view = [container questionAnswerView];
    view.data = data;
    view.isPaperSubmitted = [self.model isPaperSubmitted];
    view.isSubQuestionView = NO;
    view.slideDelegate = self;
    view.answerStateChangeDelegate = self;
    
    return view;
}

#pragma mark - QASlideViewDelegate
- (void)slideViewDidReachMostRight:(QASlideView *)slideView{
    QASlideItemBaseView *view = [self.slideView itemViewAtIndex:slideView.currentIndex];
    if ([view isKindOfClass:[QAComlexQuestionAnswerBaseView class]]) {
        QAComlexQuestionAnswerBaseView *complexView = (QAComlexQuestionAnswerBaseView *)view;
        CGPoint p = [slideView.panGesture locationInView:complexView.slideView];
        if (CGRectContainsPoint(complexView.slideView.bounds, p)) {
            if (complexView.slideView.currentIndex != complexView.data.childQuestions.count-1) {
                return;
            }
        }
    }
    [self showAnswerSheet];
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
