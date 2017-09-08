//
//  QAListenPlayView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/8.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAListenPlayView.h"
#import "YXGradientView.h"
#import "UIImage+YXImage.h"
#import "LePlayer.h"

@interface QAListenPlayView()
@property (nonatomic, strong) LePlayer *player;
@property (nonatomic, assign) BOOL network;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIView *wholeProgressView;
@property (nonatomic, strong) YXGradientView *playProgressView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, assign) CGFloat playProgress;
@property (nonatomic, assign) BOOL isFirstPlay;
@property (nonatomic, assign) BOOL isSliding;
@end

@implementation QAListenPlayView

- (id)init {
    self = [super init];
    if (self) {
        [self setupUI];
        [self setupReachability];
    }
    return self;
}

- (void)setupUI {
    self.isFirstPlay = YES;
    self.isSliding = NO;
    
    self.wholeProgressView = [[UIView alloc] init];
    self.wholeProgressView.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    self.wholeProgressView.layer.cornerRadius = 5;
    self.wholeProgressView.clipsToBounds = YES;
    [self addSubview:self.wholeProgressView];
    self.wholeProgressView.userInteractionEnabled = NO;
    
    UIColor *startColor = [UIColor colorWithHexString:@"89e00d"];
    UIColor *endColor = [UIColor colorWithHexString:@"ccff00"];
    self.playProgressView = [[YXGradientView alloc]initWithStartColor:startColor endColor:endColor orientation:YXGradientLeftToRight];
    self.playProgressView.layer.cornerRadius = 5;
    self.playProgressView.clipsToBounds = YES;
    [self addSubview:self.playProgressView];
    self.playProgressView.userInteractionEnabled = NO;
    
    self.playButton = [[UIButton alloc] init];
    [self.playButton setImage:[UIImage imageNamed:@"播放按钮正常态"] forState:UIControlStateNormal];
    [self.playButton setImage:[UIImage imageNamed:@"播放按钮点击态"] forState:UIControlStateHighlighted];
    [self addSubview:self.playButton];
    [self addRACSignalForButtonTapped];
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(buttonLongPressed:)];
    [self.playButton addGestureRecognizer:longGesture];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont fontWithName:YXFontMetro_Regular size:14];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"666666"];
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.timeLabel];
    
    [self.wholeProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self.playButton);
        make.height.mas_equalTo(10.0f);
        make.right.equalTo(self.timeLabel.mas_left).offset(-13.0f);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.playButton);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(75);
    }];
}

- (void)addRACSignalForButtonTapped {
    WEAK_SELF
    [[self.playButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        if (self.player ==  nil) {
            if (self.network == NO) {
                [self.window nyx_showToast:@"网络无法连接"];
                return;
            }
            
            NSURL *url= [NSURL URLWithString:self.item.audioUrl];
            
            self.player = [[LePlayer alloc] init];
            self.player.videoUrl = url;
            [self addRACObserverForPlayPauseState];
            [self addRACObserverForTimePlayed];
            [self.player play];
            
        } else if (self.player.state == PlayerView_State_Paused) {
            [self.player play];
            
        } else if (self.player.state == PlayerView_State_Finished) {
            [self.player seekTo:0];
            [self.player play];
            
        }else if (self.player.state == PlayerView_State_Buffering) {
            [self.player play];
            
        } else {
            [self.player pause];
        }
    }];
}

- (void)addRACObserverForPlayPauseState {
    WEAK_SELF
    [RACObserve(self.player, playPauseState) subscribeNext:^(id x) {
        STRONG_SELF
        PlayerView_State sta = (PlayerView_State)[x integerValue];
        NSString *image = nil;
        if (sta == PlayerView_State_Playing) {
            image = @"暂停按钮";
        } else if (sta == PlayerView_State_Paused) {
            image = @"播放按钮";
        } else if (sta == PlayerView_State_Finished) {
            image = @"播放";
        } else if (sta == PlayerView_State_Error) {
            image = @"播放";
        }
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.playButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@正常态",image]] forState:UIControlStateNormal];
                [self.playButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@点击态",image]] forState:UIControlStateHighlighted];
            });
        }
    }];
}

- (void)addRACObserverForTimePlayed {
    WEAK_SELF
    [RACObserve(self.player, timePlayed) subscribeNext:^(id x) {
        STRONG_SELF
        if (self.isSliding) {
            return;
        }
        if (![x longLongValue]) {
            return ;
        }
        self.isFirstPlay = NO;
        CGFloat progress = [x longLongValue] / self.player.duration;
        if (self.player.duration - [x floatValue] < .1f) {
                self.playProgress = 0;
                [self.player seekTo:0];
                [self pause];
                return;
        }
        self.playProgress = progress;
        [self updateUI];
    }];
}

