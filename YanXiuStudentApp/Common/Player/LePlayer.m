//
//  LePlayer.m
//  MyTest
//
//  Created by CaiLei on 12/11/14.
//  Copyright (c) 2014 leso. All rights reserved.
//

#import "LePlayer.h"
#import "LePlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "SpacemanBlocks.h"
#import "DDLog.h"
#import "RACExtScope.h"
#import "ReactiveCocoa.h"

static const int kTimeout = 600;
@interface LePlayer()
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) id playerObserver;    // for AVPlayer Periodic Time Observer
@property (nonatomic, strong) NSTimer *playerTimer;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVAsset *asset;
@property (nonatomic, strong) NSMutableArray *disposeArray;
@property (nonatomic, strong) LePlayerView *view;
@end

@implementation LePlayer {
    CMTime _tolerance;
    // for check speed
    NSDate *_lastSpeedCheckTime;
    long long _lastBytesTransfered;
    // ~ for check speed
    SMDelayedBlockHandle _delayedBlockHandle;
    dispatch_source_t _timerSource;
    
    MPVolumeView *_volumeView;
    UISlider *_volumeSlider;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self _resetProperties];
        _view = [[LePlayerView alloc] initWithFrame:CGRectZero];
        _volumeView = [[MPVolumeView alloc] initWithFrame:CGRectZero];
        for(id current in _volumeView.subviews) {
            if([current isKindOfClass:[UISlider class]]) {
                _volumeSlider = (UISlider *)current;
            }
        }
        _volumeView.hidden = YES;
        self.isBuffering = YES;
    }
    return self;
}

- (void)dealloc {
    // trick: ios7 bug?
    [self.view.player pause];
    
    [self.player replaceCurrentItemWithPlayerItem:nil];
    self.view.player = nil;
    DDLogDebug(@"LePlayer Dealloc");
}

#pragma mark - public API
- (void)setVideoUrl:(NSURL *)videoUrl {
    _videoUrl = videoUrl;
    [self _setupWithUrl:_videoUrl];
    self.bSpeedAbleToCalculateRightNow = NO;
    
    @weakify(self);
    _delayedBlockHandle = perform_block_after_delay(MAX(kTimeout, self.timeout), ^{
        @strongify(self); if (!self) return;
        if (self.bIsPlayable) {
            return;
        }
        
        [self.player pause];
        self.playPauseState = PlayerView_State_Paused;
        [self _dealErrorWithMsg:@"time out"];
    });
}

- (void)setBCheckSpeed:(BOOL)bCheckSpeed {
    if (_bCheckSpeed == bCheckSpeed) {
        return;
    }
    
    _bCheckSpeed = bCheckSpeed;
    
    if (_bCheckSpeed) {
        [self _startTimer];
    } else {
        if (_timerSource) {
            dispatch_suspend(_timerSource);
        }
    }
}

- (void)play {
    //    if (!self.bIsPlayable) {
    //        return;
    //    }
    [self.player play];
    self.state = PlayerView_State_Playing;
    self.playPauseState = PlayerView_State_Playing;
}

- (void)pause {
    //    if (!self.bIsPlayable) {
    //        return;
    //    }
    [self.player pause];
    self.state = PlayerView_State_Paused;
    self.playPauseState = PlayerView_State_Paused;
}

- (void)seekTo:(NSTimeInterval)second {
    if (!self.bIsPlayable) {
        return;
    }
    self.bSpeedAbleToCalculateRightNow = NO;
    self.state = PlayerView_State_Buffering;
    [self endPlayerObserver];//seek过程中停止对播放进度的监控
    @weakify(self);
    [self.playerItem seekToTime:CMTimeMake(second, 1) toleranceBefore:_tolerance toleranceAfter:_tolerance completionHandler:^(BOOL finished) {
        // Main Thread
        // [GlobalUtils checkMainThread];
        [self startPlayerObserver];//seek完成后开始对播放进度的监控
        @strongify(self); if (!self) return;
        if (!finished) {
            return;
        }
        
        // 下面这段没用，没有删除掉是因为: 此处为一个例子，可以在block内对RACDisposable调用dispose操作，已达到监听一次状态改变
        /*
         __block RACDisposable *d = [self.playerItem rac_observeKeyPath:@"status"
         options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
         observer:self
         block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
         [GlobalUtils checkMainThread];
         if ([value integerValue] == AVPlayerItemStatusReadyToPlay) {
         self.state = self->_playPauseState;
         }
         [d dispose];
         }];
         */
    }];
}

