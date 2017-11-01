//
//  VideoPlayerManagerView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/10/25.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "VideoPlayerManagerView.h"
#import "SlideProgressView.h"
#import "SlideProgressControl.h"
#import "PlayExceptionView.h"
#import "YXPlayerBufferingView.h"
#import "VideoThumbView.h"

@implementation  VideoItem
@end

@interface VideoPlayerManagerView ()
@property (nonatomic, strong) LePlayer *player;
@property (nonatomic, strong) LePlayerView *playerView;
@property (nonatomic, strong) YXPlayerBufferingView *bufferingView;
@property (nonatomic, strong) PlayBottomView *bottomView;
@property (nonatomic, strong) SlideProgressView *slideProgressView;
@property (nonatomic, strong) PlayTopView *topView;
@property (nonatomic, strong) PlayExceptionView *exceptionView;
@property (nonatomic, strong) UIButton *foldButton;
@property(nonatomic, strong) VideoThumbView *thumbView;

@property (nonatomic, strong) NSMutableArray *disposableMutableArray;
@property (nonatomic, strong) NSURL *videoUrl;

//上下状态栏显示隐藏
@property (nonatomic, strong) RACDisposable *topBottomHiddenDisposable;
@property (nonatomic, assign) BOOL isTopBottomHidden;

//主要针对主观题的半屏播放时(第一次获取权限弹窗会走UIApplicationDidBecomeActiveNotification的通知)
@property(nonatomic, assign) BOOL isCurrentView;
@end

@implementation VideoPlayerManagerView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.disposableMutableArray = [[NSMutableArray alloc] initWithCapacity:4];
        self.clipsToBounds = YES;
        [self setupUI];
        [self setupLayout];
        [self setupObserver];
        [self setupNotification];
    }
    return self;
}

#pragma mark - set
- (void)setType:(VideoPlayFromType)type {
    _type = type;
    if (type == VideoPlayFromType_PromptView && self.videoUrl) {
        self.thumbView.hidden = YES;
        self.player.videoUrl = self.videoUrl;
    }else {
        self.thumbView.hidden = NO;
    }
}

- (void)setItem:(VideoItem *)item {
    if (item == nil) {
        return;
    }
    _item = item;
    
    [self setupPlayer];
}

- (void)setupPlayer {
    self.topView.titleString = self.item.videoName;
    self.thumbView.imageUrl = self.item.videoCover;
    self.videoUrl = [NSURL URLWithString:self.item.videoUrl];
    if (![[Reachability reachabilityForInternetConnection] isReachable]) {
        self.playerStatus = YXPlayerManagerAbnormal_NetworkError;
        return;
    }
    self.player.progress = 0;
    if (isEmpty(self.videoUrl.absoluteString)) {
        self.playerStatus =  YXPlayerManagerAbnormal_Empty;
        return;
    }
    self.isWifiPlayer = NO;
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
}

- (void)setIsFullscreen:(BOOL)isFullscreen {
    _isFullscreen = isFullscreen;
    self.bottomView.isFullscreen = _isFullscreen;
    self.topView.hidden = !_isFullscreen;
    self.exceptionView.backButton.hidden = !_isFullscreen;
    self.foldButton.hidden = isFullscreen;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{//TBD: 修改进度条白点跳动问题
        [self.bottomView.slideProgressControl updateUI];
    });
}

- (void)setPlayerStatus:(YXPlayerManagerAbnormalStatus)playerStatus {
    _playerStatus = playerStatus;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.exceptionView.hidden = NO;
        self.pauseStatus = YXPlayerManagerPause_Abnormal;
        switch (self->_playerStatus) {
            case  YXPlayerManagerAbnormal_Finish:
            {
                self.exceptionView.exceptionLabel.text = @"视频课程已播放完";
                [self setNormalAttributeTitleForButton:self.exceptionView.exceptionButton withTitleString:@"点击重新观看"];
            }
                break;
            case  YXPlayerManagerAbnormal_Empty:
            {
                self.exceptionView.exceptionLabel.text = @"未找到该视频";
                [self setNormalAttributeTitleForButton:self.exceptionView.exceptionButton withTitleString:@"刷新重试"];
            }
                break;
            case  YXPlayerManagerAbnormal_NotWifi:
            {
                self.exceptionView.exceptionLabel.text = @"正在使用非WIFI环境，播放将产生流量费用";
                [self setAttributeForExceptionButton:self.exceptionView.exceptionButton];
            }
                break;
            case  YXPlayerManagerAbnormal_PlayError:
            {
                self.exceptionView.exceptionLabel.text = @"抱歉,播放出错了";
                [self setNormalAttributeTitleForButton:self.exceptionView.exceptionButton withTitleString:@"重新播放"];
            }
                break;
            case  YXPlayerManagerAbnormal_NetworkError:
            {
                self.exceptionView.exceptionLabel.text = @"网络未连接，请检查网络设置";
                [self setNormalAttributeTitleForButton:self.exceptionView.exceptionButton withTitleString:@"刷新重试"];
            }
                break;
            case  YXPlayerManagerAbnormal_DataError:
            {
                self.exceptionView.exceptionLabel.text = @"抱歉,播放出错了";
                [self setNormalAttributeTitleForButton:self.exceptionView.exceptionButton withTitleString:@"重新播放"];
            }
                break;
        }
    });
}

