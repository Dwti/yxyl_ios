//
//  VideoPlayerManagerView.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/10/25.
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

typedef NS_ENUM(NSInteger, YXPlayerManagerPauseStatus) {
    YXPlayerManagerPause_Not = 0,//未暂停
    YXPlayerManagerPause_Manual = 1,//手动暂停
    YXPlayerManagerPause_Backstage = 2,//退入后台暂停
    YXPlayerManagerPause_Next = 3,//进入下一界面
    YXPlayerManagerPause_Abnormal = 4,//异常界面
};
typedef NS_ENUM(NSInteger, YXPlayerManagerAbnormalStatus) {
    YXPlayerManagerAbnormal_Finish,//视频完成
    YXPlayerManagerAbnormal_Empty,//视频为空
    YXPlayerManagerAbnormal_NotWifi,//非wifi
    YXPlayerManagerAbnormal_PlayError,//播放出错
    YXPlayerManagerAbnormal_NetworkError,//网络出错
    YXPlayerManagerAbnormal_DataError,//数据出错
};
typedef NS_ENUM(NSInteger, VideoPlayFromType) {
    VideoPlayFromType_PlayButton,//视频播放浮窗
    VideoPlayFromType_PromptView//视频提示引导页
};

@interface VideoPlayerManagerView : UIView
//跳转的来源
@property(nonatomic, assign) VideoPlayFromType type;
//播放视图相关
@property (nonatomic, assign) BOOL isFullscreen;
@property(nonatomic, strong) VideoItem *item;

//播放相关状态
@property (nonatomic, assign) YXPlayerManagerPauseStatus pauseStatus;
@property (nonatomic, assign) YXPlayerManagerAbnormalStatus playerStatus;
@property (nonatomic, assign) BOOL isWifiPlayer;//WIFI先允许播放

@property (nonatomic, copy) void (^playerManagerBackActionBlock)(void);
@property (nonatomic, copy) void (^playerManagerRotateActionBlock)(void);
@property (nonatomic, copy) void (^playerManagerPlayerActionBlock)(YXPlayerManagerAbnormalStatus status);
@property (nonatomic, copy) void (^playerManagerFinishActionBlock)(void);
@property (nonatomic, copy) void (^playerManagerFoldActionBlock)(void);

- (void)viewWillAppear;
- (void)viewWillDisappear;
- (void)playVideo;
- (void)pauseVideo;
- (void)playVideoClear;
@end

