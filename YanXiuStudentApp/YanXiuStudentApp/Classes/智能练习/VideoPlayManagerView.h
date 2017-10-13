//
//  VideoPlayManagerView.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/10/13.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LePlayer.h"
#import "LePlayerView.h"
#import "PlayBottomView.h"
#import "PlayTopView.h"
#import "YXPlayProgressDelegate.h"

@interface VideoItem : NSObject
@property(nonatomic, copy) NSString *videoName;
@property(nonatomic, copy) NSString *videoUrl;
@property(nonatomic, copy) NSString *videoSize;
@property(nonatomic, copy) NSString *videoCover;
@end

typedef NS_ENUM(NSInteger, VideoPlayManagerStatus) {
    VideoPlayManagerStatus_Finish,//视频完成
    VideoPlayManagerStatus_Empty,//视频为空
    VideoPlayManagerStatus_NotWifi,//非wifi
    VideoPlayManagerStatus_PlayError,//播放出错
    VideoPlayManagerStatus_NetworkError,//网络出错
    VideoPlayManagerStatus_DataError,//数据出错
};

typedef NS_ENUM(NSInteger, VideoPlayFromType) {
    VideoPlayFromType_PlayButton,//视频播放浮窗
    VideoPlayFromType_PromptView//视频提示引导页
};

typedef void (^VideoPlayManagerViewBackActionBlock)(void);
typedef void (^VideoPlayManagerViewRotateScreenBlock)(BOOL isVertical);
typedef void (^VideoPlayManagerViewPlayVideoBlock)(VideoPlayManagerStatus status);
typedef void (^VideoPlayManagerViewFinishBlock)(void);
typedef void (^VideoPlayManagerViewFoldBlock)(void);

@interface VideoPlayManagerView : UIView
@property(nonatomic, assign) VideoPlayFromType type;

@property (nonatomic, assign) VideoPlayManagerStatus playStatus;
@property (nonatomic, assign) BOOL isFullscreen;
@property (nonatomic, weak) id<YXPlayProgressDelegate> delegate;
@property(nonatomic, strong) VideoItem *item;

- (void)setVideoPlayManagerViewBackActionBlock:(VideoPlayManagerViewBackActionBlock)block;
- (void)setVideoPlayManagerViewRotateScreenBlock:(VideoPlayManagerViewRotateScreenBlock)block;
- (void)setVideoPlayManagerViewPlayVideoBlock:(VideoPlayManagerViewPlayVideoBlock)block;
- (void)setVideoPlayManagerViewFinishBlock:(VideoPlayManagerViewFinishBlock)block;
- (void)setVideoPlayManagerViewFoldBlock:(VideoPlayManagerViewFoldBlock)block;

- (void)viewWillAppear;
- (void)viewWillDisappear;
- (void)playVideoClear;

@end