- (void)setPauseStatus:(YXPlayerManagerPauseStatus)pauseStatus {
    _pauseStatus = pauseStatus;
    if (_pauseStatus == YXPlayerManagerPause_Not) {
        if (self.videoUrl != nil) {
            [self setupPlayer];
        }
        [self.player play];
        self.exceptionView.hidden = YES;
    }else {
        if (self.player.state != PlayerView_State_Paused) {
            [self.player pause];
        }
    }
}

#pragma mark - setupUI
- (void)setupUI {
    self.backgroundColor = [UIColor blackColor];
    self.layer.shadowOffset = CGSizeMake(0, 30);
    self.layer.shadowRadius = 30;
    self.layer.shadowOpacity = 1;
    self.layer.shadowColor = [UIColor redColor].CGColor;
    
    [self setupPlayerView];
    [self setupBottomView];
    
    self.bufferingView = [[YXPlayerBufferingView alloc] init];
    [self addSubview:self.bufferingView];
    
    WEAK_SELF
    self.topView = [[PlayTopView alloc] init];
    [[self.topView.backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        [self.player seekTo:0];
        [self.player pause];
        BLOCK_EXEC(self.playerManagerBackActionBlock);
    }];
    [self addSubview:self.topView];
    
    self.slideProgressView = [[SlideProgressView alloc] init];
    self.slideProgressView.hidden = YES;
    [self addSubview:self.slideProgressView];
    
    [self setupExceptionView];
    
    self.foldButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.foldButton setImage:[UIImage imageNamed:@"视频收起按钮正常态-"] forState:UIControlStateNormal];
    [self.foldButton setImage:[UIImage imageNamed:@"视频收起按钮点击态"] forState:UIControlStateHighlighted];
    [[self.foldButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        [self.player seekTo:0];
        [self.player pause];
        BLOCK_EXEC(self.playerManagerFoldActionBlock);
    }];
    [self addSubview:self.foldButton];
    
    self.thumbView = [[VideoThumbView alloc]init];
    [self.thumbView setVideoThumbViewPlaydBlock:^{
        STRONG_SELF
        self.thumbView.hidden = YES;
        if (self.videoUrl) {
            self.player.videoUrl = self.videoUrl;
        }
    }];
    [self.thumbView setVideoThumbViewFoldBlock:^{
        STRONG_SELF
        BLOCK_EXEC(self.playerManagerFoldActionBlock);
    }];
    [self addSubview:self.thumbView];
}

- (void)setupLayout {
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_offset(44.0f);
    }];
    [self.bufferingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(100.0f, 100.0f));
    }];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.height.mas_offset(44.0f);
    }];
    [self.slideProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_offset(3.0f);
    }];
    
    [self.exceptionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.foldButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.size.mas_equalTo(CGSizeMake(36.f, 36.f));
    }];
    
    [self.thumbView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)setupPlayerView {
    self.player = [[LePlayer alloc] init];
    self.playerView = (LePlayerView *)[self.player playerViewWithFrame:CGRectZero];
    [self addSubview:self.playerView];
    WEAK_SELF
    UITapGestureRecognizer *playerRecognizer = [[UITapGestureRecognizer alloc] init];
    playerRecognizer.numberOfTapsRequired = 1;
    [[playerRecognizer rac_gestureSignal] subscribeNext:^(UITapGestureRecognizer *x) {
        STRONG_SELF
        x.enabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            x.enabled = YES;//防止连续点击出现UI混乱
        });
        if (self.isTopBottomHidden) {
            [self showTopView];
            [self showBottomView];
        } else {
            [self hiddenTopView];
            [self hiddenBottomView];
        }
        self.isTopBottomHidden = !self.isTopBottomHidden;
        [self resetTopBottomHideTimer];
        
    }];
    [self.playerView addGestureRecognizer:playerRecognizer];
}

