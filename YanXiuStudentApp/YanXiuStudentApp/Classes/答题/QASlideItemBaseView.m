//
//  QASlideItemBaseView.m
//  SlideDemo
//
//  Created by niuzhaowang on 2016/9/23.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "QASlideItemBaseView.h"

@implementation QASlideItemBaseView

- (void)setIsForeground:(BOOL)isForeground{
    if (_isForeground == isForeground) {
        return;
    }
    _isForeground = isForeground;
    if (isForeground) {
        [self enterForeground];
    }else{
        [self leaveForeground];
    }
}

- (void)enterForeground{
    
}

- (void)leaveForeground{
    
}

@end
