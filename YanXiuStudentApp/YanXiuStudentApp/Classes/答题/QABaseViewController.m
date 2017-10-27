//
//  QABaseViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/22.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QABaseViewController.h"
#import "UIViewController+VisibleViewController.h"
#import "VideoPlayerManagerView.h"
#import "QAAnalysisViewController.h"

@interface QABaseViewController ()
@property(nonatomic, strong) VideoPromptView *videoPromptView;
@property (nonatomic, strong) VideoPlayerManagerView *playerMangerView;
@property (nonatomic, assign) BOOL shouldRotate;
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
    self.model.hasShowPrompt = [[YXQADataManager sharedInstance] loadPaperHasShowVideoWithPaperID:self.model.paperID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.layer.shadowColor = [UIColor clearColor].CGColor;
    [self.playerMangerView viewWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.playerMangerView viewWillDisappear];
    [self.playerMangerView pauseVideo];
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
    
    [self setupPlayVideoButton];
    self.videoPromptView = [[VideoPromptView alloc]init];
    
    [self setupPlayMangerView];
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
    
    [self hidePlayerMangerView];
    QAQuestion *question = self.model.questions[to];
    if ([question.has_video isEqualToString:@"1"]) {//有视频的才进行判断显示视频按钮以及显示视频提示页
        if (![self isKindOfClass:[QAAnalysisViewController class]]) {//解析不显示视频提示页
            if (![self.model.hasShowPrompt isEqualToString:@"1"]) {
                self.model.hasShowPrompt = @"1";
                [self showVideoPromptView];
                [[YXQADataManager sharedInstance] savePaperHasShowVideoWithPaperID:self.model.paperID hasShowVideo:self.model.hasShowPrompt];
            }
        }
        self.playViewButton.hidden = NO;
    }else {
        self.playViewButton.hidden = YES;
    }
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

#pragma mark - be related to BCResource
- (void)setupPlayVideoButton {
    self.playViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playViewButton setImage:[UIImage imageNamed:@"视频浮窗正常态"] forState:UIControlStateNormal];
    [self.playViewButton setImage:[UIImage imageNamed:@"视频浮窗点击态"] forState:UIControlStateHighlighted];
    WEAK_SELF
    [[self.playViewButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        [self setupPlayMangerViewWithType:VideoPlayFromType_PlayButton];
    }];
    [self.view addSubview:self.playViewButton];
    [self.playViewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(22);
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(95, 95));
    }];
}

- (void)setupPlayMangerView {
    self.playerMangerView = [[VideoPlayerManagerView alloc] init];
    VideoItem *item = [[VideoItem alloc]init];
    item.videoCover = self.model.cover;//@"http://pic49.nipic.com/file/20140927/19617624_230415502002_2.jpg";
    item.videoName = self.model.paperTitle;
    item.videoUrl = self.model.videoUrl;//@"http://yuncdn.teacherclub.com.cn/course/cf/xk/czsw/jxsjdysjbkjy/video/1.1_l/1.1_l.m3u8";//self.model.videoUrl;
    item.videoSize = self.model.videoSize;
    self.playerMangerView.item = item;
    WEAK_SELF
    [self.playerMangerView setPlayerManagerRotateActionBlock:^{
        STRONG_SELF
        [self rotateScreenAction];
    }];
    [self.playerMangerView setPlayerManagerBackActionBlock:^{
        STRONG_SELF
        [self rotateScreenAction];
        [self hidePlayerMangerView];
        self.shouldRotate = YES;
    }];
    [self.playerMangerView setPlayerManagerFinishActionBlock:^{
        STRONG_SELF
        [self hidePlayerMangerView];
    }];
    [self.playerMangerView setPlayerManagerPlayerActionBlock:^(YXPlayerManagerAbnormalStatus status) {
        STRONG_SELF
        if (![self isNetworkReachable]) {
            self.playerMangerView.playerStatus = YXPlayerManagerAbnormal_NetworkError;
        }else {
            [self.playerMangerView playVideo];
        }
    }];
    [self.playerMangerView setPlayerManagerFoldActionBlock:^{
        STRONG_SELF
        [self hidePlayerMangerView];
    }];
    [self.view addSubview:self.playerMangerView];
    self.playerMangerView.isFullscreen = NO;
    [self.playerMangerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(self.playerMangerView.mas_width).multipliedBy(9.0 / 15.6).priority(999);
    }];
}

- (void)setupPlayMangerViewWithType:(VideoPlayFromType)type {
    self.playerMangerView.type = type;
    [self showPlayerMangerView];
    if (type == VideoPlayFromType_PromptView) {
        [self rotateScreenAction];
    }else {
        [self remakePlayerMangerViewForHalfSize];
    }
}

- (void)showVideoPromptView {
    AlertView *alert = [[AlertView alloc]init];
    VideoPromptView *videoPromptView = self.videoPromptView;
    videoPromptView.coverImage = self.model.cover;
    if (!videoPromptView) {
        videoPromptView = [[VideoPromptView alloc]init];
    }
    alert.contentView = videoPromptView;
    WEAK_SELF
    [alert showWithLayout:^(AlertView *view) {
        STRONG_SELF
        [videoPromptView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(315 * kPhoneWidthRatio, 400 * kPhoneWidthRatio));
        }];
        [view layoutIfNeeded];
    }];
    [videoPromptView setPlayVideoBlock:^{
        STRONG_SELF
        [alert hide];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setupPlayMangerViewWithType:VideoPlayFromType_PromptView];
        });
    }];
    [videoPromptView setSkipVideoBlock:^{
        STRONG_SELF
        [alert hide];
    }];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    if (size.width > size.height) {
        [self remakePlayerMangerViewForFullSize];
    }else{
        [self remakePlayerMangerViewForHalfSize];
    }
}

- (void)remakePlayerMangerViewForFullSize {
    self.playerMangerView.isFullscreen = YES;
    self.navigationController.navigationBar.hidden = YES;
    [self.playerMangerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)remakePlayerMangerViewForHalfSize {
    self.playerMangerView.isFullscreen = NO;
    self.navigationController.navigationBar.hidden = NO;
    [self.playerMangerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(self.playerMangerView.mas_width).multipliedBy(9.0 / 15.6).priority(999);
    }];
}

- (void)rotateScreenAction {
    self.shouldRotate = YES;
    UIInterfaceOrientation screenDirection = [UIApplication sharedApplication].statusBarOrientation;
    if(screenDirection == UIInterfaceOrientationLandscapeLeft || screenDirection ==UIInterfaceOrientationLandscapeRight){
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    }else{
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
    }
}

- (void)backAction{
    UIInterfaceOrientation screenDirection = [UIApplication sharedApplication].statusBarOrientation;
    if(screenDirection == UIInterfaceOrientationLandscapeLeft || screenDirection == UIInterfaceOrientationLandscapeRight){
        [self rotateScreenAction];
    }else{
        [self.playerMangerView playVideoClear];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)shouldAutorotate {
    return self.shouldRotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations NS_AVAILABLE_IOS(6_0) {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)hidePlayerMangerView {
    [self.playerMangerView pauseVideo];
    self.playerMangerView.hidden = YES;
}

- (void)showPlayerMangerView {
    self.playerMangerView.hidden = NO;
    [self.playerMangerView.superview bringSubviewToFront:self.playerMangerView];
}

@end

