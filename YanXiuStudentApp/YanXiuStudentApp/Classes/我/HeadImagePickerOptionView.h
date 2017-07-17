//
//  HeadImagePickerOptionView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/19.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadImagePickerOptionView : UIView
@property (nonatomic, strong) void (^albumBlock)();
@property (nonatomic, strong) void (^cameraBlock)();
@property (nonatomic, strong) void (^cancelBlock)();
@end
