//
//  LePlayerView.m
//  MyTest
//
//  Created by CaiLei on 12/11/14.
//  Copyright (c) 2014 leso. All rights reserved.
//

#import "LePlayerView.h"
#import <AVFoundation/AVFoundation.h>

@implementation LePlayerView

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (AVPlayer *)player {
    return [(AVPlayerLayer *)[self layer] player];
}

- (void)setPlayer:(AVPlayer *)player {
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}

@end
