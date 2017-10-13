//
//  QABaseViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/22.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QABaseViewController.h"
#import "UIViewController+VisibleViewController.h"
#import "VideoPlayManagerView.h"

@interface QABaseViewController ()
@property(nonatomic, strong) VideoPromptView *videoPromptView;
@property (nonatomic, strong) VideoPlayManagerView *playMangerView;

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
    [self.playMangerView viewWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.playMangerView viewWillDisappear];
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
#warning 需要后续再推敲
    [self removePlayMangerView];
    [self setupSlideVideFullScreen];
    //判断何时显示视频浮窗的按钮以及提示页
    QAQuestion *question = self.model.questions[to];
    if ([question.has_video isEqualToString:@"1"]) {
        if (![self.model.hasShowPrompt isEqualToString:@"1"]) {
            self.model.hasShowPrompt = @"1";
            //保存是否已经显示过视频
            [self showVideoPromptView];
            [[YXQADataManager sharedInstance] savePaperHasShowVideoWithPaperID:self.model.paperID hasShowVideo:self.model.hasShowPrompt];
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
    [self.playViewButton addTarget:self action:@selector(playViewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.playViewButton];
    [self.playViewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(22);
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(95, 95));
    }];
}

- (void)playViewButtonAction:(UIButton *)sender {
    [self setupPlayMangerViewWithType:VideoPlayFromType_PlayButton];
    [self setupSlideVideHalfScreen];
}

- (void)showVideoPromptView {
    AlertView *alert = [[AlertView alloc]init];
    VideoPromptView *videoPromptView = self.videoPromptView;
    videoPromptView.coverImage = [UIImage imageNamed:self.model.cover];
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
        //全屏播放视频
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setupPlayMangerViewWithType:VideoPlayFromType_PromptView];
        });
    }];
    [videoPromptView setSkipVideoBlock:^{
        STRONG_SELF
        [alert hide];
    }];
}

- (void)setupPlayMangerView {
    self.playMangerView = [[VideoPlayManagerView alloc] init];
    VideoItem *item = [[VideoItem alloc]init];
    item.videoCover = @"http://pic49.nipic.com/file/20140927/19617624_230415502002_2.jpg";
    //self.model.cover;
    item.videoName = self.model.paperTitle;
    item.videoUrl = @"http://yuncdn.teacherclub.com.cn/course/cf/xk/czsw/jxsjdysjbkjy/video/1.1_l/1.1_l.m3u8";//self.model.videoUrl;
    item.videoSize = self.model.videoSize;
    self.playMangerView.item = item;
    WEAK_SELF
    [self.playMangerView setVideoPlayManagerViewRotateScreenBlock:^(BOOL isVertical) {
        STRONG_SELF
        [self rotateScreenAction];
    }];
    [self.playMangerView setVideoPlayManagerViewBackActionBlock:^{
        STRONG_SELF
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
        [self removePlayMangerView];
    }];
    [self.playMangerView setVideoPlayManagerViewFinishBlock:^{
        STRONG_SELF
        //        [self.chapterVC readyNextWillplayVideoAgain:NO];
    }];
    [self.playMangerView setVideoPlayManagerViewPlayVideoBlock:^(VideoPlayManagerStatus status) {
        STRONG_SELF
        if (![self isNetworkReachable]) {
            self.playMangerView.playStatus = VideoPlayManagerStatus_NetworkError;
        }else {
            VideoItem *item = [[VideoItem alloc]init];
            item.videoCover = @"http://pic49.nipic.com/file/20140927/19617624_230415502002_2.jpg";
            //self.model.cover;
            item.videoName = self.model.paperTitle;
            item.videoUrl = @"http://yuncdn.teacherclub.com.cn/course/cf/xk/czsw/jxsjdysjbkjy/video/1.1_l/1.1_l.m3u8";//self.model.videoUrl;
            item.videoSize = self.model.videoSize;
            self.playMangerView.item = item;
        }
    }];
    [self.playMangerView setVideoPlayManagerViewFoldBlock:^{
        STRONG_SELF
        dispatch_async(dispatch_get_main_queue(), ^{
            [self removePlayMangerView];
            [self setupSlideVideFullScreen];
        });
    }];
    [self.view addSubview:self.playMangerView];
    [self remakeForHalfSize];
}

- (void)setupPlayMangerViewWithType:(VideoPlayFromType)type {
    self.playMangerView.type = type;
    self.playMangerView.hidden = NO;
    if (type == VideoPlayFromType_PromptView) {
        [self rotateScreenAction];
    }else {
        [self remakeForHalfSize];
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    if (size.width > size.height) {
        [self remakeForFullSize];
    }else{
        [self remakeForHalfSize];
    }
}

- (void)remakeForFullSize {
    self.playMangerView.isFullscreen = YES;
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self.playMangerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.view layoutIfNeeded];
}

- (void)remakeForHalfSize {
    self.playMangerView.isFullscreen = NO;
    self.navigationController.navigationBar.hidden = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.playMangerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(self.playMangerView.mas_width).multipliedBy(9.0 / 15.6).priority(999);
    }];
    [self.view layoutIfNeeded];
}

- (void)rotateScreenAction {
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
        [self.playMangerView playVideoClear];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations NS_AVAILABLE_IOS(6_0) {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)removePlayMangerView {
    [self.playMangerView viewWillDisappear];
    self.playMangerView.hidden = YES;
}

- (void)setupSlideVideHalfScreen {
    [self.slideView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.playMangerView.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
    [self.view layoutIfNeeded];
}

- (void)setupSlideVideFullScreen {
    [self.slideView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.view layoutIfNeeded];
}
@end

