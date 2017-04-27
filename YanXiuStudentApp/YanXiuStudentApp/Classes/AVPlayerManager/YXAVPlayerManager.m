//
//  YXAudioPlayerManager.m
//  ImagePickerDemo
//
//  Created by wd on 15/9/24.
//  Copyright © 2015年 wd. All rights reserved.
//

#import "YXAVPlayerManager.h"

#define LT_PLAYER_CORE_DEVIATION_SECS   0.0001f

@interface YXAVPlayerManager ()
@property(nonatomic, strong) AVPlayer *     player;
@property(nonatomic, strong) AVPlayerItem*  playerItem;
@property(nonatomic, weak)id<YXAVPlayerManagerDelegate> delegate;

@end

@implementation YXAVPlayerManager
- (void)dealloc
{
    
}
+ (instancetype) shareManager
{
    static YXAVPlayerManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[YXAVPlayerManager alloc] init];
    });
    return _sharedInstance;

}
- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}
- (void)yx_prepareToPlayWithURL:(NSString *)urlString delegate:(id<YXAVPlayerManagerDelegate>)delegate
{
    if (self.player) {
        [self stop];
    }
    _delegate = delegate;
    NSURL *url = nil;
    if (!urlString || [urlString isEqualToString:@""]) {
        return;
    }
    if ([urlString hasPrefix:@"http://"]){
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"%[a-zA-Z0-9]{2}"
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
        NSTextCheckingResult *match = [regex firstMatchInString:urlString
                                                        options:0
                                                          range:NSMakeRange(0, [urlString length])];
        if (match){//has encode
            url =[NSURL URLWithString:urlString];
        }
        else{
            url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
    }else if([urlString hasPrefix:@"assets-library:/"]){
        url = [NSURL URLWithString:urlString];
    }
    else{
        url = [NSURL fileURLWithPath:urlString];
    }
    
    AVURLAsset *itemAsset = [[AVURLAsset alloc] initWithURL:url options:nil];
    self.playerItem = [[AVPlayerItem alloc] initWithAsset:itemAsset];
    
    [self.playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidPlayToEndTime:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemFailedToPlayToEndTime:) name:AVPlayerItemFailedToPlayToEndTimeNotification object:self.playerItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemNewAccessLogEntry:) name:AVPlayerItemNewAccessLogEntryNotification object:self.playerItem];
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    if (self.player) {
        [self.player addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        [self.player addObserver:self forKeyPath:@"currentItem.duration" options:NSKeyValueObservingOptionNew context:nil];
        [self play];
    }
}
#pragma mark - Notification Method

//Important: This notification may be posted on a different thread than the one on which the observer was registered.
- (void)playerItemDidPlayToEndTime:(NSNotification *)notification
{
    if ([notification.object isKindOfClass:[AVPlayerItem class]])
    {
        //if the player item is the lastest, end playing
        [self playerItemDidPlayFinish];
    }
}

//Important: This notification may be posted on a different thread than the one on which the observer was registered.
- (void)playerItemFailedToPlayToEndTime:(NSNotification *)notification
{
    NSError *error = [notification.userInfo objectForKey:AVPlayerItemFailedToPlayToEndTimeErrorKey];
    NSLog(@"player item failed with error: %@", error);
        
        //TODO: 错误类型需要细分
    [self AVPlaybackErrorWithState:YXAVPlaybackUrlError];
}

//Important: This notification may be posted on a different thread than the one on which the observer was registered.
- (void)playerItemNewAccessLogEntry:(NSNotification *)notification
{
    //TODO   log
}

- (void)playerItemDidPlayFinish
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(AVPlayerDidFinish:)])
    {
        [self.delegate AVPlayerDidFinish:self.player];
    }
}
#pragma mark - Player KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"playbackBufferEmpty"])
    {
        AVPlayerItem *playItem = (AVPlayerItem *)object;
        if ([playItem isEqual:self.player.currentItem])
        {
            if (playItem.playbackBufferEmpty)
            {
                self.player.rate = 0;
                [self AVPlaybackStateChangedWithState:YXAVPlaybackStateLoadStalled];
            }
        }
    }
    else if ([keyPath isEqualToString:@"loadedTimeRanges"])
    {
        //AVPlayerItem *playItem = (AVPlayerItem *)object;
        //NSLog(@"Loaded time range: %@, playbackLikelyToKeepUp:%d, playbackBufferFull:%d", playItem.loadedTimeRanges, playItem.playbackLikelyToKeepUp, playItem.playbackBufferFull);
    }
    
    else if ([keyPath isEqualToString:@"status"])
    {
        AVQueuePlayer *avplayer = (AVQueuePlayer *)object;
        if (AVPlayerStatusReadyToPlay == avplayer.status)
        {
            [self AVPlaybackDidPreload];
        }
        else if (AVPlayerStatusFailed == avplayer.status)
        {
            [self AVPlaybackErrorWithState:YXAVPlaybackUrlError];
        }
    }
    
    else if ([keyPath isEqualToString:@"currentItem.duration"])
    {
        //TODO  播放时间。
    }
}

- (void)play
{
    self.player.rate = 1;
//    [self AVPlaybackStateChangedWithState:YXAVPlaybackStatePlaying];
}
- (void)pause
{
    self.player.rate = 0;
    [self AVPlaybackStateChangedWithState:YXAVPlaybackStatePaused];
}
- (void)stop
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.playerItem) {
        [self.playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [self.playerItem.asset cancelLoading];
    }
    if (self.player) {
        [self.player removeObserver:self forKeyPath:@"status"];
        [self.player removeObserver:self forKeyPath:@"currentItem.duration"];
    }
    [self AVPlaybackStateChangedWithState:YXAVPlaybackStateStopped];
}
- (YXAVPlaybackState)playbackState
{
    if (self.player.rate > LT_PLAYER_CORE_DEVIATION_SECS){
        return YXAVPlaybackStatePlaying;
    }else if (self.player.status == AVPlayerStatusReadyToPlay){
        return YXAVPlaybackStatePaused;
    }else if (self.player.status == AVPlayerStatusFailed){
        return YXAVPlaybackStateStopped;
    }
    return YXAVPlaybackStateUnknow;
}
- (void)AVPlaybackErrorWithState:(YXAVPlaybackError)state
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(AVPlayer:playbackError:)]) {
        [self.delegate AVPlayer:self.player playbackError:state];
    }

}
- (void)AVPlaybackStateChangedWithState:(YXAVPlaybackState)state
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(AVPlayer:playbackStateChanged:)]) {
        [self.delegate AVPlayer:self.player playbackStateChanged:state];
    }
}
- (void)AVPlaybackDidPreload
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(AVPlayerDidPreload:)]) {
        [self performSelectorOnMainThread:@selector(AVPlayerDidPreload:) withObject:self.player waitUntilDone:NO];
    }
}
@end
