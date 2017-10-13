//
//  VideoPlayManagerView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/10/13.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "VideoPlayManagerView.h"
#import "SlideProgressView.h"
#import "SlideProgressControl.h"
#import "PlayExceptionView.h"
#import "YXPlayerBufferingView.h"
#import "VideoThumbView.h"

@implementation VideoItem
@end

static const NSTimeInterval kTopBottomHiddenTime = 5;
@interface VideoPlayManagerView()

@property (nonatomic, strong) LePlayer *player;
@property (nonatomic, strong) LePlayerView *playerView;
@property (nonatomic, strong) YXPlayerBufferingView *bufferingView;
@property (nonatomic, strong) PlayBottomView *bottomView;
@property (nonatomic, strong) SlideProgressView *slideProgressView;
@property (nonatomic, strong) PlayTopView *topView;
@property (nonatomic, strong) PlayExceptionView *exceptionView;
@property (nonatomic, strong) UIButton *foldButton;
@property(nonatomic, strong) VideoThumbView *thumbView;

@property (nonatomic, copy) VideoPlayManagerViewBackActionBlock backBlock;
@property (nonatomic, copy) VideoPlayManagerViewRotateScreenBlock rotateBlock;
@property (nonatomic, copy) VideoPlayManagerViewPlayVideoBlock playBlock;
@property (nonatomic, copy) VideoPlayManagerViewFinishBlock finishBlock;
@property (nonatomic, copy) VideoPlayManagerViewFoldBlock foldBlock;

@property (nonatomic, strong) NSMutableArray *disposableMutableArray;
@property (nonatomic, strong) NSTimer *topBottomHideTimer;
@property (nonatomic, assign) BOOL isTopBottomHidden;
@property (nonatomic, strong) NSURL *videoUrl;
@property (nonatomic, assign) BOOL isFirstBool;
@property (nonatomic, assign) BOOL isManualPause;
@end

