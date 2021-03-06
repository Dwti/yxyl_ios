//
//  QAOralRecordView.m
//  YanXiuStudentApp-iPhone
//
//  Created by LiuWenXing on 2017/10/19.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAOralRecordView.h"
#import "QAIgnorePanGestureButton.h"
#import "Waver.h"
#import "QAOralResultViewController.h"

@interface QAOralRecordView ()<USCRecognizerDelegate>
@property (nonatomic, strong) Waver *waver;
@property (nonatomic, strong) QAIgnorePanGestureButton *recordBtn;
@property (nonatomic, strong) QAIgnorePanGestureButton *playBtn;

@property (nonatomic, assign) CGFloat volume;
@property (nonatomic, assign) BOOL needShowResult;
@property (nonatomic, assign) BOOL isStarting;
@property (nonatomic, assign) BOOL isStopping;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation QAOralRecordView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        self.recordViewState = QAOralRecordViewStateNormal;
    }
    return self;
}

- (void)cancelAllTasks {
    self.needShowResult = NO;
    [self.player pause];
    self.player.state = PlayerView_State_Finished;
    if (self.isStarting) {
        [self.recognizer cancel];
    }
    [self stopTimer];
}

#pragma mark - setupUI
- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    self.recordBtn = [QAIgnorePanGestureButton buttonWithType:UIButtonTypeCustom];
    [self.recordBtn setBackgroundImage:[UIImage imageNamed:@"录音图标可用"] forState:UIControlStateNormal];
    [self.recordBtn setBackgroundImage:[UIImage imageNamed:@"录音图标不可用"] forState:UIControlStateDisabled];
    [self.recordBtn setBackgroundImage:[UIImage imageNamed:@"录音中按钮"] forState:UIControlStateHighlighted];
    [self.recordBtn setImage:[UIImage imageNamed:@"录音中动效转圈"] forState:UIControlStateHighlighted];
    [self.recordBtn addTarget:self action:@selector(recordStartAction:) forControlEvents:UIControlEventTouchDown];
    [self.recordBtn addTarget:self action:@selector(recordStopAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.recordBtn addTarget:self action:@selector(recordCancelAction:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];
    self.recordBtn.enabled = NO;
    [self addSubview:self.recordBtn];
    [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(self.mas_height);
    }];
    
    self.waver = [[Waver alloc] init];
    self.waver.numberOfWaves = 2;
    self.waver.mainWaveWidth = 2;
    self.waver.decorativeWavesWidth = 2;
    self.waver.waveColor = [UIColor colorWithHexString:@"89e00d"];
    self.waver.hidden = YES;
    WEAK_SELF
    self.waver.waverLevelCallback = ^(Waver *waver) {
        STRONG_SELF
        waver.level = self.volume / 100;
    };
    [self addSubview:self.waver];
    [self sendSubviewToBack:self.waver];
    [self.waver mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerY.mas_equalTo(0);
        make.height.mas_equalTo(self.mas_height).multipliedBy(.5f);
    }];
    
    self.playBtn = [QAIgnorePanGestureButton buttonWithType:UIButtonTypeCustom];
    [self.playBtn setImage:[UIImage imageNamed:@"录音内容播放"] forState:UIControlStateNormal];
    [self.playBtn setImage:[UIImage imageNamed:@"录音内容暂停"] forState:UIControlStateSelected];
    [self.playBtn addTarget:self action:@selector(playBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.playBtn.hidden = YES;
    [self addSubview:self.playBtn];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.recordBtn.mas_right).offset(35);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(self.mas_height).multipliedBy(56.0f / 124);
    }];
}