- (void)buttonLongPressed:(UILongPressGestureRecognizer *)sender {
    if (self.player == nil || self.isFirstPlay) {
        return;
    }
    if (sender.state == UIGestureRecognizerStateBegan) {
        CGPoint touchPoint = [sender locationInView:self];
        if (CGRectContainsPoint([self slidePointImageRect], touchPoint)) {
            self.isSliding = YES;
        }
    }else if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint touchPoint = [sender locationInView:self];
        CGFloat startX = self.wholeProgressView.x - 6;
        CGFloat endX = self.wholeProgressView.x + self.wholeProgressView.width - 39;
        touchPoint.x = MAX(startX, touchPoint.x);
        touchPoint.x = MIN(endX, touchPoint.x);
        
        self.playProgress = (touchPoint.x - startX) / (endX - startX);
        [self.player seekTo:self.player.duration * self.playProgress];
        [self setNeedsLayout];
        self.isSliding = YES;
    }else if (sender.state == UIGestureRecognizerStateEnded) {
        self.isSliding = NO;
    }
}

- (CGRect)slidePointImageRect {
    CGRect rect = self.playButton.frame;
    rect.size.width  = rect.size.width + 8;//拖动按钮的区域增加8个像素
    rect.size.height = rect.size.height + 8;
    DDLogDebug(@"%@", NSStringFromCGRect(rect));
    return rect;
}

- (void)layoutSubviews {
    [self updateUI];
    [super layoutSubviews];
}

- (void)updateUI {
    [self.playProgressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.wholeProgressView.mas_left);
        make.top.mas_equalTo(self.wholeProgressView.mas_top);
        make.bottom.mas_equalTo(self.wholeProgressView.mas_bottom);
        make.width.mas_equalTo(self.wholeProgressView.mas_width).multipliedBy(self.playProgress);
    }];
    
    [self.playButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45.0f, 45.0f));
        make.left.mas_equalTo(self.wholeProgressView.mas_left).mas_offset((self.wholeProgressView.bounds.size.width - 34) * self.playProgress - 6);
        make.top.mas_equalTo(0);
    }];
    
    self.timeLabel.attributedText = [self palyTime:[self timeString:self.player.duration * self.playProgress] withContent:[self timeString:ceil(self.player.duration)]];
}

- (NSString *)timeString:(NSTimeInterval)time {
    int minute = (int)(time / 60);
    int second = ((int)time) % 60;
    NSString *ret = [NSString stringWithFormat:@"%02d:%02d", minute, second];
    return ret;
}

- (NSMutableAttributedString *)palyTime:(NSString *)playTime withContent:(NSString *)durationTime{
    playTime = !isEmpty(playTime) ? playTime : @"00:00";
    durationTime = !isEmpty(durationTime) ? durationTime : @"00:00";
    NSString *temString = [NSString stringWithFormat:@"%@ / %@",playTime,durationTime];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                                   initWithString:temString];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:YXFontMetro_Regular size:14],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"999999"]} range:NSMakeRange(0, [temString length])];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:YXFontMetro_Light size:14],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"999999"]} range:NSMakeRange(0, playTime.length + 3)];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:YXFontMetro_Regular size:14],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"89e00d"]} range:NSMakeRange(0, playTime.length + 1)];
    return attributedString;
}

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

- (void)pause {
    [self.player pause];
    self.playProgress = 0;
    [self.playButton setImage:[UIImage imageNamed:@"播放按钮正常态"] forState:UIControlStateNormal];
    [self.playButton setImage:[UIImage imageNamed:@"播放按钮点击态"] forState:UIControlStateHighlighted];
    [self updateUI];
}

- (void)stop {
    self.player = nil;
    self.playProgress = 0;
    [self.playButton setImage:[UIImage imageNamed:@"播放按钮正常态"] forState:UIControlStateNormal];
    [self.playButton setImage:[UIImage imageNamed:@"播放按钮点击态"] forState:UIControlStateHighlighted];
    [self updateUI];
}

- (void)setItem:(QAQuestion *)item {
    if (_item == item) {
        return;
    }
    _item = item;
    self.timeLabel.attributedText = [self palyTime:@"00:00" withContent:[self timeString:self.player.duration]];
    
}

@end