- (void)setupBottomView {
    WEAK_SELF
    self.bottomView = [[PlayBottomView alloc] init];
    [self addSubview:self.bottomView];
    [[self.bottomView.playPauseButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        [self resetTopBottomHideTimer];
        if (self.player.state == PlayerView_State_Paused) {
            self.pauseStatus = YXPlayerManagerPause_Not;
        } else if (self.player.state == PlayerView_State_Finished) {
            [self.player seekTo:0];
            self.pauseStatus = YXPlayerManagerPause_Not;
        } else if (self.player.state == PlayerView_State_Playing){
            self.pauseStatus = YXPlayerManagerPause_Manual;
        }else {
            self.pauseStatus = YXPlayerManagerPause_Manual;
        }
    }];
    [[self.bottomView.rotateButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        self.bottomView.isFullscreen = !self.bottomView.isFullscreen;
        BLOCK_EXEC(self.playerManagerRotateActionBlock);
    }];
    [[self.bottomView.slideProgressControl rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        [self resetTopBottomHideTimer];
        [self.player seekTo:self.player.duration * self.bottomView.slideProgressControl.playProgress];
    }];
    [[self.bottomView.slideProgressControl rac_signalForControlEvents:UIControlEventTouchDown] subscribeNext:^(id x) {
        STRONG_SELF
        [self.topBottomHiddenDisposable dispose];
    }];
}

- (void)setupExceptionView {
    WEAK_SELF
    self.exceptionView = [[PlayExceptionView alloc] init];
    self.exceptionView.hidden = YES;
    [[self.exceptionView.exceptionButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        self.bufferingView.hidden = NO;
        [self.bufferingView start];
        self.pauseStatus = YXPlayerManagerPause_Not;
        if (self.playerStatus == YXPlayerManagerAbnormal_NotWifi) {//非WIFI情况下继续播放
            self.isWifiPlayer = YES;
            self.pauseStatus = YXPlayerManagerPause_Not;
        }else if (self.playerStatus == YXPlayerManagerAbnormal_Finish || self.playerStatus ==YXPlayerManagerAbnormal_Empty){
            self.exceptionView.hidden = YES;
            BLOCK_EXEC(self.playerManagerPlayerActionBlock,self.playerStatus);
        }else if (self.playerStatus == YXPlayerManagerAbnormal_NetworkError) {
            if ([[Reachability reachabilityForInternetConnection] isReachable]) {
                self.pauseStatus = YXPlayerManagerPause_Not;
            }
        }else {
            self.exceptionView.hidden = YES;
        }
    }];
    [[self.exceptionView.backButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        STRONG_SELF
        [self.player seekTo:0];
        [self.player pause];
        BLOCK_EXEC(self.playerManagerBackActionBlock);
    }];
    [self addSubview:self.exceptionView];
}