- (void)showAlertView {
    SimpleAlertView *alert = [[SimpleAlertView alloc] init];
    alert.title = @"提示";
    alert.describe = @"请到“设置->隐私->麦克风”中设置为允许访问麦克风！";
    alert.image = [UIImage imageNamed:@"异常弹窗图标"];
    [alert addButtonWithTitle:@"确定" style:SimpleAlertActionStyle_Alone action:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    [alert show];
}

#pragma mark - setupTimer
- (void)startTimer {
    WEAK_SELF
    self.timer = [NSTimer timerWithTimeInterval:180 repeats:NO block:^(NSTimer * _Nonnull timer) {
        STRONG_SELF
        [self recordStopAction:self.recordBtn];
        [self.window nyx_showToast:@"录音不能超过3分钟哦"];
    }];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - setters
- (void)setRecordViewState:(QAOralRecordViewState)recordViewState {
    if (_recordViewState == recordViewState) {
        return;
    }
    _recordViewState = recordViewState;
    self.recordBtn.enabled = recordViewState != QAOralRecordViewStateDisabled;
    self.waver.hidden = recordViewState != QAOralRecordViewStateRecording;
    self.playBtn.hidden = recordViewState != QAOralRecordViewStateRecorded;
}

- (void)setResultItem:(QAOralResultItem *)resultItem {
    _resultItem = resultItem;
    self.recordViewState = QAOralRecordViewStateRecorded;
}

#pragma mark - getters
- (USCRecognizer *)recognizer {
    if (!_recognizer) {
        _recognizer = [[USCRecognizer alloc] init];
        _recognizer.delegate = self;
        _recognizer.oralTask = @"A";
        _recognizer.audioType = AudioType_MP3;
        [_recognizer setOutScoreCoefficient:1.6f];
    }
    return _recognizer;
}

- (LePlayer *)player {
    if (!_player) {
        _player = [[LePlayer alloc] init];
        WEAK_SELF
        [RACObserve(_player, state) subscribeNext:^(id x) {
            STRONG_SELF
            PlayerView_State state = (PlayerView_State)[x integerValue];
            self.playBtn.selected = state == PlayerView_State_Playing;
            if (state == PlayerView_State_Finished && !isEmpty(self.resultItem)) {
                if (self.needShowResult) {
                    QAOralResultViewController *vc = [[QAOralResultViewController alloc] init];
                    vc.resultItem = self.resultItem;
                    [self.window addSubview:vc.view];
                    self.needShowResult = NO;
                }
                BLOCK_EXEC(self.showResultBlock, self.resultItem);
            }
        }];
    }
    return _player;
}

#pragma mark - actions
- (void)recordStartAction:(UIButton *)sender {
    if (!self.network) {
        SimpleAlertView *alert = [[SimpleAlertView alloc] init];
        alert.title = @"录音失败";
        alert.describe = @"网络未连接，请检查后重试";
        alert.image = [UIImage imageNamed:@"异常弹窗图标"];
        [alert addButtonWithTitle:@"确定" style:SimpleAlertActionStyle_Alone action:nil];
        [alert show];
        return;
    }
    if (isEmpty(self.oralText)) {
        [self.window nyx_showToast:@"题目参数缺失，无法作答！"];
        return;
    }
    [self.player pause];
    BLOCK_EXEC(self.stopAudioPlayerBlock);
    self.recognizer.oralText = self.oralText;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (authStatus == AVAuthorizationStatusDenied) {
        [self showAlertView];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) { }];
    } else if (authStatus == AVAuthorizationStatusAuthorized) {
        if (!self.isStarting) {
            [self.recognizer start];
            self.isStarting = YES;
            NSLog(@"\n===== start");
        } else {
            [self.window nyx_showToast:@"点击太频繁"];
        }
    }
}

- (void)recordStopAction:(UIButton *)sender {
    [sender.imageView.layer removeAllAnimations];
    if (self.isStopping || !self.isStarting) {
        return;
    }
    [self.recognizer stop];
    self.isStopping = YES;
    NSLog(@"\n===== stop");
}

- (void)recordCancelAction:(UIButton *)sender {
    [sender.imageView.layer removeAllAnimations];
    [self.recognizer cancel];
}

- (void)playBtnAction:(UIButton *)sender {
    if (!self.network) {
        [self.window nyx_showToast:@"网络未连接，请检查后重试"];
        return;
    }
    BLOCK_EXEC(self.stopAudioPlayerBlock);
    if (self.player.state == PlayerView_State_Playing) {
        [self.player pause];
        self.player.state = PlayerView_State_Finished;
    } else if (self.player.state == PlayerView_State_Finished) {
        self.player.videoUrl = [NSURL URLWithString:self.resultItem.url];
    } else if (self.player.state == PlayerView_State_Buffering) {
        self.player.videoUrl = [NSURL URLWithString:self.resultItem.url];
    } else {
        [self.player pause];
        self.player.state = PlayerView_State_Finished;
    }
}

#pragma mark - USCRecognizerDelegate
- (void)oralEngineDidInit:(NSError *)error {
    NSLog(@"\n===== %s, %d", __FUNCTION__, (int)self.recordViewState);
    if (error) {
        DDLogError(@"%@", error);
    }
}

- (void)onBeginOral {
    NSLog(@"\n===== %s, %d", __FUNCTION__, (int)self.recordViewState);
    self.recordViewState = QAOralRecordViewStateRecording;
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
    rotationAnimation.duration = 1;
    rotationAnimation.repeatCount = HUGE_VALF;
    [self.recordBtn.imageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    [self startTimer];
}

- (void)onUpdateVolume:(int)volume {
    self.volume = (CGFloat)volume;
}

- (void)onStopOral {
    NSLog(@"\n===== %s, %d", __FUNCTION__, (int)self.recordViewState);
}

- (void)onResult:(NSString *)result isLast:(BOOL)isLast {
    NSLog(@"\n===== %s, %d", __FUNCTION__, (int)self.recordViewState);
    self.resultItem = [[QAOralResultItem alloc] initWithString:result error:NULL];
}

- (void)audioFileDidRecord:(NSString *)url {
    NSLog(@"\n===== %s, %d", __FUNCTION__, (int)self.recordViewState);
    self.resultItem.url = url;
    self.needShowResult = YES;
    self.player.videoUrl = [NSURL URLWithString:url];
}

- (void)onEndOral:(NSError *)error {
    NSLog(@"\n===== %s, %d", __FUNCTION__, (int)self.recordViewState);
    if (error) {
        DDLogError(@"%@", error);
        SimpleAlertView *alert = [[SimpleAlertView alloc] init];
        alert.title = @"录音失败";
        alert.describe = error.domain;
        alert.image = [UIImage imageNamed:@"异常弹窗图标"];
        [alert addButtonWithTitle:@"确定" style:SimpleAlertActionStyle_Alone action:nil];
        [alert show];
        self.recordViewState = QAOralRecordViewStateNormal;
    }
    self.recordViewState = isEmpty(self.resultItem) ? QAOralRecordViewStateNormal : QAOralRecordViewStateRecorded;
    [self stopTimer];
    self.isStarting = NO;
    self.isStopping = NO;
}

@end
