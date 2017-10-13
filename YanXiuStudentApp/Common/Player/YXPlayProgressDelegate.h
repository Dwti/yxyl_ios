//
//  YXPlayProgressDelegate.h
//  YanXiuApp
//
//  Created by Lei Cai on 6/23/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YXPlayProgressDelegate <NSObject>
@optional
- (void)playerProgress:(CGFloat)progress totalDuration:(NSTimeInterval)duration stayTime:(NSTimeInterval)time;
- (CGFloat)preProgress;
@end
