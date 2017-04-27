//
//  YXSmartDashLineView.h
//  abc
//
//  Created by niuzhaowang on 16/1/20.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXSmartDashLineView : UIView

@property (nonatomic, strong) UIColor *lineColor; // 线的颜色，默认为白色

@property (nonatomic, assign) CGFloat dashWidth; // 虚线每段的宽度，默认为6
@property (nonatomic, assign) CGFloat gapWidth; // 两段间隔的宽度，默认为4

@property (nonatomic, assign) BOOL symmetrical; // 是否对称显示，YES会使两段对称，默认是NO

@end
