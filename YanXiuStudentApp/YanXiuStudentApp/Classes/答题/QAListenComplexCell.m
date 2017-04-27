//
//  QAListenComplexCell.m
//  YanXiuStudentApp
//
//  Created by FanYu on 10/24/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import "QAListenComplexCell.h"
#import "LePlayer.h"
#import "UIView+YXScale.h"
#import "YXCommonLabel.h"
#import "ListenComplexPromptView.h"

@interface QAListenComplexCell()
@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, assign) BOOL network;
@property (nonatomic, strong) LePlayer *player;
@property (nonatomic, strong) QACoreTextViewHandler *coreTextHandler;
@end

@implementation QAListenComplexCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self setupLayout];
        [self setupReachability];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.htmlView = [[DTAttributedTextContentView alloc] init];

    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.textColor = [UIColor colorWithRGBHex:0x999999];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    
    self.progressView = [[UIProgressView alloc] init];
    self.progressView.progressTintColor = [[UIColor colorWithRGBHex:0xe7e7e7] colorWithAlphaComponent:1];
    self.progressView.trackTintColor = [[UIColor colorWithRGBHex:0xe7e7e7] colorWithAlphaComponent:0.5];
    self.progressView.progress = 0;
    
    self.actionButton = [[UIButton alloc] init];
    [self.actionButton setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
    [self addRACSignalForButtonTapped];
    
    self.coreTextHandler = [[QACoreTextViewHandler alloc]initWithCoreTextView:self.htmlView maxWidth:[QAListenComplexCell maxContentWidth]];
    WEAK_SELF
    self.coreTextHandler.heightChangeBlock = ^(CGFloat height) {
        STRONG_SELF
        [self.delegate tableViewCell:self updateWithHeight:ceilf(height + 43)];
    };
}

- (void)setupLayout {
    [self.contentView addSubview:self.htmlView];
    [self.htmlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.htmlView);
        make.top.mas_equalTo(self.htmlView.mas_bottom).offset = 17;
    }];
    
    [self.contentView addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.htmlView);
        make.centerY.mas_equalTo(self.timeLabel);
        make.height.offset = 6;
        make.right.mas_equalTo(self.timeLabel.mas_left).offset = -10;
    }];
    
    [self.contentView addSubview:self.actionButton];
    [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.timeLabel);
        make.left.mas_equalTo(self.htmlView);
        make.width.height.offset = 28;
    }];
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
            [self.viewController yx_showToast:@"网络无法连接"];
            self.network = NO;
        }else {
            self.network = YES;
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
            image = @"播放控件";
        } else if (sta == PlayerView_State_Paused) {
            image = @"播放";
        } else if (sta == PlayerView_State_Finished) {
            image = @"播放";
        } else if (sta == PlayerView_State_Error) {
            image = @"播放";
        }
        if (image) {//妈蛋 必须进主线程刷新
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.actionButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
            });
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
        CGFloat progress = [x longLongValue] / self.player.duration;
        [self.actionButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.htmlView.mas_bottom).offset = 10;
            make.left.mas_equalTo(self.htmlView).offset = (self.progressView.width - self.actionButton.width) * progress;
            make.width.height.offset = 28;
        }];
        if (self.player.duration - [x floatValue] < 1) {//播放完成
            [self.actionButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.htmlView.mas_bottom).offset = 10;
                make.left.mas_equalTo(self.htmlView);
                make.width.height.offset = 28;
            }];
            [self.actionButton setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
            self.timeLabel.text = [self timeFormatted:(long long)(self.player.duration)];
            self.progressView.progress = 1;
            return;
        }
        self.progressView.progress = progress;
        self.timeLabel.text = [self timeFormatted:(long long)(self.player.duration - [x longLongValue])];
    }];
}

- (void)addRACSignalForButtonTapped {
    WEAK_SELF
    [[self.actionButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        if (self.player ==  nil) {
            if (self.network == NO) {
                [self.viewController yx_showToast:@"网络无法连接"];
                return;
            }
            
            if ([[Reachability reachabilityForInternetConnection] isReachableViaWWAN]) {
                static bool first = YES;
                if (first) {
                    [self.player pause];
                    [self showAlertView];
                    first = NO;
                    return;
                }
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
            [self.actionButton setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
            [self.player seekTo:0];
            [self.player play];
            
        } else {
            [self.player pause];
        }
    }];
}

- (void)showAlertView {
    EEAlertView *alertView = [[EEAlertView alloc]init];
    
    ListenComplexPromptView *promptView = [[ListenComplexPromptView alloc] init];
    
    [promptView setOkAction:^{
        [alertView hide];
    }];
    
    alertView.contentView = promptView;
    [alertView showInView:self.viewController.view withLayout:^(AlertView *view) {
        [view.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(300 * [UIView scale]);
            make.center.mas_equalTo(0);
        }];
        [view layoutIfNeeded];
    }];
}

- (void)stop {
    self.player = nil;
    self.progressView.progress = 0;
    self.timeLabel.text = @"00:00";
    [self.actionButton setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
    [self.actionButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.htmlView.mas_bottom).offset = 10;
        make.left.mas_equalTo(self.htmlView);
        make.width.height.offset = 28;
    }];
}

- (NSString *)timeFormatted:(long long)totalSeconds {
    long long seconds = totalSeconds % 60;
    long long minutes = (totalSeconds / 60) % 60;
    long long hours = totalSeconds / 3600;
    
    if (hours) {
        return [NSString stringWithFormat:@"%02lld:%02lld:%02lld", hours, minutes, seconds];
    }else {
        return [NSString stringWithFormat:@"%02lld:%02lld", minutes, seconds];
    }
}

#pragma mark- Set
- (void)setItem:(QAQuestion *)item {
    if (self.item == item) {
        return;
    }
    _item = item;
    self.htmlView.attributedString = [YXQACoreTextHelper attributedStringForString:item.stem];
    self.timeLabel.text = @"00:00";
}

+ (CGFloat)maxContentWidth {
    return [UIScreen mainScreen].bounds.size.width - 10 - 17 - 20 - 20 - 30 - 4;
}

+ (CGFloat)heightForString:(NSString *)string {
    CGFloat maxWidth = [self maxContentWidth];
    CGFloat stringHeight = [YXQACoreTextHelper heightForString:string constraintedToWidth:maxWidth];
    CGFloat height = stringHeight;
    return ceilf(height);
}

@end