#pragma mark - notification
- (void)setupObserver {
    WEAK_SELF
    Reachability *r = [Reachability reachabilityForInternetConnection];
    r.reachableBlock = ^(Reachability *reachability) {
        STRONG_SELF
        if([reachability isReachableViaWWAN]) {
            if ((self.playerStatus == YXPlayerManagerAbnormal_NetworkError || self.exceptionView.hidden) && !self.isWifiPlayer ) {
                self.playerStatus = YXPlayerManagerAbnormal_NotWifi;
            }
        }
    };
    r.unreachableBlock = ^(Reachability *reachability) {
        STRONG_SELF
        if ((self.playerStatus == YXPlayerManagerAbnormal_NotWifi && !self.exceptionView.hidden) || self.player.state == PlayerView_State_Buffering ) {
            self.playerStatus = YXPlayerManagerAbnormal_NetworkError;
        }
    };
    [r startNotifier];
    
    RACDisposable *r0 = [RACObserve(self.player, state) subscribeNext:^(id x) {
        STRONG_SELF
        if ([x unsignedIntegerValue] == PlayerView_State_Buffering) {
            self.bufferingView.hidden = NO;
            [self.bufferingView start];
        } else {
            self.bufferingView.hidden = YES;
            [self.bufferingView stop];
        }
        switch ([x unsignedIntegerValue]) {
            case PlayerView_State_Buffering:
            {
                DDLogDebug(@"加载");
                if ([[Reachability reachabilityForInternetConnection] isReachable]) {
                    if([[Reachability reachabilityForInternetConnection] isReachableViaWWAN] && !self.isWifiPlayer) {
                        self.playerStatus = YXPlayerManagerAbnormal_NotWifi;
                    }
                }else {
                    self.playerStatus = YXPlayerManagerAbnormal_NetworkError;
                }
            }
                break;
            case PlayerView_State_Playing:
            {
                self.exceptionView.hidden = YES;
                DDLogDebug(@"播放");
                [self.bottomView.playPauseButton setImage:[UIImage imageNamed:@"暂停按钮-正常态"] forState:UIControlStateNormal];
                [self.bottomView.playPauseButton setImage:[UIImage imageNamed:@"暂停按钮-点击态"] forState:UIControlStateHighlighted];
            }
                break;
            case PlayerView_State_Paused:
            {
                DDLogDebug(@"暂停");
                [self.bottomView.playPauseButton setImage:[UIImage imageNamed:@"视频播放按钮正常态"] forState:UIControlStateNormal];
                [self.bottomView.playPauseButton setImage:[UIImage imageNamed:@"视频播放按钮点击态"] forState:UIControlStateHighlighted];
            }
                break;
            case PlayerView_State_Finished:
            {
                DDLogDebug(@"完成");
                [self playVideoFinished];
            }
                break;
            case PlayerView_State_Error:
            {
                DDLogDebug(@"错误");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.bufferingView stop];
                    self.bufferingView.hidden = YES;
                    self.playerStatus = YXPlayerManagerAbnormal_PlayError;
                });
                break;
            }
            default:
                break;
        }
    }];
    
    RACDisposable *r1 = [RACObserve(self.player, duration) subscribeNext:^(id x) {
        STRONG_SELF
        self.bottomView.slideProgressControl.duration = [x doubleValue];
        [self.bottomView.slideProgressControl updateUI];
    }];
    
    RACDisposable *r2 = [RACObserve(self.player, timeBuffered) subscribeNext:^(id x) {
        STRONG_SELF
        if (self.bottomView.slideProgressControl.bSliding) {
            return;
        }
        if (self.bottomView.slideProgressControl.duration > 0) {
            CGFloat bufferProgress = [x floatValue] / self.bottomView.slideProgressControl.duration;
            self.bottomView.slideProgressControl.bufferProgress = bufferProgress;
            self.slideProgressView.bufferProgress = bufferProgress;
            if (self.bottomView.slideProgressControl.bufferProgress > 0) {
                [self.bottomView.slideProgressControl updateUI];
            }
        }
    }];
    
    RACDisposable *r3 = [RACObserve(self.player, timePlayed) subscribeNext:^(id x) {
        STRONG_SELF
        if (self.bottomView.slideProgressControl.bSliding) {
            return;
        }
        if (self.bottomView.slideProgressControl.duration > 0) {
            CGFloat playProgres = [x floatValue] / self.bottomView.slideProgressControl.duration;
            self.bottomView.slideProgressControl.playProgress = playProgres;
            self.slideProgressView.playProgress = playProgres;
            if (self.bottomView.slideProgressControl.playProgress > 0) { // walkthrough 换url时slide跳动
                [self.bottomView.slideProgressControl updateUI];
            }
        }
    }];
    
    RACDisposable *r4 = [RACObserve(self.player, isBuffering) subscribeNext:^(id x) {
        STRONG_SELF
        if (self.player.isBuffering) {
            self.bufferingView.hidden = NO;
            [self.bufferingView start];
        } else {
            self.bufferingView.hidden = YES;
            [self.bufferingView stop];
        }
    }];
    
    [self.disposableMutableArray addObject:r0];
    [self.disposableMutableArray addObject:r1];
    [self.disposableMutableArray addObject:r2];
    [self.disposableMutableArray addObject:r3];
    [self.disposableMutableArray addObject:r4];
}

- (void)setupNotification {
    WEAK_SELF
    //进入后台
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationWillResignActiveNotification object:nil] subscribeNext:^(NSNotification *x) {
        STRONG_SELF
        if (self.pauseStatus == YXPlayerManagerPause_Not) {
            self.pauseStatus = YXPlayerManagerPause_Backstage;
        }
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidBecomeActiveNotification object:nil] subscribeNext:^(id x) {
        STRONG_SELF
        if (self.pauseStatus == YXPlayerManagerPause_Backstage && !self.hidden && self.isCurrentView) {
            self.pauseStatus = YXPlayerManagerPause_Not;
        }
    }];
}

#pragma mark - hidden show
- (void)resetTopBottomHideTimer {
    [self.topBottomHiddenDisposable  dispose];
    WEAK_SELF
    self.topBottomHiddenDisposable = [[RACSignal interval:5.0f onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
        STRONG_SELF
        [self topBottomHideTimerAction];
    }];
}

- (void)topBottomHideTimerAction {
    [self hiddenTopView];
    [self hiddenBottomView];
    self.isTopBottomHidden = YES;
}

