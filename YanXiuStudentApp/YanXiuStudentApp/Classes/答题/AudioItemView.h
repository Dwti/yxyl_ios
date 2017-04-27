//
//  VoiceView.h
//  YanXiuStudentApp
//
//  Created by Yu Fan on 1/20/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LePlayer.h"

typedef NS_ENUM(NSUInteger, AudioPlayState) {
    AudioPlayState_Playing = 0,
    AudioPlayState_Stopped,     // 手动暂停
    AudioPlayState_Finished,    // 自动播放结束
    AudioPlayState_Default
};

@interface AudioItemView : UIView
@property (nonatomic, strong) QAAudioComment *audioComment;
@property (nonatomic, assign) AudioPlayState state;
@property (nonatomic, strong) UIView *voiceView;
@property (nonatomic, assign) BOOL isPlayed;
@property (nonatomic, copy) void (^playFinished) (NSInteger index);
@end
