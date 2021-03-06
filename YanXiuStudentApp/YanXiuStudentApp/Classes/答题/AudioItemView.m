//
//  VoiceView.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 1/20/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "AudioItemView.h"


@interface AudioItemView ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UIImageView *volumeImageView;
@property (nonatomic, assign) CGFloat voiceDuration;
@property (nonatomic, assign) BOOL network;
@property (nonatomic, strong) LePlayer *player;
@end

@implementation AudioItemView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupReachability];
        [self addRACObserverForInterruption];
    }
    return self;
}

#pragma mark - setup
- (void)setupUI {
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.voiceView = [[UIView alloc] init];
    self.voiceView.backgroundColor = [UIColor colorWithHexString:@"ccff00"];
    self.voiceView.layer.cornerRadius = 10;
    self.voiceView.layer.borderWidth = 2;
    self.voiceView.layer.borderColor = [UIColor colorWithHexString:@"336600"].CGColor;
    
    UIImage *audio1 = [UIImage imageNamed:@"语音1"];
    UIImage *audio2 = [UIImage imageNamed:@"语音2"];
    UIImage *audio3 = [UIImage imageNamed:@"语音3"];
    
    self.volumeImageView = [[UIImageView alloc] init];
    self.volumeImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.volumeImageView.image = [UIImage imageNamed:@"语音"];
    self.volumeImageView.animationImages = @[audio1, audio2, audio3];
    self.volumeImageView.animationDuration = 1.0;
    
    self.durationLabel = [[UILabel alloc] init];
    self.durationLabel.font = [UIFont systemFontOfSize:14];
    self.durationLabel.textColor = [UIColor colorWithHexString:@"336600"];
}

- (void)setupLayout {
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.contentView addSubview:self.voiceView];
    [self.voiceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo([self audioButtonWidth]);
    }];
    
    [self.voiceView addSubview:self.volumeImageView];
    [self.volumeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(0);
        make.top.mas_offset(4);
        make.bottom.mas_offset(-4);
    }];
    
    [self.voiceView addSubview:self.durationLabel];
    [self.durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.volumeImageView.mas_right).offset(15);
        //        make.bottom.equalTo(self.voiceView.mas_bottom).offset(0);
        make.centerY.equalTo(self.volumeImageView);
    }];
}

#pragma mark- Set
- (void)setState:(AudioPlayState)state {
    _state = state;
    
    if (state == AudioPlayState_Playing) {
        if (!self.network) {
            [self.window nyx_showToast:@"网络无法连接"];
            return;
        }
        
        NSURL *url= [NSURL URLWithString:self.audioComment.url];
        
        self.player = [[LePlayer alloc] init];
        self.player.videoUrl = url;
        [self addRACObserverForPlayPauseState];
        [self addRACObserverForTimePlayed];
        [self.player play];
        [self.volumeImageView startAnimating];
        self.isPlayed = YES;
        
    } else if (state == AudioPlayState_Stopped) {
        self.player = nil;
        [self.volumeImageView stopAnimating];
        
    } else if (state == AudioPlayState_Finished) {
        self.player.playPauseState = PlayerView_State_Finished;
        self.player = nil;
        [self.volumeImageView stopAnimating];
        
    } else if (state == AudioPlayState_Default) {
        
    }
}

- (void)setAudioComment:(QAAudioComment *)audioComment {
    _audioComment = audioComment;
    
    [self setupLayout];
    
    CGFloat durationTime = audioComment.duration.floatValue;
    NSInteger minute = durationTime / 60.0;
    NSInteger second = durationTime - minute * 60.0;
    NSString *duration = [NSString string];
    if (minute > 0) {
        duration = [NSString stringWithFormat:@"%@'%02zd''",@(minute),second];
    }else {
        duration = [NSString stringWithFormat:@"%02zd''",second];
    }
    self.durationLabel.text = duration;
}

#pragma mark - Network
- (void)setupReachability {
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [reach startNotifier];
    
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kReachabilityChangedNotification object:nil] subscribeNext:^(NSNotification *notification) {
        STRONG_SELF
        Reachability *reach = [notification object];
        NetworkStatus status = [reach currentReachabilityStatus];
        if (status == NotReachable) {
            [self.window nyx_showToast:@"网络无法连接"];
            self.network = NO;
        }else {
            self.network = YES;
        }
    }];
}

#pragma mark - Helper
-(CGFloat)audioButtonWidth {
    CGFloat maxWidth = 300 * kPhoneWidthRatio;
    CGFloat minWidth = 80 * kPhoneWidthRatio;
    
    CGFloat buttonWidth = self.audioComment.duration.floatValue / (3.0f * 60 ) * (maxWidth - minWidth) + minWidth;
    return buttonWidth;
}

- (void)addRACObserverForPlayPauseState {
    WEAK_SELF
    [RACObserve(self.player, state) subscribeNext:^(id x) {
        STRONG_SELF
        PlayerView_State sta = (PlayerView_State)[x integerValue];
        if (sta == PlayerView_State_Playing) {
            [self.volumeImageView startAnimating];
        } else if (sta == PlayerView_State_Finished) {
            self.state = AudioPlayState_Finished;
            self.playFinished(self.tag);
        }
    }];
}

- (void)addRACObserverForTimePlayed {
    WEAK_SELF
    [RACObserve(self.player, timePlayed) subscribeNext:^(id x) {
        STRONG_SELF
        if (![x longLongValue]) {
            return ;
        }
        
        if (self.player.duration - [x floatValue] < 1) {//播放完成
            self.state = AudioPlayState_Finished;
            self.playFinished(self.tag);
            return;
        } else {
            if (self.state == AudioPlayState_Playing) {
                [self.volumeImageView startAnimating];
            }
        }
    }];
}

- (void)addRACObserverForInterruption {
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationWillResignActiveNotification object:nil] subscribeNext:^(id x) {
        self.state = AudioPlayState_Finished;
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:AVAudioSessionRouteChangeNotification object:nil] subscribeNext:^(id x) {
        self.state = AudioPlayState_Finished;
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"LeaveForegroundNotification" object:nil] subscribeNext:^(id x) {
        self.state = AudioPlayState_Finished;
    }];
}

@end
