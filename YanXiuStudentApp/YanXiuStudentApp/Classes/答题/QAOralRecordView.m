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
@end

@implementation QAOralRecordView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        self.recordViewState = QAOralRecordViewStateNormal;
    }
    return self;
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
        make.size.mas_equalTo(CGSizeMake(124, 124));
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
        make.height.mas_equalTo(62);
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
        make.size.mas_equalTo(CGSizeMake(56, 56));
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
            if (state == PlayerView_State_Finished && self.needShowResult && !isEmpty(self.resultItem)) {
                QAOralResultViewController *vc = [[QAOralResultViewController alloc] init];
                vc.resultItem = self.resultItem;
                [self.window addSubview:vc.view];
                self.needShowResult = NO;
                BLOCK_EXEC(self.showResultBlock, self.resultItem);
            }
        }];
    }
    return _player;
}

#pragma mark - actions
- (void)recordStartAction:(UIButton *)sender {
    if (!self.network) {
        [self.window nyx_showToast:@"网络未连接，请检查后重试"];
        return;
    }
    if (isEmpty(self.oralText)) {
        DDLogDebug(@"当前题目答案为空");
        return;
    }
    BLOCK_EXEC(self.stopAudioPlayerBlock);
    self.recognizer.oralText = self.oralText;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (authStatus == AVAuthorizationStatusDenied) {
        [self showAlertView];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) { }];
    } else if (authStatus == AVAuthorizationStatusAuthorized) {
        [self.recognizer cancel];
        [self.recognizer start];
    }
}

- (void)recordStopAction:(UIButton *)sender {
    [sender.imageView.layer removeAllAnimations];
    [self.recognizer stop];
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
    if (self.player.state == PlayerView_State_Paused) {
        [self.player play];
    } else if (self.player.state == PlayerView_State_Finished) {
        self.player.videoUrl = [NSURL URLWithString:self.resultItem.url];
    }else if (self.player.state == PlayerView_State_Buffering) {
        self.player.videoUrl = [NSURL URLWithString:self.resultItem.url];
    } else {
        [self.player pause];
    }
}

#pragma mark - USCRecognizerDelegate
- (void)oralEngineDidInit:(NSError *)error {
    if (error) {
        DDLogError(@"%@", error);
    }
}

- (void)onBeginOral {
    self.recordViewState = QAOralRecordViewStateRecording;
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
    rotationAnimation.duration = 1;
    rotationAnimation.repeatCount = HUGE_VALF;
    [self.recordBtn.imageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)onUpdateVolume:(int)volume {
    self.volume = (CGFloat)volume;
}

- (void)onResult:(NSString *)result isLast:(BOOL)isLast {
    self.resultItem = [[QAOralResultItem alloc] initWithString:result error:NULL];
}

- (void)audioFileDidRecord:(NSString *)url {
    self.resultItem.url = url;
    self.needShowResult = YES;
    self.player.videoUrl = [NSURL URLWithString:url];
}

- (void)onEndOral:(NSError *)error {
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
}

@end