- (UIView *)playerViewWithFrame:(CGRect)frame {
    self.view.frame = frame;
    return self.view;
}

static const CGFloat kVolumnStep = 0.0625;
- (void)increaseVolumn {
    _volumeSlider.value = MIN(_volumeSlider.value + kVolumnStep, 1.f);
}

- (void)decreaseVolumn {
    _volumeSlider.value = MAX(_volumeSlider.value - kVolumnStep, 0.f);
}

- (void)mute {
    _volumeSlider.value = 0.f;
}

#pragma mark - private API
- (void)_resetProperties {
    // 需要notification的property用self.<property>来调用
    
    //_progress = 0.f;
    // _videoUrl        用新值
    // _bCheckSpeed     保持上次
    _state = PlayerView_State_Buffering;
    _duration = 0.f;
    self.timePlayed = 0.f;
    self.timeBuffered = 0.f;
    _speedByByte = 0.f;
    _bSpeedAbleToCalculateRightNow = NO;
    _bIsPlayable = NO;
    _error = nil;
    
    _tolerance = CMTimeMake(10, 1);
    _lastSpeedCheckTime = nil;
    _lastBytesTransfered = 0l;
}

- (void)_setupWithUrl:(NSURL *)url {
    [self _resetProperties];
    [self _clearObservers];
    cancel_delayed_block(_delayedBlockHandle);
    _delayedBlockHandle = nil;
    
    if (isEmpty(url)) {
        // 更新bIsPlayable
        self.bIsPlayable = NO;
        [self _dealErrorWithMsg:@"video url empty"];
        return;
    }
    [self.player pause];
    AVPlayerLayer *playerLayer = (AVPlayerLayer *)self.view.layer;
    playerLayer.player = nil;
    
    self.asset = [AVURLAsset assetWithURL:url];
    self.state = PlayerView_State_Buffering;
    self.isBuffering = YES;
    self.playPauseState = PlayerView_State_Playing;
    @weakify(self);
    [self.asset loadValuesAsynchronouslyForKeys:@[@"duration", @"playable"] completionHandler:^{
        // Other Thread
        // [GlobalUtils checkMainThread];
        
        @strongify(self); if (!self) return;
        BOOL bHasError = NO;
        NSError *error = nil;
        if ([self.asset statusOfValueForKey:@"duration" error:&error] == AVKeyValueStatusLoaded) {
            //DDLogVerbose(@"success : asset duration %f", CMTimeGetSeconds(self.asset.duration));
        } else {
            //DDLogError(@"error : asset duration");
            bHasError = YES;
            [self _dealErrorWithMsg:@"asset duration : NO"];
        }
        
        if ([self.asset statusOfValueForKey:@"playable" error:&error] == AVKeyValueStatusLoaded) {
            //DDLogVerbose(@"success : asset playable %d", self.asset.playable);
        } else {
            //DDLogError(@"error : asset playable");
            bHasError = YES;
            [self _dealErrorWithMsg:@"asset playable : NO"];
        }
        
        if (!bHasError) {
            @weakify(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self); if (!self) return;
                // 更新duration
                self.duration = CMTimeGetSeconds(self.asset.duration);
                
                self.playerItem = [[AVPlayerItem alloc] initWithAsset:self.asset];
                self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
                self.view.player = self.player;
                AVPlayerLayer *playerLayer = (AVPlayerLayer *)self.view.layer;
                playerLayer.player = self.player;
                [self _setupObservers];
                if (self.playPauseState == PlayerView_State_Playing) {
                    [self.player play];
                }
                if (self.progress) {
                    [self.playerItem seekToTime:CMTimeMake(self.duration * self.progress, 1) toleranceBefore:self->_tolerance toleranceAfter:self->_tolerance completionHandler:^(BOOL finished) {
                        @strongify(self); if (!self) return;
                        if (!finished) {
                            return;
                        }
                    }];
                }
                if (self.bCheckSpeed) {
                    [self _startTimer];
                }
            });
        }
    }];
}