- (void)hiddenTopView {
    [UIView animateWithDuration:0.6 animations:^{
        [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(-44.0f);
        }];
        [self layoutIfNeeded];
    }];
}

- (void)hiddenBottomView {
    [UIView animateWithDuration:0.6f animations:^{
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(44.0f);
        }];
        [self layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        if (finished) {
            self.slideProgressView.hidden = NO;
        }
    }];
}

- (void)showTopView {
    [UIView animateWithDuration:0.6 animations:^{
        [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
        }];
        [self layoutIfNeeded];
    }];
}

- (void)showBottomView {
    self.slideProgressView.hidden = YES;
    [UIView animateWithDuration:0.6f animations:^{
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

- (void)playVideoFinished {
    self.bottomView.slideProgressControl.playProgress = 0.0f;
    self.slideProgressView.playProgress = 0.0f;
    self.bottomView.slideProgressControl.bufferProgress = 0.0f;
    self.slideProgressView.bufferProgress = 0.0f;
    [self.bottomView.slideProgressControl updateUI];
    [self.bottomView.playPauseButton setImage:[UIImage imageNamed:@"视频播放按钮正常态"] forState:UIControlStateNormal];
    [self.bottomView.playPauseButton setImage:[UIImage imageNamed:@"视频播放按钮点击态"] forState:UIControlStateHighlighted];
    BLOCK_EXEC(self.playerManagerFinishActionBlock);
    self.item = nil;
}

#pragma mark -
- (void)viewWillAppear {
    self.isCurrentView = YES;
}

- (void)viewWillDisappear {
    self.isCurrentView = NO;
}

- (void)playVideo {
    [self.player play];
}

- (void)pauseVideo {
    [self.player pause];
}

- (void)playVideoClear {
    [self.player pause];
    self.player = nil;
    [self.topBottomHiddenDisposable  dispose];
    [self.disposableMutableArray enumerateObjectsUsingBlock:^(RACDisposable * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj dispose];
    }];
    [self.disposableMutableArray removeAllObjects];
}

#pragma mark - expentionButton
- (void)setNormalAttributeTitleForButton:(UIButton *)button withTitleString:(NSString *)titleString {
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:titleString];
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"89e00d"] range:NSMakeRange(0, attribute.length)];
    [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0f] range:NSMakeRange(0,attribute.length)];
    
    NSMutableAttributedString *attribute1 = [[NSMutableAttributedString alloc]initWithString:titleString];
    [attribute1 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attribute.length)];
    [attribute1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0f] range:NSMakeRange(0,attribute.length)];
    [button setAttributedTitle:attribute forState:UIControlStateNormal];
    [button setAttributedTitle:attribute1 forState:UIControlStateHighlighted];
}

- (void)setAttributeForExceptionButton:(UIButton *)button{
    NSString *size = [self sizeStringForBytes:self.item.videoSize.integerValue];
    NSString *desc = @"流量";
    NSString *str = [NSString stringWithFormat:@"%@%@",size,desc];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:str];
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"89e00d"] range:NSMakeRange(0, attribute.length)];
    [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0f] range:NSMakeRange(0,attribute.length)];
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(size.length, desc.length)];
    [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0f] range:NSMakeRange(size.length,desc.length)];
    
    NSMutableAttributedString *attribute1 = [[NSMutableAttributedString alloc]initWithString:str];
    [attribute1 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attribute.length)];
    [attribute1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0f] range:NSMakeRange(0,attribute.length)];
    [button setAttributedTitle:attribute forState:UIControlStateNormal];
    [button setAttributedTitle:attribute1 forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:@"视频无wifi播放按钮正常态"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"视频无wifi播放按点击态"] forState:UIControlStateHighlighted];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -7, 0, 0);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -7);
}

- (NSString *)sizeStringForBytes:(unsigned long long)aBytes {
    // 小于1KB
    if (aBytes < 1024) {
        return @"< 1K";
    }
    
    // 1KB - 1MB
    if ((aBytes >= 1024) && (aBytes < 1024*1024)) {
        float kb = (float)aBytes / 1024.f;
        return [NSString stringWithFormat:@"%.2fK", kb];
    }
    
    // 1MB - 1GB
    if ((aBytes >= 1024*1024) && (aBytes < 1024*1024*1024)) {
        float mb = (float)aBytes / (1024.f*1024.f);
        return [NSString stringWithFormat:@"%.2fM", mb];
    }
    
    // 大于等于1GB
    if (aBytes >= 1024*1024*1024) {
        float gb = (float)aBytes / (1024.f*1024.f*1024.f);
        return [NSString stringWithFormat:@"%.2fG", gb];
    }
    
    return @"";
}
@end
