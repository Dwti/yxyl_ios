//
//  SlideProgressControl.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/10/13.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideProgressControl : UIControl
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, assign) CGFloat playProgress;
@property (nonatomic, assign) CGFloat bufferProgress;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) BOOL bSliding;

- (void)updateUI;

@end
