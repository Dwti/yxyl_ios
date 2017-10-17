//
//  HeadImagePickerOptionView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/19.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadImagePickerOptionView : UIView
@property (nonatomic, strong) void (^albumBlock)(void);
@property (nonatomic, strong) void (^cameraBlock)(void);
@property (nonatomic, strong) void (^cancelBlock)(void);
@end
