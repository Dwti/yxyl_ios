//
//  QACameraOverlayView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/13.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QACameraOverlayView : UIView
@property (nonatomic, strong) void(^albumBlock)();
@property (nonatomic, strong) void(^cameraBlock)();
@property (nonatomic, strong) void(^exitBlock)();
@end