- (void)_setupObservers {
    @weakify(self);
    [self startPlayerObserver];
    RACDisposable *gd1 = [[[NSNotificationCenter defaultCenter] rac_addObserverForName:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem] subscribeNext:^(id x) {
        // Main Thread
        // [GlobalUtils checkMainThread];
        
        @strongify(self); if (!self) return;
        self.state = PlayerView_State_Finished;
    }];
    [self.disposeArray addObject:gd1];
    
    RACDisposable *gd2 = [[[NSNotificationCenter defaultCenter] rac_addObserverForName:AVPlayerItemFailedToPlayToEndTimeNotification object:self.playerItem] subscribeNext:^(id x) {
        // Main Thread
        // [GlobalUtils checkMainThread];
        
        @strongify(self); if (!self) return;
        [self _dealErrorWithMsg:@"Failed To Play To End"];
    }];
    [self.disposeArray addObject:gd2];
    
    //*/
    // https://developer.apple.com/library/ios/qa/qa1668/_index.html
    RACDisposable *gd3 = [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil] subscribeNext:^(id x) {
        // Main Thread
        // [GlobalUtils checkMainThread];
        
        STRONG_SELF
        if (!self.bIsPlayable) {
            return;
        }
        self.view.player = nil;
    }];
    [self.disposeArray addObject:gd3];
    
    RACDisposable *gd4 = [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidBecomeActiveNotification object:nil] subscribeNext:^(id x) {
        // Main Thread
        // [GlobalUtils checkMainThread];
        
        STRONG_SELF
        if (!self.bIsPlayable) {
            return;
        }
        
        self.view.player = self.player;
        
        //        if ([YXGPGlobalSingleton sharedInstance].bHtmlNoti) {
        //            [self.view.player pause];
        //            return;
        //        }
    }];
    [self.disposeArray addObject:gd4];
    //*/
    
    RACDisposable *d1 = [RACObserve(self.playerItem, playbackBufferEmpty) subscribeNext:^(NSNumber *x) {
        // Main Thread
        // [GlobalUtils checkMainThread];
        STRONG_SELF
        if ([x boolValue]) {
            //NSLog(@"playbackBufferEmpty");
            self.isBuffering = YES;
            self.state = PlayerView_State_Buffering;
            self.bSpeedAbleToCalculateRightNow = NO;
        }
    }];
    [self.disposeArray addObject:d1];
    
    RACDisposable *d2 = [RACObserve(self.playerItem, playbackLikelyToKeepUp) subscribeNext:^(NSNumber *x) {
        @strongify(self); if (!self) return;
        if ([x boolValue]) {
            NSLog(@"playbackLikelyToKeepUp");
            self.state = self.playPauseState;
            self.isBuffering = NO;
            // 更新bIsPlayable
            self.bIsPlayable = YES;
        }
    }];
    [self.disposeArray addObject:d2];
    
    RACDisposable *d3 = [RACObserve(self.playerItem, playbackBufferFull) subscribeNext:^(NSNumber *x) {
        @strongify(self); if (!self) return;
        if ([x boolValue]) {
            NSLog(@"playbackLikelyToKeepUp");
            self.state = self.playPauseState;
            self.isBuffering = NO;
            // 更新bIsPlayable
            self.bIsPlayable = YES;
        }
    }];
    [self.disposeArray addObject:d3];
    
    RACDisposable *d4= [RACObserve(self.playerItem, loadedTimeRanges) subscribeNext:^(NSArray *x) {
        // Main Thread
        // [GlobalUtils checkMainThread];
        
        @strongify(self); if (!self) return;
        CMTimeRange timeRange = [[x lastObject] CMTimeRangeValue];
        if (CMTIME_IS_INDEFINITE(timeRange.start) || CMTIME_IS_INDEFINITE(timeRange.duration)) {
            return;
        }
        double startSeconds = CMTimeGetSeconds(timeRange.start);
        double durationSeconds = CMTimeGetSeconds(timeRange.duration);
        double result = startSeconds + durationSeconds;
        if (isnan(result)) {
            return;
        }
        // 更新timeBuffered
        self.timeBuffered = result;
    }];
    [self.disposeArray addObject:d4];
    
    RACDisposable *d5 = [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"apns html done" object:nil] subscribeNext:^(id x) {
        // Main ThreadYXSlideProgressView
        // [GlobalUtils checkMainThread];
        
        @strongify(self); if (!self) return;
        if (!self.bIsPlayable) {
            return;
        }
        
        //        if ([YXGPGlobalSingleton sharedInstance].bHtmlNoti) {
        //            [self.view.player pause];
        //            return;
        //        }
        
        if (self.playPauseState == PlayerView_State_Playing) {
            [self.view.player play];
        }
        
        self.view.player = self.player;
    }];
    [self.disposeArray addObject:d5];
    
}

