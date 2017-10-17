//
//  HeadImageCameraOverlayView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/17.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadImageCameraOverlayView : UIView
@property (nonatomic, strong) void(^switchBlock)(void);
@property (nonatomic, strong) void(^cameraBlock)(void);
@property (nonatomic, strong) void(^exitBlock)(void);
@end