@implementation VideoPlayManagerView
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.disposableMutableArray = [[NSMutableArray alloc] initWithCapacity:5];
        self.clipsToBounds = YES;
        self.isFirstBool = YES;
        [self setupUI];
        [self setupLayout];
        [self setupObserver];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI {
    self.backgroundColor = [UIColor blackColor];
    self.layer.shadowOffset = CGSizeMake(0, 30);
    self.layer.shadowRadius = 30;
    self.layer.shadowOpacity = 1;
    self.layer.shadowColor = [UIColor redColor].CGColor;
    
    self.player = [[LePlayer alloc] init];
    self.playerView = (LePlayerView *)[self.player playerViewWithFrame:CGRectZero];
    [self addSubview:self.playerView];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)];
    recognizer.numberOfTapsRequired = 1;
    [self.playerView addGestureRecognizer:recognizer];
    
    self.bottomView = [[PlayBottomView alloc] init];
    [self addSubview:self.bottomView];
    [self.bottomView.playPauseButton addTarget:self action:@selector(playAndPauseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView.rotateButton addTarget:self action:@selector(rotateScreenButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView.slideProgressControl addTarget:self action:@selector(progressAction) forControlEvents:UIControlEventTouchUpInside];
    self.bufferingView = [[YXPlayerBufferingView alloc] init];
    [self addSubview:self.bufferingView];
    
    self.topView = [[PlayTopView alloc] init];
    [self.topView.backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.topView];
    
    self.slideProgressView = [[SlideProgressView alloc] init];
    self.slideProgressView.hidden = YES;
    [self addSubview:self.slideProgressView];
    
    self.exceptionView = [[PlayExceptionView alloc] init];
    [self.exceptionView.exceptionButton  addTarget:self action:@selector(exceptionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.exceptionView.hidden = YES;
    [self addSubview:self.exceptionView];
    
    self.foldButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.foldButton setImage:[UIImage imageNamed:@"视频收起按钮正常态-"] forState:UIControlStateNormal];
    [self.foldButton setImage:[UIImage imageNamed:@"视频收起按钮点击态"] forState:UIControlStateHighlighted];
    [self.foldButton addTarget:self action:@selector(foldButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.foldButton];
    
    self.thumbView = [[VideoThumbView alloc]init];
    WEAK_SELF
    [self.thumbView setVideoThumbViewPlaydBlock:^{
        STRONG_SELF
        self.thumbView.hidden = YES;
        if (self.videoUrl) {
            self.player.videoUrl = self.videoUrl;
        }
        self.isFirstBool = NO;
    }];
    [self.thumbView setVideoThumbViewFoldBlock:^{
        STRONG_SELF
        [self foldButtonAction];
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

#pragma mark - notification
- (void)setupObserver {
    Reachability *r = [Reachability reachabilityForInternetConnection];
    @weakify(r);
    WEAK_SELF
    [r setReachableBlock:^void (Reachability * reachability) {
        @strongify(r);
        STRONG_SELF
        if([r isReachableViaWiFi]) {
            return;
        }
        if([r isReachableViaWWAN]) {
            [self do3GCheck];
        }
    }];
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
                self.thumbView.hidden = YES;
                if(![r isReachable]) {
                    self.playStatus = VideoPlayManagerStatus_NetworkError;
                }
            }
                break;
            case PlayerView_State_Playing:
            {
                [self.bottomView.playPauseButton setImage:[UIImage imageNamed:@"暂停按钮-正常态"] forState:UIControlStateNormal];
                [self.bottomView.playPauseButton setImage:[UIImage imageNamed:@"暂停按钮-点击态"] forState:UIControlStateHighlighted];

            }
                break;
            case PlayerView_State_Paused:
            {
                [self.bottomView.playPauseButton setImage:[UIImage imageNamed:@"视频播放按钮正常态"] forState:UIControlStateNormal];
                [self.bottomView.playPauseButton setImage:[UIImage imageNamed:@"视频播放按钮点击态"] forState:UIControlStateHighlighted];
            }
                break;
            case PlayerView_State_Finished:
            {
                [self playVideoFinished];
                self.thumbView.hidden = NO;
            }
                break;
            case PlayerView_State_Error:
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.bufferingView stop];
                    self.bufferingView.hidden = YES;
                    self.playStatus = VideoPlayManagerStatus_PlayError;
                });
                break;
            }
            default:
                break;
        }
    }];
    
    RACDisposable *r1 = [self.player rac_observeKeyPath:@"bIsPlayable"
                                                options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                               observer:self
                                                  block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
                                                      STRONG_SELF
                                                      if ([value boolValue]) {
                                                          self.bufferingView.hidden = YES;
                                                          [self.bufferingView stop];
                                                          [self showTopView];
                                                          [self showBottomView];
                                                          self.isTopBottomHidden = NO;
                                                          [self resetTopBottomHideTimer];
                                                      }
                                                  }];
    
    RACDisposable *r2 = [RACObserve(self.player, duration) subscribeNext:^(id x) {
        STRONG_SELF
        self.bottomView.slideProgressControl.duration = [x doubleValue];
        [self.bottomView.slideProgressControl updateUI];
    }];
    
    RACDisposable *r3 = [RACObserve(self.player, timeBuffered) subscribeNext:^(id x) {
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
    
    RACDisposable *r4 = [RACObserve(self.player, timePlayed) subscribeNext:^(id x) {
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
    
    [self.disposableMutableArray addObject:r0];
    [self.disposableMutableArray addObject:r1];
    [self.disposableMutableArray addObject:r2];
    [self.disposableMutableArray addObject:r3];
    [self.disposableMutableArray addObject:r4];
}
- (void)do3GCheck {
    [self.player pause];
    self.playStatus = VideoPlayManagerStatus_NotWifi;
}

#pragma mark - top / bottom hide
- (void)tapGestureRecognizer:(UITapGestureRecognizer *)tap {
    tap.enabled = NO;
    if (self.isTopBottomHidden) {
        [self showTopView];
        [self showBottomView];
    } else {
        [self hiddenTopView];
        [self hiddenBottomView];
    }
    self.isTopBottomHidden = !self.isTopBottomHidden;
    [self resetTopBottomHideTimer];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        tap.enabled = YES;
    });
}

- (void)resetTopBottomHideTimer {
    [self.topBottomHideTimer invalidate];
    self.topBottomHideTimer = [NSTimer scheduledTimerWithTimeInterval:kTopBottomHiddenTime
                                                               target:self
                                                             selector:@selector(topBottomHideTimerAction)
                                                             userInfo:nil
                                                              repeats:YES];
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

- (void)progressAction {
    [self resetTopBottomHideTimer];
    [self.player seekTo:self.player.duration * self.bottomView.slideProgressControl.playProgress];
}

- (void)playVideoFinished {
    self.bottomView.slideProgressControl.playProgress = 0.0f;
    self.slideProgressView.playProgress = 0.0f;
    self.bottomView.slideProgressControl.bufferProgress = 0.0f;
    self.slideProgressView.bufferProgress = 0.0f;
    [self.bottomView.slideProgressControl updateUI];
    [self.bottomView.playPauseButton setImage:[UIImage imageNamed:@"视频播放按钮正常态"] forState:UIControlStateNormal];
    [self.bottomView.playPauseButton setImage:[UIImage imageNamed:@"视频播放按钮点击态"] forState:UIControlStateHighlighted];
    BLOCK_EXEC(self.backBlock);
}

#pragma mark - button Action
- (void)playAndPauseButtonAction:(UIButton *)sender{
    [self resetTopBottomHideTimer];
    if (self.player.state == PlayerView_State_Paused) {
        [self.player play];
        self.isManualPause = NO;
    } else if (self.player.state == PlayerView_State_Finished) {
        [self.player seekTo:0];
        [self.player play];
        self.isManualPause = NO;
    } else {
        [self.player pause];
        self.isManualPause = YES;
    }
}
- (void)rotateScreenButtonAction:(UIButton *)sender {
    self.bottomView.isFullscreen = !self.bottomView.isFullscreen;
    self.foldButton.hidden = self.bottomView.isFullscreen;
    BLOCK_EXEC(self.rotateBlock,self.bottomView.isFullscreen)
}

- (void)foldButtonAction {
    BLOCK_EXEC(self.foldBlock);
}

- (void)backButtonAction:(UIButton *)sender {
    BLOCK_EXEC(self.backBlock);
}

- (void)exceptionButtonAction:(UIButton *)sender {
    self.bufferingView.hidden = NO;
    [self.bufferingView start];
    if (self.playStatus == VideoPlayManagerStatus_NotWifi) {
        [self.player play];
    }else {
        BLOCK_EXEC(self.playBlock,self.playStatus);
    }
    self.exceptionView.hidden = YES;
}

#pragma mark - set
- (void)setVideoPlayManagerViewBackActionBlock:(VideoPlayManagerViewBackActionBlock)block {
    self.backBlock = block;
}

- (void)setVideoPlayManagerViewRotateScreenBlock:(VideoPlayManagerViewRotateScreenBlock)block {
    self.rotateBlock = block;
}

- (void)setVideoPlayManagerViewPlayVideoBlock:(VideoPlayManagerViewPlayVideoBlock)block {
    self.playBlock = block;
}

- (void)setVideoPlayManagerViewFinishBlock:(VideoPlayManagerViewFinishBlock)block {
    self.finishBlock = block;
}

- (void)setVideoPlayManagerViewFoldBlock:(VideoPlayManagerViewFoldBlock)block {
    self.foldBlock = block;
}

- (void)setType:(VideoPlayFromType)type {
    _type = type;
    if (type == VideoPlayFromType_PromptView && self.videoUrl) {
        self.isFirstBool = NO;
        self.player.videoUrl = self.videoUrl;
    }else {
        self.thumbView.hidden = NO;
    }
}

- (void)setIsFullscreen:(BOOL)isFullscreen {
    _isFullscreen = isFullscreen;
    self.foldButton.hidden = isFullscreen;
    if (_isFullscreen) {
        [self.bottomView.rotateButton setImage:[UIImage imageNamed:@"缩小按钮-"] forState:UIControlStateNormal];
        self.topView.hidden = NO;
    }else {
        [self.bottomView.rotateButton setImage:[UIImage imageNamed:@"放大按钮"] forState:UIControlStateNormal];
        self.topView.hidden = YES;
    }
}

- (void)setItem:(VideoItem *)item {
    _item = item;
    self.videoUrl = [NSURL URLWithString:item.videoUrl];
    self.topView.titleString = item.videoName;
    self.thumbView.imageUrl = item.videoCover;
    if (!self.isFirstBool && self.videoUrl) {
        self.player.videoUrl = self.videoUrl;
    }
}

- (void)setPlayStatus:(VideoPlayManagerStatus)playStatus {
    _playStatus = playStatus;
    self.exceptionView.hidden = NO;
    switch (_playStatus) {
        case  VideoPlayManagerStatus_Finish:
        {
            self.exceptionView.exceptionLabel.text = @"视频课程已播放完";
            [self setNormalAttributeTitleForButton:self.exceptionView.exceptionButton withTitleString:@"点击重新观看"];
//            [self.exceptionView.exceptionButton setTitle:@"点击重新观看" forState:UIControlStateNormal];
        }
            break;
        case  VideoPlayManagerStatus_Empty:
        {
            self.exceptionView.exceptionLabel.text = @"未找到该视频";
            [self setNormalAttributeTitleForButton:self.exceptionView.exceptionButton withTitleString:@"刷新重试"];
//            [self.exceptionView.exceptionButton setTitle:@"刷新重试" forState:UIControlStateNormal];
        }
            break;
        case  VideoPlayManagerStatus_NotWifi:
        {
            self.exceptionView.exceptionLabel.text = @"正在使用非WIFI环境，播放将产生流量费用";
            [self setAttributeForExceptionButton:self.exceptionView.exceptionButton];
        }
            break;
        case  VideoPlayManagerStatus_PlayError:
        {
            [self.player pause];
            self.exceptionView.exceptionLabel.text = @"抱歉,播放出错了";
            [self setNormalAttributeTitleForButton:self.exceptionView.exceptionButton withTitleString:@"重新播放"];
//            [self.exceptionView.exceptionButton setTitle:@"重新播放" forState:UIControlStateNormal];
        }
            break;
        case  VideoPlayManagerStatus_NetworkError:
        {
            [self.player pause];
            self.exceptionView.exceptionLabel.text = @"网络未连接，请检查网络设置";
            [self setNormalAttributeTitleForButton:self.exceptionView.exceptionButton withTitleString:@"刷新重试"];
//            [self.exceptionView.exceptionButton setTitle:@"刷新重试" forState:UIControlStateNormal];
        }
            break;
        case  VideoPlayManagerStatus_DataError:
        {
            self.exceptionView.exceptionLabel.text = @"抱歉,播放出错了";
            [self setNormalAttributeTitleForButton:self.exceptionView.exceptionButton withTitleString:@"重新播放"];
//            [self.exceptionView.exceptionButton setTitle:@"重新播放" forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

- (void)viewWillAppear {
    if (!self.isManualPause) {
        [self.player play];
    }
//    if (self.type == VideoPlayFromType_PlayButton) {
//        self.thumbView.hidden = NO;
//    }
}

- (void)viewWillDisappear {
    [self.player pause];
}

- (void)playVideoClear {
    [self.player pause];
    self.player = nil;
    [self.topBottomHideTimer invalidate];
    for (RACDisposable *d in self.disposableMutableArray) {
        [d dispose];
    }
}

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
        //        return [NSString stringWithFormat:@"%lldB", aBytes];
    }
    
    // 1KB - 1MB
    if ((aBytes >= 1024) && (aBytes < 1024*1024)) {
        //        unsigned long long kb = aBytes / 1024ll;
        //        return [NSString stringWithFormat:@"%lldK", kb];
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


