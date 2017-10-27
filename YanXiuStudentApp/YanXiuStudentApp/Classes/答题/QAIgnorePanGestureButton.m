//
//  QAIgnorePanGestureButton.m
//  YanXiuStudentApp-iPhone
//
//  Created by LiuWenXing on 2017/10/20.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAIgnorePanGestureButton.h"

@implementation QAIgnorePanGestureButton

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isMemberOfClass:[UIPanGestureRecognizer class]]) {
        return NO;
    }
    return YES;
}

@end
