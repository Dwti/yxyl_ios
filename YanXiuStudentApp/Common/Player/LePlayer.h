//
//  LePlayer.h
//  MyTest
//
//  Created by CaiLei on 12/11/14.
//  Copyright (c) 2014 leso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PlayerView_State) {
    PlayerView_State_Paused,
    PlayerView_State_Playing,
    PlayerView_State_Buffering,
    PlayerView_State_Finished,
    PlayerView_State_Error = 99
};

@interface LePlayer : NSObject {
    
}
#pragma mark - in
@property (nonatomic, assign) CGFloat progress; // 最好在videoUrl之前设置progress才能起作用
@property (nonatomic, strong) NSURL *videoUrl;
@property (nonatomic, assign) BOOL bCheckSpeed;
@property (nonatomic, assign) int timeout;

#pragma mark - out
@property (nonatomic, assign) PlayerView_State state;
@property (nonatomic, assign) PlayerView_State playPauseState;
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, assign) CGFloat timePlayed;
@property (nonatomic, assign) CGFloat timeBuffered;
@property (nonatomic, assign) CGFloat speedByByte;
@property (nonatomic, assign) BOOL isBuffering;
/**
 *  在一下情况的初始阶段，我们无法测速:
 *  1, 视频第一次加载
 *  2, 拖动进度到没有缓冲的部分
 *  3, 从后台切换到前台
 */
@property (nonatomic, assign) BOOL bSpeedAbleToCalculateRightNow;
@property (nonatomic, assign) BOOL bIsPlayable;
@property (nonatomic, strong) NSError *error;
#pragma mark - public API
- (void)play;
- (void)pause;
- (void)seekTo:(NSTimeInterval)second;

- (UIView *)playerViewWithFrame:(CGRect)frame;

// 音量控制
- (void)increaseVolumn;
- (void)decreaseVolumn;
- (void)mute;

@end
