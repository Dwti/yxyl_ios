//
//  USCRecognizer.h
//  usc
//
//  Created by hejinlai on 12-11-3.
//  Copyright (c) 2012年 yunzhisheng. All rights reserved.
//
// V 2.20.7 online

#import <Foundation/Foundation.h>
#import <UIKit/UIApplication.h>

typedef NS_ENUM(NSInteger, AudioType) {
    AudioType_PCM,
    AudioType_MP3,
};

@protocol USCRecognizerDelegate <NSObject>
@optional
/**
 *引擎初始化结束，error为nil表示成功
 */
- (void)oralEngineDidInit:(NSError *)error;


/**
 *录音启动完成
 *为了防止前半部分语音被截断的现象
 *建议在此方法回调后，再提醒用户开始说话
 */
- (void)onBeginOral;


/**
 *录音结束
 */
- (void)onStopOral;


/**
 *口语测评结果，isLast表示是否为最后一次
 */
- (void)onResult:(NSString *)result isLast:(BOOL)isLast;


/**
 *口语测评结束，error为nil表示成功，否则表示失败
 */
- (void)onEndOral:(NSError *)error;


/**
 *VAD超时
 */
- (void)onVADTimeout;


/**
 *音量大小:0~100
 */
- (void)onUpdateVolume:(int)volume;


/**
 *录音数据
 *编码格式为通过audioType设置，默认为PCM
 */
- (void)onRecordingBuffer:(NSData *)recordingData;

/**
 *  opus编码音频数据
 */
- (void)onRecordingOpusBuffer:(NSData* )opusData;

/**
 *录音数据上传至云端，返回url
 */
- (void)audioFileDidRecord:(NSString *)url;


/**
 *延时评测的结果，保存在服务端，访问url即可获取
 */
- (void)onAsyncResult:(NSString *)url;

@end



@interface USCRecognizer : NSObject

/**
 * 口语测评文本
 */
@property (nonatomic, strong) NSString *oralText;


@property (nonatomic, weak) id <USCRecognizerDelegate> delegate;

/**
 * 口语评测模式
 */
@property (nonatomic, strong) NSString *oralTask;

/**
 * 回调的音频数据格式（默认为PCM）
 */
@property (nonatomic, assign) AudioType audioType;

/**
 *启用延时评测（默认为 NO,不启用）
 *仅在纯在线模式下生效
 *启用延时评测后将不再触发备份机制
 */
@property (nonatomic, assign) BOOL asyncRecognize;

/**
 *  vad是否开启的控制参数（默认为NO不开启）
 */
@property (nonatomic, assign) BOOL vadControl;

/**
 *  设置获取评测结果的等待时间
 */
@property (nonatomic, assign) NSTimeInterval getResultTimeout;

/**
 *获取SDK版本号
 */
+ (NSString*)version;

/**
 *初始化(在线识别)
 */
- (id)init;

/**
 *初始化(混合识别)
 *资源文件路径
 */
- (id)initWithSource:(NSString *)sourcePath;

/**
 *开始录音
 */
- (void)start;

/**
 *停止录音
 */
- (void)stop;

/**
 *取消录音
 *取消和停止录音只能调用一次否则会报错
 */
- (void)cancel;

/**
 *读取pcm格式的音频文件进行识别
 */
- (void)startWithPCM:(NSString *)path;

/**
 *设置vad前置端点和后置端点的静音时间，单位ms，默认frontTime 3000，backTime 1000
 *不调用本接口将不会启用VAD
 */
- (void)setVadFrontTimeout:(int)frontTime backTimeout:(int)backTime;


/**
 *设置设备唯一标识
 *默认使用 identifierForVendor
 */
- (void)setIdentifier:(NSString *)identifier;

/**
 *设置打分系数（取值范围：0.6 ~ 1.9）1.9最宽松  0.6最严谨  1.0为默认值
 */
- (void)setOutScoreCoefficient:(float)score;


/**
 *  在混合模式下 只使用纯在线评测  默认不开启 设置一次只对单次评测有效
 */
- (void)setIsOnlineWhenMix:(BOOL)isOnline;

/**
 *  设置离线结果等待时长（离在线混合模式下得到离线评测结果后等待在线评测结果的时长）
 *  此函数仅在离在线混合模式下生效
 *  默认等待时长为1.0秒
 *  @param time 等待时长
 */
- (void)setOfflineResultWaitingTime:(NSTimeInterval)time;

/**
 *  通过缓存的opus音频文件进行评测
 *
 *  @param filePath opus音频文件路径
 */
- (void)retryWithFilePath:(NSString* )filePath;

/**
 *  更换http评测地址，如无必要无需设置，使用默认ip
 *
 *  @param ipStr 更换的http ip
 */
- (void)changeHttpIp:(NSString* )ipStr;

/**
 *  修改私有协议访问ip地址和端口号
 *  注：ip地址和端口号必须同时存在
 *
 *  @param server ip地址
 *  @param port   端口号
 */
- (void)setPrivateEvaluatingWithServer:(NSString* )server Port:(NSString* )port;

/**
 *  设置http评测Host,如无必要无需设置
 *
 *  @param value 更换的Host值 格式：yzs.17zuoye.com
 *  注：host:yzs.17zuoye.com  只需要传入: 以后的字符串即yzs.17zuoye.com
 */
- (void)setHttpHostValue:(NSString* )value;

@end


//last record 2017.3.21.1108