- (void)_clearObservers {
    [self endPlayerObserver];
    
    for (RACDisposable *d in self.disposeArray) {
        [d dispose];
    }
}

- (void)_startTimer {
    if (_timerSource) {
        dispatch_suspend(_timerSource);
    } else {
        dispatch_queue_t queue = dispatch_get_main_queue();
        _timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_timerSource, dispatch_walltime(DISPATCH_TIME_NOW, 0), 1*NSEC_PER_SEC, 0);
        @weakify(self);
        dispatch_source_set_event_handler(_timerSource, ^{
            @strongify(self); if (!self) return;
            [self _timerAction];
        });
    }
    dispatch_resume(_timerSource);
}

- (void)_timerAction {
    AVPlayerItemAccessLogEvent *event = [self.player.currentItem.accessLog.events lastObject];
    long long byte = event.numberOfBytesTransferred - self->_lastBytesTransfered;
    //NSLog(@"%lld, %lld", event.numberOfBytesTransferred, self->_lastBytesTransfered);
    
    static int notModifiedTimes = 0;
    if (byte > 0) {
        NSTimeInterval t = [[NSDate date] timeIntervalSinceDate:self->_lastSpeedCheckTime];
        // 更新speedByByte
        self.speedByByte = byte / t;
    };
    
    if (ABS(byte)) {
        // 当有新event加入events数组时，会重新计numberOfBytesTransferred
        self.bSpeedAbleToCalculateRightNow = YES;
        self->_lastBytesTransfered = event.numberOfBytesTransferred;
        self->_lastSpeedCheckTime = [NSDate date];
        notModifiedTimes = 0;
    } else {
        notModifiedTimes++;
        if (notModifiedTimes > 5) {
            // 经验数据,大于5次没有改变,认为速度为零
            if (self.bSpeedAbleToCalculateRightNow) {
                self.speedByByte = 0;
            }
        }
    }
}

- (void)_checkPlayableOnTimeout {
    if (self.bIsPlayable) {
        return;
    }
    
    [self.player pause];
    self.playPauseState = PlayerView_State_Paused;
    [self _dealErrorWithMsg:@"time out"];
}

- (void)_dealErrorWithMsg:(NSString *)errMsg {
    self.error = [NSError errorWithDomain:@"PlayerView" code:0 userInfo:@{@"description":errMsg}];
    self.state = PlayerView_State_Error;
}

- (void)startPlayerObserver {
    @weakify(self);
    self.playerObserver = [self.player
                           addPeriodicTimeObserverForInterval:CMTimeMake(1, 1)
                           queue:NULL
                           usingBlock:^(CMTime time) {
                               @strongify(self); if (!self) return;
                               // 更新timePlayed
                               self.timePlayed = CMTimeGetSeconds([self.playerItem currentTime]);
                           }];
}

- (void)endPlayerObserver {
    [self.player removeTimeObserver:self.playerObserver];
    self.playerObserver = nil;
}


@end
