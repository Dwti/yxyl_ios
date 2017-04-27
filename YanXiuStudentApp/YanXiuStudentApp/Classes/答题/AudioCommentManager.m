//
//  VoicePlayerManager.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 1/20/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "AudioCommentManager.h"
#import "AudioItemView.h"

@interface AudioCommentManager ()
@property (nonatomic, strong) NSMutableArray *currentPlayQueue;
@property (nonatomic, strong) AudioItemView *lastPlayedItem;
@end

@implementation AudioCommentManager
- (instancetype)init {
    self = [super init];
    if (self) {
        self.itemArray = [[NSMutableArray alloc] init];
        self.currentPlayQueue = [[NSMutableArray alloc] init];
        self.lastPlayedItem = [[AudioItemView alloc] init];
    }
    return self;
}

- (void)setup {

    for (AudioItemView *item in self.itemArray) {
        item.state = AudioPlayState_Default;
        item.isPlayed = NO;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [item.voiceView addGestureRecognizer:tap];
        
        WEAK_SELF;
        [item setPlayFinished:^(NSInteger index) {
            STRONG_SELF;
            [self refreshCurrentPlayQueue:index];
            [self autoPlayNextVoice];
        }];
    }
}

- (void)tapAction:(UITapGestureRecognizer *)gesture {
    
    AudioItemView *item = (AudioItemView *)gesture.view.superview.superview;
    
    if (item.state == AudioPlayState_Default) {
        self.lastPlayedItem.state = AudioPlayState_Stopped;
        item.state = AudioPlayState_Playing;
        self.lastPlayedItem = item;
        
    } else if (item.state == AudioPlayState_Playing) {
        self.lastPlayedItem.state = AudioPlayState_Stopped;
        item.state = AudioPlayState_Stopped;
        
    } else if (item.state == AudioPlayState_Stopped) {
        self.lastPlayedItem.state = AudioPlayState_Stopped;
        item.state = AudioPlayState_Playing;
        self.lastPlayedItem = item;

    } else if (item.state == AudioPlayState_Finished) {
        self.lastPlayedItem.state = AudioPlayState_Stopped;
        item.state = AudioPlayState_Playing;
        self.lastPlayedItem = item;
    }
}

- (void)refreshCurrentPlayQueue:(NSInteger)currentIndex {
    [self.currentPlayQueue removeAllObjects];
    
    for (int i = (int)currentIndex + 1; i < self.itemArray.count; i++) {
        AudioItemView *item = (AudioItemView *)self.itemArray[i];
        [self.currentPlayQueue addObject:item];
    }
}

- (void)autoPlayNextVoice {
    AudioItemView *item = (AudioItemView *)[self.currentPlayQueue firstObject];
    item.state = AudioPlayState_Playing;
    self.lastPlayedItem = item;
    if (self.currentPlayQueue.count != 0) {
        [self.currentPlayQueue removeObjectAtIndex:0];
    }
}

- (void)stopPlayAll {
    [self.itemArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AudioItemView *item = (AudioItemView *)obj;
        item.state = AudioPlayState_Finished;
    }];
}

@end
