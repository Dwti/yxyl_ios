//
//  AudioManager.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/8/16.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "AudioManager.h"
#import "LePlayer.h"

@interface AudioManager()
@property (nonatomic, strong) LePlayer *player;
@end

@implementation AudioManager

+ (instancetype)sharedInstance {
    static AudioManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AudioManager alloc] init];
    });
    return sharedInstance;
}

- (void)playSoundWithUrl:(NSURL *)url {
    self.player = [[LePlayer alloc]init];
    self.player.videoUrl = url;
}

@end
