//
//  YXAudioPlayerManager.h
//  ImagePickerDemo
//
//  Created by wd on 15/9/24.
//  Copyright © 2015年 wd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
typedef NS_ENUM(NSInteger, YXAVPlaybackState)
{
    YXAVPlaybackStateStopped,
    YXAVPlaybackStatePlaying,
    YXAVPlaybackStatePaused,
    YXAVPlaybackStateLoadStalled,
    YXAVPlaybackStateInterrupted,
    YXAVPlaybackStateUnknow
};

typedef NS_ENUM(NSInteger,YXAVPlaybackError)
{
    YXAVPlaybackUrlError,
    YXAVPlaybackUnsupportFormatError
};
@protocol YXAVPlayerManagerDelegate;
@interface YXAVPlayerManager : NSObject
@property(nonatomic,readonly) YXAVPlaybackState playbackState;

+ (instancetype) shareManager;
- (void)yx_prepareToPlayWithURL:(NSString *)url delegate:(id<YXAVPlayerManagerDelegate>)delegate;
- (void)play;
- (void)pause;
- (void)stop;

@end

@protocol YXAVPlayerManagerDelegate <NSObject>
//播放失败
- (void)AVPlayer:(AVPlayer *)player playbackError:(YXAVPlaybackError)error;
//播放状态
- (void)AVPlayer:(AVPlayer *)player playbackStateChanged:(YXAVPlaybackState)state;
//播放结束
- (void)AVPlayerDidFinish:(AVPlayer *)player;
//播放开始
- (void)AVPlayerDidPreload:(AVPlayer *)player;
@end